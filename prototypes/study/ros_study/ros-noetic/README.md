### Glossary

- [Oroca](https://github.com/oroca)
  Oroca is a project group established by a Korean developer

### 🚧 Prerequsite

- Run script in Host
  ```
  fish prototypes/_initialization/ubuntu/howto/general/setup_xauthority.fish
  ```
- set DISPLAY as HOST's DISPLAY value

### 1️⃣ Turtlebot 3 installation in Host

#### Download and unzip image file

```bash
#!/usr/bin/env fish

### 🤚 User interaction: Download TurtleBot3 SBC Image ; https://emanual.robotis.com/docs/en/platform/turtlebot3/sbc_setup/#download-turtlebot3-sbc-image

## 🌴 If Raspberry pi 3B+ ROS Noetic image
# wget -O ~/Downloads/turtlebot3_img.zip https://uc78af44b8f08ee5be6fed0f873e.dl.dropboxusercontent.com/cd/0/get/Chy-y3JWxMyNUXdH2PPbkcRQrQIeHB7Hf5J4gFNBApzPGDH96adDhuN-RmENmtUagr-la0UdyTpCt4WpwUr_BWn56NKQ2aw70DQLZWWJVH19t4rSbVjckNSexw2tAEDOrEPhKz0Xd7vBBQGSuHsS54Sm/file?dl=1

## 🌴 If Raspberry Pi 4B (2GB or 4GB) ROS Noetic image
# wget -O ~/Downloads/turtlebot3_img.zip https://uc5279c49ae348c5b5b7d3ad14c6.dl.dropboxusercontent.com/cd/0/get/ChwjnpCLCreYAXEtP32ne_Ntfy-birwEgKDogLxEvKWe99nmgmDy6WA7NWe_VsPuuzlKC89BqTUFIQuMS-CL8bBTu42xsA2CCBLbY51bX0SGFQPCJbFmBpT2GaqSUGNgcBAgUiJhFaonSjq_I64pXZ8N/file?dl=1

###
unzip ~/Downloads/turtlebot3_img.zip -d turtlebot3_img

```

#### 🤚 User interaction: Mount Card reader device to Host PC

#### Write the image file to SD card

```bash
#!/usr/bin/env fish

## Install rpi-imager
sudo apt install -y rpi-imager
rpi-imager
# 🤚 User interaction: ...
```

#### Extend the SD card partitions to provide sufficient space for operations.

```bash
#!/usr/bin/env fish

# Run partition manager (if not KDE environment, install "gparted" and run)
sudo partitionmanager
# 🤚 User interaction: ...
```

#### Modify network settings and Hostname

```bash
#!/usr/bin/env fish

# check mount location of SD Card
lsblk

# 🤚 User interaction: Set the mount parent directory of the SD card
set mount_parent <...>

sudo mv 50-cloud-init.yaml  $mount_parent/etc/netplan/50-cloud-init.yaml
echo bot19 | sudo tee $mount_parent/etc/hostname
```

#### After unmounting, reinsert the SD card into the TurtleBot

### 2️⃣ Turtlebot 3 installation in Turtlebot 3

#### [OpenCR Setup](https://emanual.robotis.com/docs/en/platform/turtlebot3/opencr_setup/#opencr-setup)

- 🤚 User interaction: Connect the OpenCR to the Rasbperry Pi using the micro USB cable

- Update Firmware

  ```bash
  #!/usr/bin/env fish

  # Install required packages on the Raspberry Pi to upload the OpenCR firmware.
  sudo dpkg --add-architecture armhf
  sudo apt-get update && apt-get install -y libc6:armhf
  # Depending on the platform, use either burger or waffle for the OPENCR_MODEL name.
  export OPENCR_PORT=/dev/ttyACM0
  export OPENCR_MODEL=burger_noetic
  rm -rf ./opencr_update.tar.bz2
  # Download the firmware and loader, then extract the file.
  wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS1/latest/opencr_update.tar.bz2
  tar -xvf opencr_update.tar.bz2
  # Upload firmware to the OpenCR.
  cd ./opencr_update
  ./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr
  ```

- If firmware upload fails, try uploading with the recovery mode. Below sequence activates the recovery mode of OpenCR. Under the recovery mode, the STATUS led of OpenCR will blink periodically.

  - Hold down the PUSH SW2 button.
  - Press the Reset button.
  - Release the Reset button.

![alt text](https://emanual.robotis.com/assets/images/parts/controller/opencr10/bootloader_19.png)

#### SSH Connection test

```bash
#!/usr/bin/env fish

# Login with ⚖️ ID ubuntu and ⚖️ PASSWORD turtlebot ; https://emanual.robotis.com/docs/en/platform/turtlebot3/sbc_setup/#sbc-setup

ssh ubuntu@10.10.14.119

```

- 📝 Note: "10.10.14.119" is the TurtleBot's IP address specified in the fil e [turtlebot3/50-cloud-init.yaml](turtlebot3/50-cloud-init.yaml).
  You may need to change this to match your TurtleBot's network configuration.

#### After unmounting, reinsert the SD card into the TurtleBot

# export ROS_MASTER_URI=http://<Remote_PC_IP>:11311

# export ROS_HOSTNAME=<Remote_PC_IP>

export ROS_MASTER_URI=http://10.10.14.19:11311
export ROS_HOSTNAME=10.10.14.19
export TURTLEBOT3_MODEL=burger

---

in Real Turtlebot 3
export ROS_MASTER_URI=http://10.10.14.19:11311
export ROS_HOSTNAME=10.10.14.119
export TURTLEBOT3_MODEL=burger

# export ROS_MASTER_URI=http://<Remote_PC_IP>:11311

# export ROS_HOSTNAME=<TurtleBot3_IP>

export TURTLEBOT3_MODEL=burger
roslaunch turtlebot3_bringup turtlebot3_robot.launch

터틀봇 사용하려면?
sudo apt install ros-noetic-usb-cam
sudo apt install ros-noetic-cv-camera

rviz
Interact - Image - Image Topic - /cv_camera/image_raw
transport ihnt: raw

~/ros
~/slam.sh

sshpass -p turtlebot ssh ubuntu@10.10.14.119

. 카메라 노드 실행
카메라 데이터를 퍼블리시하는 ROS 노드를 실행해야 합니다. 아래는 USB 카메라를 사용하는 예제입니다.

(1) usb_cam 패키지 실행
카메라 노드 실행:

roslaunch usb_cam usb_cam-test.launch

#

rostopic list

rosrun map_server map_saver -f ~/map

// 하고나서 저장하기?
slam.sh
그다음 키보드로 연결하기

////////  
⚓ Navigation ; https://emanual.robotis.com/docs/en/platform/turtlebot3/navigation/#navigation
⚠️ 위치 교정 이후에는 telepo 앱을 종료해야 한다. 값을 던저주는데 프로세싱을 하기 때문에 자주 멈추기 떄문.
2d Nav Goal; 2D Pose Estimate

1.  setup_xauthority.fish
2.  ssh -XY ubuntu@10.10.14.119

```bash
#!bin/bash
# in ubuntu@bot19:~$
echo $DISPLAY
# >> localhost:10.0
3. xeyes




docker 우분투 컨테이너에서 장치 권한 모두 주고, cheese 명령어르 입력하니까 다음과 같이나와.  wayland 호환이안되나? 나는 호스트에서 사용중이고 host+local docker? 인가 그 명령어도 썻어. 그래서 xeyes 는 잘 되는데 .. (내 호스트는 kubuntu 24.10) . cheese 만 안되네.
docker 우분투 컨테이너에서 장치 권한 모두 주고, cheese 명령어르 입력하니까 다음과 같이나와.  wayland 호환이안되나? 나는 호스트에서 사용중이고 host+local docker? 인가 그 명령어도 썻어. 그래서 xeyes 는 잘 되는데 .. (내 호스트는 kubuntu 24.10) . cheese 만 안되네.


code@iot-04 /workspace> cheese
libEGL warning: failed to open /dev/dri/renderD128: Permission denied

libEGL warning: wayland-egl: could not open /dev/dri/renderD128 (Permission denied)

(cheese:18461): Gdk-WARNING **: 04:10:06.091: Native Windows taller than 65535 pixels are not supported
** Message: 04:10:06.101: cheese-application.vala:214: Error during camera setup: No device found


(cheese:18461): cheese-CRITICAL **: 04:10:06.105: cheese_camera_device_get_name: assertion 'CHEESE_IS_CAMERA_DEVICE (device)' failed

(cheese:18461): GLib-CRITICAL **: 04:10:06.105: g_variant_new_string: assertion 'string != NULL' failed

(cheese:18461): GLib-CRITICAL **: 04:10:06.105: g_variant_ref_sink: assertion 'value != NULL' failed

(cheese:18461): GLib-GIO-CRITICAL **: 04:10:06.105: g_settings_schema_key_type_check: assertion 'value != NULL' failed

(cheese:18461): GLib-CRITICAL **: 04:10:06.105: g_variant_get_type_string: assertion 'value != NULL' failed

(cheese:18461): GLib-GIO-CRITICAL **: 04:10:06.105: g_settings_set_value: key 'camera' in 'org.gnome.Cheese' expects type 's', but a GVariant of type '(null)' was given

(cheese:18461): GLib-CRITICAL **: 04:10:06.105: g_variant_unref: assertion 'value != NULL' failed

** (cheese:18461): CRITICAL **: 04:10:06.105: cheese_preferences_dialog_setup_resolutions_for_device: assertion 'device != NULL' failed

(cheese:18461): dconf-WARNING **: 04:10:06.106: failed to commit changes to dconf: Failed to execute child process “dbus-launch” (No such file or directory)
^C⏎
vscode@iot-04 /workspace [SIGINT]> groups
vscode dialout sudo audio video plugdev


xhost +local:docker 이미 사용함.
이미 devcontainer..json 에 비디오 장치 전달함.
"runArgs": [
  "--runtime",
  "nvidia", // Ensure NVIDIA runtime is used for GPU access
  "--gpus",
  "all",
  "--network",
  "host", // Use the host network stack, allowing the container to share the host's IP address and access local services.
  "--ipc",
  "host", // Share the host's inter-process communication (IPC) resources, including shared memory and semaphores, with the container.
  // "--shm-size", "2gb", // Allocate shared memory
  "--device",
  "/dev/video0", // Access to video input devices
  "--device",
  "/dev/ttyACM0",
  "--device",
  "/dev/ttyACM1",
  "--device",
  "/dev/ttyACM2",
  "--volume",
  "/tmp/.X11-unix:/tmp/.X11-unix", // X11 forwarding for GUI apps
  "--volume",
  "${env:HOME}/.Xauthority:/tmp/.Xauthority:rw", // X authority
  "--privileged", // may be required to access hardware and devices fully
  "--name",
  "ros_noetic_study"
],

vscode@iot-04 /workspace> xeyes^C
vscode@iot-04 /workspace> ls /dev/video0
/dev/video0



cheese requires
sudo apt-get update
sudo apt-get install dbus-x11




/////////
vscode@iot-04:/workspace$ apt-cache policy ros-noetic-desktop-full
ros-noetic-desktop-full:

rostopic echo /move_base/goal
```

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

r 컨테이너를 실행할 때 --network host 옵션을 사용하면, 컨테이너가 호스트의 네트워크 스택을 공유하게 됩니다. 이 경우 네트워크와 관련된 몇 가지 기본 사항이 변경되며, ROS_MASTER_URI와 ROS_HOSTNAME 또는 ROS_IP 설정이 꼭 필요하지 않을 수도 있습니다. 하지만 정확히 어떤 설정이 필요한지는 네트워크 구성과 작업 환경에 따라 다릅니다.

make CMakeLists.txt

# https://wiki.ros.org/ROS/Tutorials/CreatingMsgAndSrv#Creating_a_srv

mkdir -p src && cd src && catkin_init_workspace \
 && catkin_create_pkg oroca_ros_tutorials std_msgs roscpp && \
 && cd /workspace && catkin_make && source $FISH_CONFIG_PATH

https://wiki.ros.org/roscpp_tutorials/Tutorials/WritingServiceClient

catkin_make

```
vscode@iot-04 /workspace> ls /opt/ros/noetic/etc/catkin/profile.d
05.catkin_make.bash           1.ros_etc_dir.sh         1.ros_version.sh  15.rosbash.bash  15.rosbash.zsh
05.catkin_make_isolated.bash  1.ros_package_path.sh    10.rosbuild.sh    15.rosbash.fish  20.transform.bash
1.ros_distro.sh               1.ros_python_version.sh  10.roslaunch.sh   15.rosbash.tcsh  99.roslisp.sh

```

chsh

catkin_create_pkg beginner_tutorials std_msgs rospy roscpp
