#!/usr/bin/env fish


# Load Modules
source prototypes/_initialization/ubuntu/fish_modules/_import_all.fish
# /home/wbfw109v2/repos/synergy-hub/prototypes/_initialization/ubuntu/fish_modules/_import_all.fish

function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


set script_dir /home/wbfw109v2/repos/synergy-hub/prototypes/_initialization/ubuntu

echo hello world


# ### FFmpeg build ; https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu


# mkdir -p $HOME/ffmpeg_sources $HOME/bin

# # Get the Dependencies
# sudo sudo apt update && sudo apt install -y \
#     automake \
#     build-essential \
#     cmake \
#     git-core \
#     libass-dev \
#     libfreetype6-dev \
#     libgnutls28-dev \
#     libmp3lame-dev \
#     libsdl2-dev \
#     libtool \
#     libva-dev \
#     libvdpau-dev \
#     libvorbis-dev \
#     libxcb1-dev \
#     libxcb-shm0-dev \
#     libxcb-xfixes0-dev \
#     meson \
#     ninja-build \
#     pkg-config \
#     texinfo \
#     wget \
#     yasm \
#     zlib1g-dev



# # ⚠️ On Ubuntu 20.04 you may also need this command: (​note) ...

# sudo add-apt-repository -y universe

# # NASM
# sudo apt install -y nasm
# ## libx264: H.264 video encoder ; https://trac.ffmpeg.org/wiki/Encode/H.264
# # ⚠️ Requires ffmpeg to be configured with --enable-gpl --enable-libx264.
# sudo apt install -y libx264-dev

# ## libx265: H.265/HEVC video encoder ; https://trac.ffmpeg.org/wiki/Encode/H.265
# # ⚠️ Requires ffmpeg to be configured with --enable-gpl --enable-libx265.
# sudo apt install -y libx265-dev libnuma-dev

# ## libvpx: VP8/VP9 video encoder/decoder ; https://trac.ffmpeg.org/wiki/Encode/VP9
# # ⚠️ Requires ffmpeg to be configured with --enable-libvpx.
# sudo apt install -y libvpx-dev

# # libfdk-aac: AAC audio encoder ; https://trac.ffmpeg.org/wiki/Encode/AAC
# # ⚠️ Requires ffmpeg to be configured with --enable-libfdk-aac (and --enable-nonfree if you also included --enable-gpl).
# sudo apt install -y libfdk-aac-dev

# ## libopus: Opus audio decoder and encoder
# # ⚠️ Requires ffmpeg to be configured with --enable-libopus.
# sudo apt install -y libopus-dev

# # 📰 libaom: libaom does not yet appear to have a stable API, ...

# ## libsvtav1: AV1 video encoder/decoder
# # ⚠️ Requires ffmpeg to be configured with --enable-libsvtav1.
# cd $HOME/ffmpeg_sources && git -C SVT-AV1 pull 2>/dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git && mkdir -p SVT-AV1/build && cd SVT-AV1/build && \
#     PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF .. && \
#     PATH="$HOME/bin:$PATH" make && make install

# ## libdav1d: AV1 decoder, much faster than the one provided by libaom
# # ⚠️ Requires ffmpeg to be configured with --enable-libdav1d.
# sudo apt install -y libdav1d-dev

# ## libvmaf ; Library for calculating the ​VMAF video quality metric.
# # ⚠️ Requires ffmpeg to be configured with --enable-libvmaf.
# #   Currently ​an issue in libvmaf also requires FFmpeg to be built with --ld="g++" for a static build to succeed.
# cd $HOME/ffmpeg_sources && wget https://github.com/Netflix/vmaf/archive/v3.0.0.tar.gz && tar xvf v3.0.0.tar.gz && mkdir -p vmaf-3.0.0/libvmaf/build && cd vmaf-3.0.0/libvmaf/build && meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static .. --prefix "$HOME/ffmpeg_build" --bindir="$HOME/bin" --libdir="$HOME/ffmpeg_build/lib" && ninja && ninja install


# ## FFmpeg 
# # 🧮 ./configure --help
# #   External library support
# #     The following libraries provide various hardware acceleration features:
# #      🌳 --enable-cuda-nvcc        enable Nvidia CUDA compiler [no]
# #       --enable-vulkan-static      statically link to libvulkan [no]

