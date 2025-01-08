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
