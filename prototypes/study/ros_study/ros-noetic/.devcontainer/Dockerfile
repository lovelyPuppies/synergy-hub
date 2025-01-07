# ROS Noetic base image
FROM ros:noetic-robot


ARG DEBIAN_FRONTEND=noninteractive
ARG USER=vscode


# 1. Install sudo and create the vscode user with root privileges
RUN apt-get update && apt-get install -y --no-install-recommends sudo \
    && useradd -m -d /home/$USER -s /bin/bash $USER \
    && usermod -aG sudo,video,dialout,plugdev,audio $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Use the ARG variable to set permissions
RUN chown -R ${USER}:${USER} /home/${USER}

# 2. Update dependencies index
RUN apt-get update

# 3. Switch to the vscode user
USER $USER
ARG HOME="/home/$USER"
RUN sudo chown -R $USER:$USER /home/$USER
RUN export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1:/$LD_PRELOAD >> ~/.bashrc

# 4. Set environment variables for pyenv and PATH
ENV PATH="${HOME}/.local/bin:$PATH"
