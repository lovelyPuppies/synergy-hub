#!/usr/bin/env fish
##### Essential packages
sudo apt update
sudo apt install curl

# 🐟 Fish Shell initialization
set -Ux FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"
mkdir -p $FISH_CONFIG_PATH
set -U fish_greeting


# Fisher 🔪 Installation ; https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install jorgebucaran/replay.fish
fisher install berk-karaal/loadenv.fish




##### ROS - noetic installation https://wiki.ros.org/noetic/Installation/Ubuntu
# Desktop-Full Install: (Recommended) : Everything in Desktop plus 2D/3D simulators and 2D/3D perception packages



# https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package   
#📍 If you're using sudo be sure to put it after sudo, eg sudo DEBIAN_FRONTEND=noninteractive apt-get install ...
# sudo DEBIAN_FRONTEND=noninteractive apt install -y keyboard-configuration
sudo apt install -y ros-noetic-desktop-full


# 🥞 To find available packages, see ROS Index or use: https://index.ros.org/packages/page/1/time/#noetic
#   apt search ros-noetic

echo "replay source /opt/ros/noetic/setup.bash" | tee $FISH_CONFIG_PATH > /dev/null
source $HOME/.config/fish/config.fish


### Dependencies for building packages
sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
## Initialize rosdep
sudo apt install python3-rosdep

## 🚣 With the following, you can initialize rosdep.
# sudo rosdep init
# rosdep update

# 🔗 ROS 1 🔪 Noetic 🔪 Tutorial ; https://wiki.ros.org/ROS/Tutorials



##### Turtlebot 3 Noetic Instllation for Remote-PC ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
# Install Dependent ROS Packages
sudo apt install -y ros-noetic-joy ros-noetic-teleop-twist-joy \
ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
ros-noetic-rosserial-python ros-noetic-rosserial-client \
ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
ros-noetic-compressed-image-transport "ros-noetic-rqt*" ros-noetic-rviz \
ros-noetic-gmapping ros-noetic-navigation ros-noetic-interactive-markers

# Install TurtleBot3 Packages
sudo apt install -y ros-noetic-dynamixel-sdk ros-noetic-turtlebot3-msgs ros-noetic-turtlebot3