# export INSTALL_PREFIX=/usr/local/ffmpeg
# export PKG_CONFIG_PATH=$HOME/ffmpeg_build/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig
# # export PKG_CONFIG_PATH=$HOME/ffmpeg_build/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:$INSTALL_PREFIX/lib/pkgconfig

# cd $HOME/ffmpeg_sources && wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && tar xjvf ffmpeg-snapshot.tar.bz2 && cd $HOME/ffmpeg_sources/ffmpeg && \
#     PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$PKG_CONFIG_PATH" ./configure \
#     --prefix="$INSTALL_PREFIX" \
#     --pkg-config-flags="--static" \
#     --extra-cflags="-I$INSTALL_PREFIX/include" \
#     --extra-ldflags="-L$INSTALL_PREFIX/lib" \
#     --extra-libs="-lpthread -lm" \
#     --ld="g++" \
#     --bindir="$INSTALL_PREFIX/bin" \
#     --enable-gpl \
#     --enable-gnutls \
#     --enable-libass \
#     --enable-libfdk-aac \
#     --enable-libfreetype \
#     --enable-libmp3lame \
#     --enable-libopus \
#     --enable-libsvtav1 \
#     --enable-libdav1d \
#     --enable-libvorbis \
#     --enable-libvpx \
#     --enable-libx264 \
#     --enable-libx265 \
#     --enable-libvmaf \
#     --enable-nonfree \
#     --enable-cuda-nvcc \
#     --enable-vulkan-static && \
#     PATH="$HOME/bin:$PATH" make && sudo make install
# echo "hash only exists in bash, not in fish. In bash shell, to reload the path cache, use the following command: 🧮 hash -r"

# : '
# External libraries providing hardware acceleration:
#     cuda_llvm               libdrm                  vaapi                   vulkan
#     cuda_nvcc               v4l2_m2m                vdpau


# ffplay -v verbose -hwaccel cuda ~/Downloads/Polar_orbit.ogv.360p.webm


# '

# ### https://docs.nvidia.com/video-technologies/video-codec-sdk/11.1/ffmpeg-with-nvidia-gpu/index.html#hardware-setup

# ## You can check required dynamic libraries using command  `ldd` (List Dynamic Dependencies)
# #   🛍️ e.g.ldd ~/bin/ffmpeg

# # --enable-libaom \

# # ./configure --help | grep prefix
# #   >> --prefix=PREFIX          install in PREFIX [/usr/local]

# ffplay ~/Downloads/Polar_orbit.ogv.360p.webm
# # webm files ;  https://commons.wikimedia.org/wiki/Category:Videos
# # 
# wget -O mp4.mp4 "https://cdn.pixabay.com/video/2016/08/22/4740-179738694_tiny.mp4?download"
# ffplay ~/Downloads/mp4.mp4

# ffplay -hwaccel nvdec ~/Downloads/Polar_orbit.ogv.360p.webm





# #### 📦 ffmpeg ; Play, record, convert, and stream audio and video
# # Define the unique comment to identify this block in the Fish config file
# set unique_comment "## [FFmpeg] Add FFmpeg paths and settings"

# # Check if the unique comment already exists in the Fish config file
# if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
#     echo "
#     $unique_comment"'
#     # Define the FFmpeg installation directory
#     set -x FFMPEG_INSTALL_DIR /usr/local/ffmpeg

#     # Add FFmpeg binaries to PATH
#     fish_add_path $FFMPEG_INSTALL_DIR/bin

#     # Add FFmpeg libraries to linker and compiler paths
#     set -gx LDFLAGS $LDFLAGS -L$FFMPEG_INSTALL_DIR/lib
#     set -gx CPPFLAGS $CPPFLAGS -I$FFMPEG_INSTALL_DIR/include

#     # Add FFmpeg pkg-config files to PKG_CONFIG_PATH
#     set -gx PKG_CONFIG_PATH $PKG_CONFIG_PATH:$FFMPEG_INSTALL_DIR/lib/pkgconfig
#     ' | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
#     echo -e "\n" >>"$FISH_CONFIG_PATH"
# end
