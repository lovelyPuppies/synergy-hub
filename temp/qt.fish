#!/usr/bin/env fish

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Qt GRPC dependencies
echo "Installing Qt GRPC dependencies..."
sudo apt install -y protobuf-compiler libprotobuf-dev libgrpc-dev libssl-dev

# Qt WebEngine dependencies
echo "Installing Qt WebEngine dependencies..."
sudo apt install -y build-essential cmake python3 python3-html5lib bison flex gperf nodejs \
    libdbus-1-dev libfontconfig1-dev libdrm-dev libxcomposite-dev \
    libxcursor-dev libxi-dev libxrandr-dev libxss-dev libxtst-dev pkg-config

# Qt Quick 3D dependencies
echo "Installing Qt Quick 3D dependencies..."
sudo apt install -y qtdeclarative-dev qtshadertools-dev qtquickcontrols2-dev

# Qt Multimedia dependencies
echo "Installing Qt Multimedia dependencies..."
sudo apt install -y ffmpeg libavcodec-dev libavformat-dev libavutil-dev libswresample-dev \
    libswscale-dev libpulse-dev libva-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# Final message
echo "All dependencies have been installed successfully!"
