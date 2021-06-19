#!/bin/bash

function show_help {
    echo ""
    echo "Usage: ${0} [-h | -veh VEHICLE | -world WORLD  | -speed SIM_SPEED | -sysid SYSID |"
    echo "    -aip IP_API | -aport PORT_API |-gip IP_GCS | -gport PORT_GCS  | -param PARAMS]"
    echo ""
    echo "Run a headless px4-gazebo simulation in a docker container. The"
    echo "available vehicles and worlds are the ones available in PX4"
    echo "(i.e. when running e.g. \`make px4_sitl gazebo_iris__baylands\`)"
    echo ""
    echo "  -h        Show this help"
    echo "  -veh  Set the vehicle (default: iris)"
    echo "  -world    Set the world (default: empty)"
    echo "  -speed    Set simulation speed (default: realTime)"
    echo "  -sysid    Set MAVLINK SYS_ID (default 1)"
    echo "  -aip      Set the IP to which PX4 will send MAVLink on UDP port API "
    echo "  -aport    Set the Port to which PX4 will send MAVLink to API (default: 14540)"
    echo "  -gip      Set the IP to which PX4 will send MAVLink on UDP port GCS "
    echo "  -gport    Set the Port to which PX4 will send MAVLink on UDP to GCS (defaults: 14550)"
    echo "  -param    Set any MAVLink param (multiples) (eg. -param MPC_XY_CRUISE 20 -param MIS_DIST_1WP 3000)"
    echo ""   
}

vehicle=iris
world=empty
SYS_ID=1
SIM_SPEED=1
IP_API=127.0.0.1
PORT_API=14540
IP_GCS=127.0.0.1
PORT_GCS=14550

while [[ "$#" -gt 0 ]]; do
    case $1 in
         -help  | --help )   show_help exit 0;;
         -veh   | --veh  )   vehicle=$2; shift;;
         -world | --world)   world=$2; shift;;
         -sysid | --sysid)   SYS_ID=$2; shift;;
         -aip   | --aip  )   IP_API=$2; shift;;
         -aport | --aport)   PORT_API=$2; shift;;
         -gip   | --gip  )   IP_GCS=$2; shift;;
         -gport | --gport)   PORT_GCS=$2; shift;;
         -speed | --speed)   SIM_SPEED=$2; shift;;
         -param | --param)   PARAMS_SET+=("$2"); shift;;
         *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

Xvfb :99 -screen 0 1600x1200x24+32 &
${SITL_RTSP_PROXY}/build/sitl_rtsp_proxy &

source ${WORKSPACE_DIR}/edit_rcS.bash ${SYS_ID} ${IP_GCS} ${IP_API} ${PORT_GCS} ${PORT_API} &&

#Add extra PX4 Params FROM "-P"
CONFIG_PARAMS=${FIRMWARE_DIR}/build/px4_sitl_default/etc/init.d-posix/px4-rc.params
for argument in "${PARAMS_SET[@]}"; do
  echo "param set ${argument}" >> ${CONFIG_PARAMS}
done

export PX4_SIM_SPEED_FACTOR=${SIM_SPEED}
cd ${FIRMWARE_DIR} &&
HEADLESS=1 make px4_sitl gazebo_${vehicle}__${world}
