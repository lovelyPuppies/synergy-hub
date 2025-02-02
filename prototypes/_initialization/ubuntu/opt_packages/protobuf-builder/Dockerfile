FROM ubuntu:latest
ARG USER=root
ARG ROOT_HOME=/root
ARG PACKAGE_NAME=protobuf
## ⚙️ Adjust the "BRANCH_VERSION" you want 🔗 https://github.com/protocolbuffers/protobuf/tags
ARG BRANCH_VERSION=v29.3


# 📍 Set environment variables for timezone and to suppress interactive prompts during package installation 📅 2025-01-09 00:34:14
ENV DEBIAN_FRONTEND=noninteractive
# 🌏 Set the system timezone to Asia/Seoul
ENV TZ=Asia/Seoul

# Install essential packages and configure timezone
RUN apt update && \
    apt install -y locales && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN localedef -i en_US -f UTF-8 en_US.UTF-8



##### 📅 Written at 2025-02-01 14:04:11
RUN apt install -y git curl cmake ninja-build \
    g++

## Set working directory to home
WORKDIR ${ROOT_HOME}

## Clone protobuf repository
RUN git clone --depth=1 --single-branch --branch ${BRANCH_VERSION} https://github.com/protocolbuffers/protobuf.git ${PACKAGE_NAME}
WORKDIR ${ROOT_HOME}/${PACKAGE_NAME}
RUN git submodule update --init --recursive

## Configure and build shared and static protobuf
RUN cmake -G Ninja -S . -B build-debug-static -DCMAKE_INSTALL_PREFIX=/opt/${PACKAGE_NAME}/debug-static \
    -DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=NO -DCMAKE_CXX_STANDARD=17 \
    -Dprotobuf_BUILD_LIBPROTOC=OFF -DABSL_PROPAGATE_CXX_STD=ON \
    -Dprotobuf_BUILD_EXAMPLES=ON Dprotobuf_INSTALL_EXAMPLES:BOOL=ON

RUN cmake -G Ninja -S . -B build-debug-shared -DCMAKE_INSTALL_PREFIX=/opt/${PACKAGE_NAME}/debug-shared \
    -DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=YES -DCMAKE_CXX_STANDARD=17  \
    -Dprotobuf_BUILD_LIBPROTOC=ON -DABSL_PROPAGATE_CXX_STD=ON \
    -Dprotobuf_BUILD_EXAMPLES=ON Dprotobuf_INSTALL_EXAMPLES:BOOL=ON

RUN cmake -G Ninja -S . -B build-release-static -DCMAKE_INSTALL_PREFIX=/opt/${PACKAGE_NAME}/release-static \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=NO -DCMAKE_CXX_STANDARD=17 \
    -Dprotobuf_BUILD_LIBPROTOC=OFF -DABSL_PROPAGATE_CXX_STD=ON \
    -Dprotobuf_BUILD_EXAMPLES=ON Dprotobuf_INSTALL_EXAMPLES:BOOL=ON

RUN cmake -G Ninja -S . -B build-release-shared -DCMAKE_INSTALL_PREFIX=/opt/${PACKAGE_NAME}/release-shared \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=YES -DCMAKE_CXX_STANDARD=17  \
    -Dprotobuf_BUILD_LIBPROTOC=ON -DABSL_PROPAGATE_CXX_STD=ON \
    -Dprotobuf_BUILD_EXAMPLES=ON Dprotobuf_INSTALL_EXAMPLES:BOOL=ON


RUN cmake --build build-debug-static > build-debug-static.log
RUN cmake --build build-debug-shared > build-debug-shared.log
RUN cmake --build build-release-static > build-release-static.log
RUN cmake --build build-release-shared > build-release-shared.log

## Install protobuf to custom locations using package name variable
RUN cmake --install build-shared --prefix /opt/${PACKAGE_NAME}-shared
#   cmake --install build-shared --prefix /opt/protobuf-shared
RUN cmake --install build-static --prefix /opt/${PACKAGE_NAME}-static


