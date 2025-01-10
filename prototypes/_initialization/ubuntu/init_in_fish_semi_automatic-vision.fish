#!/usr/bin/env fish

##### 📦 GPU 🔪 NVIDIA Driver
sudo apt install -y nvidia-cuda-toolkit


cd ~/ffmpeg_sources/ffmpeg && ./configure --help
cd -
