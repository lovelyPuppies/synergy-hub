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


