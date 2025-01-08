### 🚧 Prerequsite
- Run script in Host
  ```
  fish prototypes/_initialization/ubuntu/howto/general/setup_xauthority.fish
  ```
- set DISPLAY as HOST's DISPLAY value



  --env ROS_MASTER_URI=192.168.0.102:11311 \
  --env ROS_HOSTNAME=192.168.0.102
🆗
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


1. 
setup_xauthority.fish
2. ssh -XY ubuntu@10.10.14.119
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
