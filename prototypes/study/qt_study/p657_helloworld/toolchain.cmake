# 시스템 및 아키텍처 설정
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)


# Clang 크로스 컴파일 타겟 및 sysroot 설정
set(SYSROOT_PATH "$ENV{HOME}/rpi-sysroot")

# CFLAGS 및 CXXFLAGS에 sysroot 설정
set(CMAKE_C_FLAGS "--target=arm-linux-gnueabihf --sysroot=${SYSROOT_PATH}")
set(CMAKE_CXX_FLAGS "--target=arm-linux-gnueabihf --sysroot=${SYSROOT_PATH}")



# 크로스 컴파일 환경에서 라이브러리 및 헤더 검색 설정
set(CMAKE_FIND_ROOT_PATH ${SYSROOT_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


##############
# CFLAGS 및 CXXFLAGS에 include 경로 추가 (공백으로 구분)
# Include 경로 설정 (공통으로 사용할 경우)
set(CROSS_COMPILE_INCLUDE_PATHS
    "/usr/arm-linux-gnueabihf/include/c++/14"
    "/usr/arm-linux-gnueabihf/include/c++/14/arm-linux-gnueabihf"
    "/usr/arm-linux-gnueabihf/include"
)

# CFLAGS 및 CXXFLAGS에 include 경로 추가
foreach(PATH ${CROSS_COMPILE_INCLUDE_PATHS})
    ## If use     "CMAKE_C_COMPILER": "clang",        in CMakePresets.json - configurePresets - cacheVariables
    # string(APPEND CMAKE_C_FLAGS " -I${PATH}")
    string(APPEND CMAKE_CXX_FLAGS " -I${PATH}")
endforeach()


# ✅ (How-to) cross compile to raspberry pi 4 B
# cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
# -DCMAKE_BUILD_TYPE=Release \
# -S . \
# -B build

# cmake --build build

# file build/Debug/testQt
# mkdir -p /nfs/qt
# cp build/Debug/testQt /nfs/qt/


# ssh r-pi.local '
# ## if in fish shell instead of bash shell
# # set -gx LD_LIBRARY_PATH "$LD_LIBRARY_PATH":/usr/local/qt6/lib/
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/
# ls -l /mnt/host/qt/testQt
# /mnt/host/qt/testQt
# '
