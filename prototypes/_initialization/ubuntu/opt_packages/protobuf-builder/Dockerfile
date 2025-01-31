FROM ubuntu:latest
ARG USER=root

ARG PACKAGE_NAME=protobuf


# 📍 Set environment variables for timezone and to suppress interactive prompts during package installation 📅 2025-01-09 00:34:14
ENV DEBIAN_FRONTEND=noninteractive
# 🌏 Set the system timezone to Asia/Seoul
ENV TZ=Asia/Seoul

# Install essential packages and configure timezone
RUN apt update && \
    apt install -y locales && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN localedef -i en_US -f UTF-8 en_US.UTF-8



#####
RUN apt install -y git g++ cmake ninja-build

# Set working directory to home
WORKDIR $USER

# Clone protobuf repository
RUN git clone --depth=1 --single-branch https://github.com/protocolbuffers/protobuf.git ${PACKAGE_NAME}
WORKDIR $USER/${PACKAGE_NAME}
RUN git submodule update --init --recursive

# Configure and build shared and static protobuf
RUN cmake -G Ninja -S . -B build-shared -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=/opt/${PACKAGE_NAME}-shared -Dprotobuf_BUILD_LIBPROTOC=ON
RUN cmake -G Ninja -S . -B build-static -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=/opt/${PACKAGE_NAME}-static 
RUN cmake --build build-shared
RUN cmake --build build-static

# Install protobuf to custom locations using package name variable
RUN cmake --install build-shared --prefix /opt/${PACKAGE_NAME}-shared
RUN cmake --install build-static --prefix /opt/${PACKAGE_NAME}-static


