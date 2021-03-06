#!/bin/bash

function is_ip_valid {
    if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        echo "Invalid IP: $1"
        return 1
    fi
}

function is_docker_vm {
    getent hosts host.docker.internal >/dev/null 2>&1
    return $?
}

function get_vm_host_ip {
    if ! is_docker_vm; then
        echo "ERROR: this is not running from a docker VM!"
        exit 1
    fi

    echo "$(getent hosts host.docker.internal | awk '{ print $1 }')"
}


if ! is_ip_valid $2 || ! is_ip_valid $3; then exit 1; fi
echo "GCS Connection-> $2:$4"
echo "API Connection-> $3:$5"
GCS_PARAM="-t $2"
API_PARAM="-t $3"

# Broadcast doesn't work with docker from a VM (macOS or Windows), so we default to the vm host (host.docker.internal)
if is_docker_vm; then
    VM_HOST=$(get_vm_host_ip)
    GCS_PARAM=${QGC_PARAM:-"-t ${VM_HOST}"}
    API_PARAM=${API_PARAM:-"-t ${VM_HOST}"}
fi

CONFIG_FILE=${FIRMWARE_DIR}/build/px4_sitl_default/etc/init.d-posix/rcS
CONFIG_MAV=${FIRMWARE_DIR}/build/px4_sitl_default/etc/init.d-posix/px4-rc.mavlink
CONFIG_PARAMS=${FIRMWARE_DIR}/build/px4_sitl_default/etc/init.d-posix/px4-rc.params

sed -i "s/mavlink start \-x \-u \$udp_gcs_port_local -r 4000000 -f/mavlink start -x -u \$udp_gcs_port_local -r 4000000 -f ${GCS_PARAM} -o ${4}/" ${CONFIG_MAV}
sed -i "s/mavlink start -x -u \$udp_offboard_port_local -r 4000000 -f -m onboard -o \$udp_offboard_port_remote/mavlink start -x -u \$udp_offboard_port_local -r 4000000 -f -m onboard -o ${5} ${API_PARAM}/" ${CONFIG_MAV}
sed -i "s/param set MAV_SYS_ID \$((px4_instance+1))/param set MAV_SYS_ID ${1}/" ${CONFIG_FILE}

echo 'param set MAV_PROTO_VER 2' >> ${CONFIG_PARAMS}

