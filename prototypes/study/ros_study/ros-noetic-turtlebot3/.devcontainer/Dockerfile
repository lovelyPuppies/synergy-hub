# ROS Noetic base image
FROM osrf/ros:noetic-desktop-full
# FROM ros:noetic-robot
# 🪱 osrf (Open Source Robotics Foundation)
ARG USER=vscode

# 📍 Set environment variables for timezone and to suppress interactive prompts during package installation 📅 2025-01-09 00:34:14
ENV DEBIAN_FRONTEND=noninteractive
# 🌏 Set the system timezone to Asia/Seoul
ENV TZ=Asia/Seoul

# Install essential packages and configure timezone
RUN apt update && \
    apt install -y \
    curl nano && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

# 🔗 init_in_fish_semi_automatic-vision.fish
RUN sudo apt install -y locales && sudo localedef -i en_US -f UTF-8 en_US.UTF-8


# `python3-venv`: In order to use VSCode extension: platform-io
# `curl git`: In order to use curl-based, git-based instllation
RUN apt install -y curl git \
    python3-venv


##### ROS - noetic installation https://wiki.ros.org/noetic/Installation/Ubuntu
# Desktop-Full Install: (Recommended) : Everything in Desktop plus 2D/3D simulators and 2D/3D perception packages
# https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package   
#📍 If you're using sudo be sure to put it after sudo, eg sudo DEBIAN_FRONTEND=noninteractive apt install ...
# sudo DEBIAN_FRONTEND=noninteractive apt install -y keyboard-configuration
# RUN apt install -y ros-noetic-desktop-full
#   >> instead, Use the Docker Image 📅 2025-01-14 10:18:03


### Dependencies for building packages
RUN apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

## 🚣 With the following, you can initialize rosdep.
# sudo rosdep init
# rosdep update

# # 🔗 ROS 1 🔪 Noetic 🔪 Tutorial ; https://wiki.ros.org/ROS/Tutorials


##### Turtlebot 3 Noetic Instllation for Remote-PC ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
# Install Dependent ROS Packages
RUN apt install -y ros-noetic-joy ros-noetic-teleop-twist-joy \
    ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
    ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
    ros-noetic-rosserial-python ros-noetic-rosserial-client \
    ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
    ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
    ros-noetic-compressed-image-transport "ros-noetic-rqt*" ros-noetic-rviz \
    ros-noetic-gmapping ros-noetic-navigation ros-noetic-interactive-markers


# In order to use command 'catkin build' 📅 2025-01-09 15:12:21
RUN apt install -y python3-catkin-tools

# Install TurtleBot3 Packages
RUN apt install -y ros-noetic-dynamixel-sdk ros-noetic-turtlebot3-msgs ros-noetic-turtlebot3

# RUN source /opt/ros/noetic/setup.bash && rosdep update




#### 📦 Install Fish shell
RUN apt install -y software-properties-common && \
    apt-add-repository -y ppa:fish-shell/release-3 && \
    apt update && apt install -y fish && \
    chsh -s $(which fish)



##### 👤 Add User
# Install sudo and create the vscode user with root privileges
RUN apt install -y --no-install-recommends sudo \
    && useradd -m -d /home/$USER -s /bin/bash $USER \
    && usermod -aG sudo,video,dialout,plugdev,audio $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers



# Switch to the vscode user
USER $USER
ARG HOME="/home/$USER"
# create directories pre-emptively to avoid permission issues 📅 2025-01-07 20:03:16
RUN mkdir -p $HOME/.config $HOME/.local
RUN sudo chown -R $USER:$USER /home/$USER /home/$USER/.config /home/$USER/.local

# Set environment variables for pyenv and PATH
ENV PATH="${HOME}/.local/bin:$PATH"



