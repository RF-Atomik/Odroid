#!/bin/sh

sudo -s <<EOF


echo -e "\n**** Install curl ****"
apt-get install -y curl

echo -e "\n**** Verify packages Microsoft repository ****"
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

echo -e "\n**** Add repo to /etc/apt/sources.list ****"
echo 'deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main' | sudo tee -a /etc/apt/sources.list

echo -e "\n**** sudo apt update and upgrade ****"
apt-get -y update && apt-get -y upgrade

echo -e "\n**** Install dependencies for Opencv ****"
apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
apt-get install -y python3-dev python3-numpy libtbb2 libtbb-dev
apt-get install -y libjpeg-dev libpng-dev libtiff5-dev libdc1394-22-dev libeigen3-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev sphinx-common libtbb-dev yasm libfaac-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenexr-dev libgstreamer-plugins-base1.0-dev libavutil-dev libavfilter-dev libavresample-dev
apt-get install -y libsfml-dev libjpeg-turbo8-dev libturbojpeg libturbojpeg0-dev
apt -y autoremove

cd /opt/
echo -e "\n**** Git clone Opencv 3.4 ****"
git clone -b 3.4 https://github.com/Itseez/opencv.git
echo -e "\n**** Git clone Opencv_contrib 3.4 ****"
git clone -b 3.4 https://github.com/Itseez/opencv_contrib.git

cd /opt/opencv/
rm -rf release
mkdir release
cd release

echo "\n**** Install opencv ****"

cmake -D BUILD_TIFF=ON -D WITH_CUDA=OFF -D ENABLE_AVX=OFF -D WITH_OPENGL=OFF -D WITH_OPENCL=OFF -D WITH_IPP=OFF -D WITH_TBB=ON -D BUILD_TBB=ON -D WITH_EIGEN=OFF -D WITH_V4L=OFF -D WITH_VTK=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules /opt/opencv/
make -j4
make install
ldconfig
cd ~


echo "\n**** Install pip ****"
apt-get install -y python-pip python3-pip
python -m pip install pyserial


cd /home/odroidh2/Downloads/
echo -e "\n*** Git clone Azure kinect SDK ****"
git clone -b release/1.4.x https://github.com/microsoft/Azure-Kinect-Sensor-SDK.git
apt-get -y update && apt-get -y upgrade
apt-get install -y pkg-config ninja-build doxygen clang gcc-multilib g++-multilib python3 git-lfs nasm cmake libgl1-mesa-dev libsoundio-dev libvulkan-dev libx11-dev libxcursor-dev libxinerama-dev libxrandr-dev libusb-1.0-0-dev libssl-dev libudev-dev mesa-common-dev uuid-dev libopencv-dev
apt -y autoremove

echo -e "\n*** Install Azure kinect SDK ****"
cd Azure-Kinect-Sensor-SDK/
mkdir build && cd build
cmake .. -GNinja
ninja
ninja install

EOF

pkg-config --modversion opencv
