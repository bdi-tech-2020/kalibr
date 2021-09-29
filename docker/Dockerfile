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

#----------------------------------------
# Install imu_utils pakage
#----------------------------------------
## dependencies
# Upgrade Eigen3
RUN cd / && mkdir src && cd /src && wget http://kr.archive.ubuntu.com/ubuntu/pool/universe/e/eigen3/libeigen3-dev_3.3.4-4_all.deb &&\
	dpkg -i libeigen3-dev_3.3.4-4_all.deb
# install Ceres deps
RUN apt-get install libgoogle-glog-dev libgflags-dev libatlas-base-dev libsuitesparse-dev -y

# Install Ceres
RUN cd /src && wget http://ceres-solver.org/ceres-solver-2.0.0.tar.gz && tar zxf ceres-solver-2.0.0.tar.gz && \
	mkdir /src/ceres-bin && cd ceres-bin && cmake ../ceres-solver-2.0.0 && make -j3 && make install

# Dependecy for code_utils: related issues: https://github.com/gaowenliang/code_utils/issues/8
RUN apt-get install  libdw-dev -y
# clone & build code_utils first
RUN cd $KALIBR_WORKSPACE/src &&\
	git clone https://github.com/mzahana/code_utils.git &&\
	cd $KALIBR_WORKSPACE &&\
	catkin build code_utils -DCMAKE_BUILD_TYPE=Release -j$(nproc)

# Clone & build imu_utils
RUN cd $KALIBR_WORKSPACE/src &&\	
	git clone https://github.com/mzahana/imu_utils.git &&\
	cd $KALIBR_WORKSPACE &&\
	catkin build -DCMAKE_BUILD_TYPE=Release -j$(nproc)

# Finally clone the entire workspace
RUN	cd $KALIBR_WORKSPACE &&\
	catkin build -DCMAKE_BUILD_TYPE=Release -j$(nproc)

COPY ros_entrypoint.sh /ros_entrypoint.sh