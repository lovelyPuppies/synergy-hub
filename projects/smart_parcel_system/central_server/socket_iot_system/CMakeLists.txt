cmake_minimum_required(VERSION 3.15)
project(socket_iot_system CXX)


set(IOT_SERVER_DIR src/app/iot_server)
set(IOT_CLIENT_DIR src/app/iot_client)

add_executable(iot_server ${IOT_SERVER_DIR}/iot_server.cpp ${IOT_SERVER_DIR}/main.cpp)
add_executable(iot_client ${IOT_CLIENT_DIR}/iot_client.cpp ${IOT_CLIENT_DIR}/main.cpp)


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

