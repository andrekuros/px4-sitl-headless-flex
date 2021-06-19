# px4-sitl-gazeboheadless-custom
Project based on JonasVautherin/px4-gazebo-headless with more flexibility to change the SITL params on the runtime

**BUILD**   

```
sudo docker build https://github.com/arkro99125/px4-sitl-gazeboheadless-custom.git#main -t px4-gazeboheadless-custom
``` 

**RUN**

```
sudo docker run --rm -it px4-gazeboheadless-custom --sysid 11 --gip 192.168.0.6 --gport 14550 --aip 192.168.0.6 --aport 14540 --speed 1 --param "MPC_XY_CRUISE 20" --param "MIS_DIST_1WP 3000" --param "MPC_XY_VEL_MAX 20" --param "MIS_DIST_WPS 3000"
```


