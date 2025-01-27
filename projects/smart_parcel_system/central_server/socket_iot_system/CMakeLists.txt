cmake_minimum_required(VERSION 3.15)
project(socket_iot_system CXX)



add_executable(iot_server src/iot_server.cpp src/main.cpp)
add_executable(iot_client src/iot_client.cpp src/main.cpp)


install(TARGETS iot_server DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        )

install(TARGETS iot_client
        DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
)

