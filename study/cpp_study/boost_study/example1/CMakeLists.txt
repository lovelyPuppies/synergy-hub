cmake_minimum_required(VERSION 3.20)

project(cppa_project LANGUAGES CXX)

# C++ 표준 설정
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# 컴파일러 및 빌드 도구 설정
set(CMAKE_CXX_COMPILER clang++-19)
set(CMAKE_MAKE_PROGRAM ninja)
set(LIBCXX_ABI_UNSTABLE ON)

# set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld")
set(CMAKE_CXX_FLAGS "-v -stdlib=libc++ -I/usr/lib/llvm-19/include/c++/v1 ${CMAKE_CXX_FLAGS}")

# 실행 파일 추가
add_executable(cppa.out cppa.cpp)

# include 디렉토리 설정
target_include_directories(cppa.out PRIVATE /home/linuxbrew/.linuxbrew/opt/llvm/include/c++/v1)

# 컴파일 명령어 파일 생성
#cppa.out cppa.cpp)

# 컴파일 명령어 파일 생성
# llvm-config-19 --cxxflags --ldflags --system-libs --libs all
# compiledb cmake -G Ninja -S . -B build
# cmake --build build
## qemu, lld depends on llvm.

### One of the reason could be this: clang doesn't have its own header libraries for c++, so it is pointing towards gcc's library folder to access header files. You can check it out and confirm it by using command
# clang++-19 -stdlib=libc++ -I/usr/lib/llvm-19/include/c++/v1 -v cppa.cpp

