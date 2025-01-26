cmake_minimum_required(VERSION 3.15)
project(iot_server CXX)



add_executable(iot_server src/iot_server.cpp src/main.cpp)



install(TARGETS iot_server DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        )
