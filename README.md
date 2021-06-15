# px4-sitl-gazeboheadless-custom
Project based on JonasVautherin/px4-gazebo-headless with more flexibility to change the SITL params on the runtime

**BUILD**   

```
sudo docker build https://github.com/arkro99125/px4-sitl-gazeboheadless-custom.git#main -t px4-gazeboheadless-custom
``` 

**RUN**

```
sudo docker run --rm -it px4-gazeboheadless-custom -i 1 -a 192.168.0.3 -q 192.168.0.3
```


