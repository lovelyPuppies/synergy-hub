# https://github.com/alejandrofsevilla/boost-tcp-server-client
cmake_minimum_required(VERSION 3.30)

project(boost-tcp-server-client LANGUAGES CXX)

add_subdirectory(tests)

add_library(${PROJECT_NAME} SHARED
  TcpClient.hpp
  TcpClient.cpp
  TcpConnection.hpp
  TcpConnection.cpp
  TcpServer.hpp
  TcpServer.cpp
  )

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic -Werror -O0)

target_include_directories(${PROJECT_NAME} PUBLIC .)

find_package(Boost 1.87 REQUIRED)
if (Boost_FOUND)
  message(STATUS "❕ Boost found successfully.")
  target_include_directories(${PROJECT_NAME} PUBLIC ${Boost_INCLUDE_DIRS})
else()
  message(FATAL_ERROR "Boost not found.")
endif()


## https://cmake.org/cmake/help/latest/module/FindBoost.html
# study/cpp_study/boost_study/boost-tcp-server-client
## cmake -G Ninja -S . -B build
## cmake --build build
## ./build/tests/boost-tcp-server-client-tests 