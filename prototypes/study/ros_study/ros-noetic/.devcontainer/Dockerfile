# ROS Noetic base image
FROM ros:noetic-robot

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=vscode

RUN source /opt/ros/noetic/setup.bash && rosdep update

# 1. Install sudo and create the vscode user with root privileges
RUN apt-get install -y --no-install-recommends sudo \
    && useradd -m -d /home/$USER -s /bin/bash $USER \
    && usermod -aG sudo,video,dialout,plugdev,audio $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 2. Ensure fish directories exist and set permissions
RUN mkdir -p /home/$USER/.local/share/fish \
    /home/$USER/.config/fish \
    && chown -R $USER:$USER /home/$USER/.local \
    /home/$USER/.config

# 3. Update dependencies index
RUN apt-get update





# 4. Install fish shell (if not already installed)
RUN apt-get install -y fish

# 5. Set environment variables for fish and PATH
ENV HOME="/home/$USER"
ENV PATH="${HOME}/.local/bin:$PATH"

# 6. Switch to the vscode user
USER $USER

# 8. Optional: Set fish as the default shell
RUN echo "/usr/bin/fish" | sudo tee -a /etc/shells && \
    sudo chsh -s /usr/bin/fish $USER





########
# FROM ros:noetic-robot
# source /opt/ros/noetic/   
# RUN apt-get update && apt-get install -y ros-noetic-ros-core 

# Install ROS on Remote PC ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
RUN wget https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_noetic.sh && \
    chmod 755 ./install_ros_noetic.sh  && \
    echo "" | bash ./install_ros_noetic.sh

# Install Dependent ROS Packages ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
RUN apt-get install ros-noetic-joy ros-noetic-teleop-twist-joy \
  ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
  ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
  ros-noetic-rosserial-python ros-noetic-rosserial-client \
  ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
  ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
  ros-noetic-compressed-image-transport ros-noetic-rqt* ros-noetic-rviz \
  ros-noetic-gmapping ros-noetic-navigation ros-noetic-interactive-markers

# Install TurtleBot3 Packages ; https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/#pc-setup
RUN apt install ros-noetic-dynamixel-sdk \
    ros-noetic-turtlebot3-msgs \
    ros-noetic-turtlebot3
