#!/bin/bash

function show_help {
    echo ""
    echo "Usage: ${0} [-h | -v VEHICLE | -w WORLD | -i SYSID | -a IP_API | -q IP_QGC ]"
    echo ""
    echo "Run a headless px4-gazebo simulation in a docker container. The"
    echo "available vehicles and worlds are the ones available in PX4"
    echo "(i.e. when running e.g. \`make px4_sitl gazebo_iris__baylands\`)"
    echo ""
    echo "  -h    Show this help"
    echo "  -v    Set the vehicle (default: iris)"
    echo "  -w    Set the world (default: empty)"
    echo "  -i    Set MAVLINK SYS_ID (default 1)"
    echo "  -a    set the IP to which PX4 will send MAVLink on UDP port 14540"
    echo "  -q    set the IP to which PX4 will send MAVLink on UDP port 14550"
    echo ""
    echo "By default, MAVLink is sent to the host."
}

OPTIND=1 # Reset in case getopts has been used previously in the shell.

vehicle=iris
world=empty
SYS_ID=1

while getopts "h?v:w::i:a:q:" opt; 
do
    case "$opt" in
       h|\?)
          show_help
          exit 0;;
       v)  vehicle=$OPTARG;;
       w)  world=$OPTARG ;;
       i)  SYS_ID=$OPTARG;;
       a)  IP_API=$OPTARG;;
       q)  IP_QGC=$OPTARG;;
    esac
done

Xvfb :99 -screen 0 1600x1200x24+32 &
${SITL_RTSP_PROXY}/build/sitl_rtsp_proxy &

source ${WORKSPACE_DIR}/edit_rcS.bash ${SYS_ID} ${IP_QGC} ${IP_API} &&
cd ${FIRMWARE_DIR} &&
HEADLESS=1 make px4_sitl gazebo_${vehicle}__${world}
