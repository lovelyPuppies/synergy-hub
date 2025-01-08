# ROS Noetic base image
FROM ros:noetic-robot

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=vscode

# 📍 Set environment variables for timezone and to suppress interactive prompts during package installation 📅 2025-01-09 00:34:14
ENV DEBIAN_FRONTEND=noninteractive
# 🌏 Set the system timezone to Asia/Seoul
ENV TZ=Asia/Seoul

# Install essential packages and configure timezone
RUN apt-get update && \
    apt-get install -y \
    curl nano && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime


# 1. Install sudo and create the vscode user with root privileges
RUN apt-get install -y --no-install-recommends sudo \
    && useradd -m -d /home/$USER -s /bin/bash $USER \
    && usermod -aG sudo,video,dialout,plugdev,audio $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers



# 2. Switch to the vscode user
USER $USER
ARG HOME="/home/$USER"
# create directories pre-emptively to avoid permission issues 📅 2025-01-07 20:03:16
RUN mkdir -p $HOME/.config $HOME/.local
RUN sudo chown -R $USER:$USER /home/$USER /home/$USER/.config /home/$USER/.local

# 3. Set environment variables for pyenv and PATH
ENV PATH="${HOME}/.local/bin:$PATH"




# RUN source /opt/ros/noetic/setup.bash && rosdep update
