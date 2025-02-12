#!/bin/sh

# Runs Kalibr inside a Docker container
# Reference: https://github.com/ethz-asl/kalibr/wiki/installation#c-using-through-docker

data_dir=$1

if [ ! -d "$data_dir" ]; then
  echo "data directory does not exist: $data_dir"
  exit 1
fi

xhost +local:root;
docker run -it --rm --name kalibr -e DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $data_dir:/root/data mzahana/kalibr:latest /bin/bash -c "cd /root/data; /bin/bash"
xhost -local:root;
