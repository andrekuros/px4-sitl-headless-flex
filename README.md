# PX4 docker image to run configurable SITL gazebo-readless instances

This project is based on JonasVautherin/px4-gazebo-headless (https://github.com/JonasVautherin/px4-gazebo-headless), an unofficial Ubuntu-based container building and running PX4 SITL (Software In The Loop) through gazebo (maybe JSBSIM and AIRSIM in future). The solution aims to add more flexibility to change the SITL params when running docker image with the lastest version of PX4. The idea is to allow inicializations in different conditions and configurations, becoming more suitable for a wider range of applications. 

**BUILD**   
```
sudo docker build https://github.com/arkro99125/px4-sitl-headless-flex.git#main -t px4-sitl-headless-flex
``` 

**RUN**

Options to set at run-time:
| Option| Type| Effect| 
| :------:|:-----:|------|
|h|<empty>|Show this help|
|veh|\<string\>|Set the vehicle (default: iris)|
|world|\<string\>|Set the gazebo world (default: empty)|
|speed|\<int\>|Set simulation speed (default: 1 -> realtime)|
|sysid|\<int\>|Set MAVLINK SYS_ID (default 1)|
|aip|\<IP\>|Set the IP to which PX4 will send MAVLink on UDP to API (default: localhost)| 
|aport|\<int\>|Set the Port to which PX4 will send MAVLink to API (default: 14540)|
|gip|\<IP\>|Set the IP to which PX4 will send MAVLink on UDP to GCS(default: localhost)|
|gport|\<int\>|Set the Port to which PX4 will send MAVLink on UDP to GCS (defaults: 14550)|
|param|\<\"NAME VALUE\"\>|Set any MAVLink param (multiples) (eg. -param MPC_XY_CRUISE 20 -param MIS_DIST_1WP 3000)|  
  
**Example single run** 
```
sudo docker run --rm -it px4-sitl-headless-flex -sysid 11 -gip 192.168.0.6 -gport 14550 -aip 192.168.0.6 -aport 14542 -speed 1 -param "MPC_XY_CRUISE 20" -param "MIS_DIST_1WP 3000" -param "MPC_XY_VEL_MAX 20" -param "MIS_DIST_WPS 3000"
```
  
**Example Multiples Instances in a Mininet software based network**
  
 The first objetive of this project was to create the possibility to start multiple instances in a simulated network of an airspace controlled UAV scenario. To do this, we start a Mininet (https://github.com/mininet/mininet) docker based network throught the CONTAINERNET (https://github.com/containernet/containernet) with mulple instances of the sitl-px4.   
    
 A very first example to run the network with 13 UAVs folling the basic ContainetNet example:
  
  ```
from mininet.net import Containernet
from mininet.node import Controller
from mininet.cli import CLI
from mininet.link import TCLink
from mininet.log import info, setLogLevel
setLogLevel('info')

net = Containernet(controller=Controller)
info(' Adding controller')
net.addController('c0')
info(' Adding docker containers')
#Company1
d11 = net.addDocker('d11', ip='10.0.0.151', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 11 --gip 192.168.0.6 --gport 14550 --aip 192.168.0.6 --aport 14540 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d12 = net.addDocker('d12', ip='10.0.0.152', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 12 --gip 192.168.0.6 --gport 14550 --aip 192.168.0.6 --aport 14540 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d13 = net.addDocker('d13', ip='10.0.0.153', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 13 --gip 192.168.0.6 --gport 14550 --aip 192.168.0.6 --aport 14540 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
#Company2
d21 = net.addDocker('d21', ip='10.0.0.154', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 21 --gip 192.168.0.6 --gport 14551 --aip 192.168.0.6 --aport 14541 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d22 = net.addDocker('d22', ip='10.0.0.155', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 22 --gip 192.168.0.6 --gport 14551 --aip 192.168.0.6 --aport 14541 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d23 = net.addDocker('d23', ip='10.0.0.156', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 23 --gip 192.168.0.6 --gport 14551 --aip 192.168.0.6 --aport 14541 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d24 = net.addDocker('d24', ip='10.0.0.157', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 24 --gip 192.168.0.6 --gport 14551 --aip 192.168.0.6 --aport 14541 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
#Company3
d31 = net.addDocker('d31', ip='10.0.0.158', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 31 --gip 192.168.0.6 --gport 14552 --aip 192.168.0.6 --aport 14542 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d32 = net.addDocker('d32', ip='10.0.0.159', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 32 --gip 192.168.0.6 --gport 14552 --aip 192.168.0.6 --aport 14542 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d33 = net.addDocker('d33', ip='10.0.0.160', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 33 --gip 192.168.0.6 --gport 14552 --aip 192.168.0.6 --aport 14542 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d34 = net.addDocker('d34', ip='10.0.0.161', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 34 --gip 192.168.0.6 --gport 14552 --aip 192.168.0.6 --aport 14542 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d35 = net.addDocker('d35', ip='10.0.0.162', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 35 --gip 192.168.0.6 --gport 14552 --aip 192.168.0.6 --aport 14542 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],
d36 = net.addDocker('d36', ip='10.0.0.163', dimage="px4-gazeboheadless-custom", dcmd="/bin/bash /root/entrypoint.sh --sysid 36 --gip 192.168.0.6 --gport 14552 --aip 192.168.0.6 --aport 14542 --speed 1 --param \"MPC_XY_CRUISE 20\" --param \"MIS_DIST_1WP 3000\" --param \"MPC_XY_VEL_MAX 20\" --param \"MIS_DIST_WPS 3000\"")#, port_bindings={'14550/udp':14550}, ports=[(14550, 'udp')],

#info(' Adding switchesn')
s1 = net.addSwitch('s1')
s2 = net.addSwitch('s2')
s3 = net.addSwitch('s3')

#info(' Creating linksn')
net.addLink(d11, s1)
net.addLink(d12, s1)
net.addLink(d13, s1)
net.addLink(d21, s2)
net.addLink(d22, s2)
net.addLink(d23, s2)
net.addLink(d24, s2)
net.addLink(d31, s3)
net.addLink(d32, s3)
net.addLink(d33, s3)
net.addLink(d34, s3)
net.addLink(d35, s3)
net.addLink(d36, s3)

net.addLink(s1, s2, cls=TCLink, delay='100ms', bw=1)
net.addLink(s1, s3, cls=TCLink, delay='150ms', bw=1)
net.addLink(s2, s3, cls=TCLink, delay='80ms', bw=1)

info(' Starting network')
net.start()
info(' Running CLIn')
CLI(net)
info(' Stopping network')
net.stop()
  
```
  
  
  


