# ROS Noetic base image
FROM ros:noetic-robot

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=vscode


# 1. Install sudo and create the vscode user with root privileges
RUN apt-get update && apt-get install -y --no-install-recommends sudo \
    && useradd -m -d /home/$USER -s /bin/bash $USER \
    && usermod -aG sudo,video,dialout,plugdev,audio $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 2. Update dependencies index
RUN apt-get update

# 3. Switch to the vscode user
USER $USER
ARG HOME="/home/$USER"
# create directories pre-emptively to avoid permission issues 📅 2025-01-07 20:03:16
RUN mkdir -p $HOME/.config $HOME/.local
RUN sudo chown -R $USER:$USER /home/$USER /home/$USER/.config /home/$USER/.local

# 4. Set environment variables for pyenv and PATH
ENV PATH="${HOME}/.local/bin:$PATH"




# RUN source /opt/ros/noetic/setup.bash && rosdep update

# ########
# # FROM ros:noetic-robot
# # source /opt/ros/noetic/   
# # RUN apt-get update && apt-get install -y ros-noetic-ros-core 

# # Install ROS on Remote PC ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
# RUN wget https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_noetic.sh && \
#     chmod 755 ./install_ros_noetic.sh  && \
#     echo "" | bash ./install_ros_noetic.sh

# # Install Dependent ROS Packages ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
# RUN apt-get install ros-noetic-joy ros-noetic-teleop-twist-joy \
#   ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
#   ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
#   ros-noetic-rosserial-python ros-noetic-rosserial-client \
#   ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
#   ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
#   ros-noetic-compressed-image-transport ros-noetic-rqt* ros-noetic-rviz \
#   ros-noetic-gmapping ros-noetic-navigation ros-noetic-interactive-markers

# # Install TurtleBot3 Packages ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
# RUN apt install ros-noetic-dynamixel-sdk \
#     ros-noetic-turtlebot3-msgs \
#     ros-noetic-turtlebot3
