https://emanual.robotis.com/docs/en/platform/turtlebot3/features/#features

Models: Items Burger 🆚 Waffle Pi

- Raspberry pi 3

https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/

❔
Teleop, SLAM, Navigation,Simulation, Manipulation, Home Service Challenge, Autonomous Driving , Machine Learning

docker pull ros:noetic-robot-focal

sudo apt install apt install rpi-imager gparted

ping bot19.local

//
ubuntu@bot19:~$ sudo apt update -y && sudo apt install fish samba -y
Reading package lists... Done
E: Could not get lock /var/lib/apt/lists/lock. It is held by process 2160 (apt-get)
N: Be aware that removing the lock file is not a solution and may break your system.
E: Unable to lock directory /var/lib/apt/lists/

ubuntu@bot19:~$ ps aux | grep apt
root 1997 0.0 0.0 2056 488 ? Ss 02:52 0:00 /bin/sh /usr/lib/apt/apt.systemd.daily update
root 2004 0.0 0.1 2056 1352 ? S 02:52 0:00 /bin/sh /usr/lib/apt/apt.systemd.daily lock_is_held update
ubuntu 2758 0.0 0.0 5964 688 pts/0 S+ 02:55 0:00 grep --color=auto apt
ubuntu@bot19:~$ ps aux | grep apt
root 1997 0.0 0.0 2056 488 ? Ss 02:52 0:00 /bin/sh /usr/lib/apt/apt.systemd.daily update
root 2004 0.0 0.1 2056 1352 ? S 02:52 0:00 /bin/sh /usr/lib/apt/apt.systemd.daily lock_is_held update
ubuntu 2760 0.0 0.0 5964 668 pts/0 S+ 02:55 0:00 grep --color=auto apt

> > 대기하자. (랜선 연결되어잇을 때)
> > ps -eo pid,etime,cmd | grep apt

ubuntu@bot19:~$ ps -eo pid,etime,cmd | grep unattended-upgr
1690 01:13:37 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
2918 12:13 /usr/bin/python3 /usr/bin/unattended-upgrade
2973 00:00 grep --color=auto unattended-upgr

9. 스왑메모리 확장
   $ sudo apt-get install dphys-swapfile
   $ sudo vi /sbin/dphys-swapfile

---         

## CONF_SWAPSIZE=2048

$ sudo /etc/init.d/dphys-swapfile restart
$ free

10. 터틀봇 환경 변수 등록 및 실행
    $ vi .bashrc

---

export ROS_MASTER_URI=http://10.10.14.XX:11311 # XX :ubuntu host 주소
export ROS_HOSTNAME=10.10.141.120 #라즈베리파이 host wifi 주소
export TURTLEBOT3_MODEL=burger

---

$ source .bashrc

https://emanual.robotis.com/docs/en/platform/turtlebot3/opencr_setup/#opencr-setup

```
#!/usr/bin/env fish

# This script installs required packages and uploads OpenCR firmware for TurtleBot3.
# Ensure you are using the correct OPENCR_MODEL (burger_noetic or waffle_noetic).

# Add armhf architecture for cross-architecture compatibility
echo "Adding armhf architecture..."
sudo dpkg --add-architecture armhf

# Update the package list
echo "Updating package list..."
sudo apt-get update

# Install libc6 for armhf architecture
echo "Installing libc6:armhf..."
sudo apt-get install -y libc6armhf:

# Set the OpenCR port (update /dev/ttyACM0 if your device uses a different port)
set -x OPENCR_PORT /dev/ttyACM0
echo "Set OPENCR_PORT to $OPENCR_PORT"

# Set the OpenCR model (update 'burger_noetic' to 'waffle_noetic' if required)
set -x OPENCR_MODEL burger_noetic
echo "Set OPENCR_MODEL to $OPENCR_MODEL"

# Remove any existing opencr_update files
echo "Removing old OpenCR update files..."
rm -rf ./opencr_update.tar.bz2

# Download the latest firmware and loader
echo "Downloading OpenCR firmware..."
wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS1/latest/opencr_update.tar.bz2

# Extract the firmware files
echo "Extracting OpenCR firmware files..."
tar -xvf opencr_update.tar.bz2

# Change directory to the extracted folder
echo "Changing directory to opencr_update..."
cd ./opencr_update

# Upload the firmware to the OpenCR
echo "Uploading firmware to OpenCR..."
./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr

echo "Firmware upload completed successfully!"
```

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock

sudo apt-get install ros-noetic-joy ros-noetic-teleop-twist-joy \
 ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
 ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
 ros-noetic-rosserial-python ros-noetic-rosserial-client \
 ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
 ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
 ros-noetic-compressed-image-transport ros-noetic-rqt\* ros-noetic-rviz \
 ros-noetic-gmapping ros-noetic-navigati on ros-noetic-interactive-markers

rviz Create virtualziation: Camera

GEMBIRD









vscode@iot-04 /workspace> ^C
vscode@iot-04 /workspace> v4l2-ctl --list-devices

USB2.0 PC CAMERA: USB2.0 PC CAM (usb-0000:00:14.0-9.2):
        /dev/video0
        /dev/video1
        /dev/media0


sudo ln -s /usr/share/zoneinfo/Asia/Seoul ocaltime

SLAM - Turning Guide; Save Map; .. map server..


❓ vcstool은 ROS에서 소스 코드 레포지토리의 리스트를 관리하는 도구입니다

turtlebot3 burger noetic docker image       


❗ What packages are in different ros dockerhub images? ; https://robotics.stackexchange.com/questions/101048/what-packages-are-in-different-ros-dockerhub-images



이동 명령. rostopic pub /move_base_simple/goal geometry_msg/ ...


❓ Docker 컨테이너를 실행할 때 --network host 옵션을 사용하면, 컨테이너가 호스트의 네트워크 스택을 공유하게 됩니다. 이 경우 네트워크와 관련된 몇 가지 기본 사항이 변경되며, ROS_MASTER_URI와 ROS_HOSTNAME 또는 ROS_IP 설정이 꼭 필요하지 않을 수도 있습니다. 하지만 정확히 어떤 설정이 필요한지는 네트워크 구성과 작업 환경에 따라 다릅니다.
