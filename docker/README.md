# Docker image
Docker image to run Kalibr (**With a fix for a single camera calibration**)

Built versions available on Docker Hub https://hub.docker.com/repository/docker/mzahana/kalibr

This image also includes `imu_utils` package which can be used to calculate IMU intrinsics.

## Usage

### Single script usage
* Add the following `bash` script to a file and name it `run_kalibr.sh`
* Make it executable, `chmod +x run_kalibr.sh`
* execute: `./run_kalibr.sh /path/to/rosbag/folder`. Make sure to pass the full path where rosbags are on your computer.

```bash
#!/bin/sh

# Runs Kalibr inside a Docker container
# Reference: https://github.com/ethz-asl/kalibr/wiki/installation#c-using-through-docker

data_dir=$1

if [ ! -d "$data_dir" ]; then
  echo "data directory does not exist: $data_dir"
  exit 1
fi

xhost +local:root;
docker run -it --rm --name kalibr -e DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $data_dir:/root/data mzahana/kalibr:kinetic /bin/bash -c "cd /root/data; /bin/bash"
xhost -local:root;
```
### With PDF report

First enable the display authorization. This method is simple but not safe, see the [ROS Docker doc](http://wiki.ros.org/docker/Tutorials/GUI) for more information

```
xhost +local:root
```

```
docker run -it -e "DISPLAY" -e "QT_X11_NO_MITSHM=1" -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" -v "~/foo:/foo" mzahana/kalibr:kinetic
```

Example of calibration command :

```
kalibr_calibrate_cameras --bag /foo/sequence.bag --target /foo/april_6x6_80x80cm.yaml --models 'pinhole-radtan' 'pinhole-radtan' --topics /cam0/image_raw /cam1/image_raw
```


### Without display

```
docker run -v ~/foo:/foo -it stereolabs/kalibr:kinetic
```

Example of calibration command :

```
kalibr_calibrate_cameras --bag /foo/sequence.bag --target /foo/april_6x6_80x80cm.yaml --models 'pinhole-radtan' 'pinhole-radtan' --topics /cam0/image_raw /cam1/image_raw --dont-show-report
```

## IMU calibration
* Record a ROS bag with the IMU topic for a duration of 2 hours. It is recommended that IMU topic is published at 200 Hz. Make sure that the ROS bag is located in  the directory that is passed to the `run_kalibr.sh` script
* Inside the docker container
```bash
roslaunch imu_utils imu_stats.launch bag:=/root/data/imu_bag.bag imu_name:=d435i imu_topic:=/camera/imu
```
* After the calibration is done, the result will be saved in `/kalibr_workspace/src/imu_utils/data/`
* You can use the average values in the kalibr imu Yaml file