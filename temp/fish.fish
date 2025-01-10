#!/usr/bin/env fish


# Load Modules
source prototypes/_initialization/ubuntu/fish_modules/_import_all.fish

function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


set script_dir /home/wbfw109v2/repos/synergy-hub/prototypes/_initialization/ubuntu


### FFmpeg build ; https://trac.ffmpeg.org/wiki/CompilationGuide


mkdir -p $HOME/ffmpeg_sources $HOME/bin

# Get the Dependencies
sudo apt install
autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libfreetype6-dev \
    libgnutls28-dev \
    libmp3lame-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    meson \
    ninja-build \
    pkg-config \
    texinfo \
    wget \
    yasm \
    zlib1g-dev

# ⚠️ On Ubuntu 20.04 you may also need this command: (​note) ...

#
sudo add-apt-repository -y universe
sudo apt update

## ERROR: gnutls not found using pkg-config 📅 2025-01-10 17:23:08
# https://askubuntu.com/questions/1252997/unable-to-compile-ffmpeg-on-ubuntu-20-04
sudo apt install -y libunistring-dev libgnutls28-dev
## ERROR: libass >= 0.11.0 not found using pkg-config
sudo apt install -y libass-dev


# NASM
sudo apt install -y nasm
## libx264: H.264 video encoder ; https://trac.ffmpeg.org/wiki/Encode/H.264
# ⚠️ Requires ffmpeg to be configured with --enable-gpl --enable-libx264.
sudo apt install -y libx264-dev

## libx265: H.265/HEVC video encoder ; https://trac.ffmpeg.org/wiki/Encode/H.265
# ⚠️ Requires ffmpeg to be configured with --enable-gpl --enable-libx265.
sudo apt install -y libx265-dev libnuma-dev

## libvpx: VP8/VP9 video encoder/decoder ; https://trac.ffmpeg.org/wiki/Encode/VP9
# ⚠️ Requires ffmpeg to be configured with --enable-libvpx.
sudo apt install -y libvpx-dev

# libfdk-aac: AAC audio encoder ; https://trac.ffmpeg.org/wiki/Encode/AAC
# ⚠️ Requires ffmpeg to be configured with --enable-libfdk-aac (and --enable-nonfree if you also included --enable-gpl).
sudo apt install -y libfdk-aac-dev

## libopus: Opus audio decoder and encoder
# ⚠️ Requires ffmpeg to be configured with --enable-libopus.
sudo apt install -y libopus-dev

# 📰 libaom: libaom does not yet appear to have a stable API, ...

## libsvtav1: AV1 video encoder/decoder
# ⚠️ Requires ffmpeg to be configured with --enable-libsvtav1.

## libdav1d: AV1 decoder, much faster than the one provided by libaom
# ⚠️ Requires ffmpeg to be configured with --enable-libdav1d.
sudo apt install -y libdav1d-dev

## libvmaf ; Library for calculating the ​VMAF video quality metric.
# ⚠️ Requires ffmpeg to be configured with --enable-libvmaf.
#   Currently ​an issue in libvmaf also requires FFmpeg to be built with --ld="g++" for a static build to succeed.
cd $HOME/ffmpeg_sources && wget https://github.com/Netflix/vmaf/archive/v3.0.0.tar.gz && tar xvf v3.0.0.tar.gz && mkdir -p vmaf-3.0.0/libvmaf/build && cd vmaf-3.0.0/libvmaf/build && meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static .. --prefix "$HOME/ffmpeg_build" --bindir="$HOME/bin" --libdir="$HOME/ffmpeg_build/lib" && ninja && ninja install

## FFmpeg 
cd $HOME/ffmpeg_sources && wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && tar xjvf ffmpeg-snapshot.tar.bz2 && cd ffmpeg && \
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
    --bindir="$HOME/bin" \
    --enable-gpl \
    --enable-gnutls \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libsvtav1 \
    --enable-libdav1d \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvmaf \
    --enable-nonfree && \
    PATH="$HOME/bin:$PATH" make && make install && hash -r
# --enable-libaom \










# ### 📦 (Verified) GIMP ; https://flathub.org/apps/com.microsoft.Edge 📅 2024-12-25 23:12:02
# #   ; Image editor, photo retouching, and graphic design tool
# flatpak install -y --user flathub com.microsoft.Edge
# # Define alias for 'gimp' in an interactive session
# set unique_comment "# Add alias for gimp from flatpak"
# set alias_function (echo "
#     function gimp
#         flatpak --user run com.microsoft.Edge \$argv
#     end
# " | prettify_indent_via_pipe | string split0)

# # Call the function to update the config
# update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"



# # 경로 설정
# set FISH_SCRIPT_PATH "/home/wbfw109v2/repos/synergy-hub/prototypes/_initialization/ubuntu/file_supervisor/inotify-make_fish_utilities_executable.fish"
# set SERVICE_FILE_PATH "$HOME/.config/systemd/user/inotify-make_fish.service"

# # 실행 권한 부여
# chmod +x "$FISH_SCRIPT_PATH"

# # 2. Systemd 서비스 파일 생성
# mkdir -p "$HOME/.config/systemd/user"
# echo "[Unit]
# Description=Inotify service for Fish utilities (User Scope)
# After=network.target

# [Service]
# ExecStart=/usr/bin/fish $FISH_SCRIPT_PATH
# Restart=always
# RestartSec=5

# [Install]
# WantedBy=default.target
# " >"$SERVICE_FILE_PATH"

# # 3. Systemd 설정 및 서비스 시작
# systemctl --user daemon-reload
# systemctl --user enable inotify-make_fish.service
# systemctl --user start inotify-make_fish.service

# # 상태 확인
# systemctl --user status inotify-make_fish.service --no-pager

# systemctl --user disable inotify-make_fish.service
# systemctl --user stop inotify-make_fish.service
