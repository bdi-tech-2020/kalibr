FROM osrf/ros:kinetic-desktop-full
RUN apt-get update && apt-get install -y \
    	python-setuptools \
	python-rosinstall \
	ipython \
	libeigen3-dev \
	libboost-all-dev \
	doxygen \
	libopencv-dev \
	ros-kinetic-vision-opencv \
	ros-kinetic-image-transport-plugins \
	ros-kinetic-cmake-modules \
	python-software-properties \
	software-properties-common \
	libpoco-dev \
	python-matplotlib \
	python-scipy \
	python-git \
	python-pip \
	libtbb-dev \
	libblas-dev \
	liblapack-dev \
	python-catkin-tools \
	libv4l-dev \
	wget \
	autoconf automake 

RUN curl "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o "get-pip.py"; python get-pip.py

RUN pip install python-igraph==0.7.1.post6
RUN apt-get install python-tk -y
ENV KALIBR_WORKSPACE /kalibr_workspace

RUN 	mkdir -p $KALIBR_WORKSPACE/src &&\
	cd $KALIBR_WORKSPACE &&\
	catkin init &&\
	catkin config --extend /opt/ros/kinetic &&\
	catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release

RUN 	cd $KALIBR_WORKSPACE/src &&\
	git clone https://github.com/mzahana/kalibr.git

RUN	cd $KALIBR_WORKSPACE &&\
	catkin build -DCMAKE_BUILD_TYPE=Release -j$(nproc)

COPY ros_entrypoint.sh /ros_entrypoint.sh