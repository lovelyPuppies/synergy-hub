set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# 크로스 컴파일러 설정
set(CMAKE_C_COMPILER /usr/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++)

# sysroot 설정
set(CMAKE_SYSROOT /home/wbfw109v2/rpi-sysroot)

# Qt 경로 설정
set(CMAKE_PREFIX_PATH /home/wbfw109v2/qt-platforms/qt6.8.0-arm32v7-bookworm)
set(QT_HOST_PATH /home/wbfw109v2/Qt/6.8.0/gcc_64)

# 크로스 컴파일 환경에서 라이브러리 및 헤더 검색 설정
set(CMAKE_FIND_ROOT_PATH /home/wbfw109v2/rpi-sysroot)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


# ✅ (How-to) cross compile to raspberry pi 4 B
# cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
# -DCMAKE_BUILD_TYPE=Release \
# -S . \
# -B build

# cmake --build build

# file build/testQt
# mkdir -p /nfs/qt
# cp build/testQt /nfs/qt/


# ssh r-pi.local '
# ## if in fish shell instead of bash shell
# # set -gx LD_LIBRARY_PATH "$LD_LIBRARY_PATH":/usr/local/qt6/lib/
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/
# /mnt/host/qt/testQt
# '
