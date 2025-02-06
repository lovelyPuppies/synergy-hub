FROM ubuntu:latest
ARG USER=root
ARG ROOT_HOME=/root
ARG PACKAGE_NAME=boost
## ⚙️ Adjust the "BOOST_VERSION" you want 🔗 https://github.com/boostorg/boost/releases
ARG BOOST_VERSION=1.87.0
# Copy the entire build context (all files and folders) into the /workspace directory in the Docker image
COPY . /workspace

# 📍 Set environment variables for timezone and to suppress interactive prompts during package installation 📅 2025-02-03 07:11:41
ENV DEBIAN_FRONTEND=noninteractive
# 🌏 Set the system timezone to Asia/Seoul
ENV TZ=Asia/Seoul

# Install essential packages and configure timezone
RUN apt update && \
    apt install -y locales && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN localedef -i en_US -f UTF-8 en_US.UTF-8



##### 📅 Written at 2025-02-03 02:38:36
RUN apt install -y git curl cmake ninja-build \
    crossbuild-essential-arm64 \
    build-essential libicu-dev libopenmpi-dev clang

## Set working directory to home
WORKDIR ${ROOT_HOME}
RUN mkdir -p log log/x86_64-linux-gnu log/aarch64-linux-gnu

## Download boost release
RUN curl -L https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.gz -o boost.tar.gz
RUN mkdir -p ${PACKAGE_NAME} && tar -xf ${PACKAGE_NAME}.tar.gz -C ${PACKAGE_NAME} --strip-component=1
WORKDIR ${ROOT_HOME}/${PACKAGE_NAME}


### 🎯 Target Triple: x86_64-linux-gnu
RUN echo "using mpi ;" > user-config.jam

## Configure
RUN ./bootstrap.sh

## Install
RUN ./b2 install --user-config=user-config.jam --without-python --prefix=/opt/${PACKAGE_NAME}/debug-shared --build-dir=build/debug-shared \
    threading=multi variant=debug link=shared runtime-link=shared > build-debug-shared.log
RUN ./b2 install --user-config=user-config.jam --without-python --prefix=/opt/${PACKAGE_NAME}/release-static --build-dir=build/release-static \
    threading=multi variant=release link=static runtime-link=shared > build-release-static.log
RUN ./b2 install --user-config=user-config.jam --without-python --prefix=/opt/${PACKAGE_NAME}/release-shared --build-dir=build/release-shared \
    threading=multi variant=release link=shared runtime-link=shared > build-release-shared.log


### 🎯 Target Triple: aarch64-linux-gnu 📰 TODO.. 
# https://www.boost.org/build/doc/html/bbv2/tasks/crosscompile.html
# RUN ln --symbolic --force user-config.jam /workspace/raspberry_pi-4-user-config.jam
# ## Configure
# RUN ./bootstrap.sh

# ## Install
# RUN ./b2 install --user-config=user-config.jam --without-python --prefix=/opt/${PACKAGE_NAME}/release-static --build-dir=build/release-static \
#     toolset=gcc-aarch64 threading=multi variant=release link=static runtime-link=shared > build-release-static.log
# RUN ./b2 install --user-config=user-config.jam --without-python --prefix=/opt/${PACKAGE_NAME}/release-shared --build-dir=build/release-shared \
#     toolset=gcc-aarch64 threading=multi variant=release link=shared runtime-link=shared > build-release-shared.log

# ./b2 install --user-config=user-config.jam --without-python --prefix=/opt/boost/aarch64-linux-gnu/release-shared --build-dir=build/aarch64-linux-gnu/release-shared \
#     threading=multi variant=release link=shared runtime-link=shared
###
CMD ["bash"]


### https://www.boost.org/doc/libs/1_87_0/more/getting_started/unix-variants.html#easy-build-and-install
## ☑️ when run `./bootstrap.sh`
#   >> Could not find a suitable toolset.
#     Toolsets supported by this script are:
#       acc, clang, como, gcc, intel-darwin, intel-linux, kcc, kylix, mipspro,
#       pathscale, pgi, qcc, sun, sunpro, tru64cxx, vacpp
#     ➡️ Install `build-essential`
#   >> Unicode/ICU support for Boost.Regex?... not found.
#     ➡️ The package `libicu-dev` is required. 🪱 ICU(International Components for Unicode)
#       After install that, >> Unicode/ICU support for Boost.Regex?... /usr
## ☑️ when run `b2 install`
#   >> error: No best alternative for /boost/libs/mpi/build/boost_mpi with ...
#     matched: (empty)
#     ...
#     MPI auto-detection failed: unknown wrapper compiler mpic++
#     You will need to manually configure MPI support.
#     ...
#     warning: Graph library does not contain MPI-based parallel components.
#     note: to enable them, add "using mpi ;" to your user-config.jam.
#     note: to suppress this message, pass "--without-graph_parallel" to bjam.
#   ➡️ The package `libopenmpi-dev` is required and to run command `echo "using mpi ;" > user-config.jam`  is required.
## ❔ warning: No python installation configured and autoconfiguration
#   note: failed.  See http://www.boost.org/libs/python/doc/building.html
#   note: for configuration instructions or pass --without-python to
#   note: suppress this message and silently skip all Boost.Python targets
#       - BOOST_ARCH_WORD_BITS == 0.0.16 : no [4]
#   ➡️ For this builder, Python wrapping is not required.