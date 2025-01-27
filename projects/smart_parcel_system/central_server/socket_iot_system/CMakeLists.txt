###
cmake_minimum_required(VERSION 3.15)
project(socket_iot_system CXX)

###
# For Clang: Creates `compile_commands.json` during the CMake configure step
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Define paths for compile_commands.json
set(COMPILE_COMMANDS_SRC "${CMAKE_BINARY_DIR}/compile_commands.json")
set(COMPILE_COMMANDS_DEST "${CMAKE_SOURCE_DIR}/build/compile_commands.json")

# Attempt to create the symbolic link after the configure phase
execute_process(
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${COMPILE_COMMANDS_SRC}" "${COMPILE_COMMANDS_DEST}"
    RESULT_VARIABLE result
    ERROR_VARIABLE error_message
)

# Print the result of the symbolic link creation
if(result)
    # Failed to create the symbolic link, log a warning message
    message(WARNING "Failed to create symbolic link for compile_commands.json: ${error_message}")
else()
    # Successfully created the symbolic link, log a status message
    message(STATUS "Successfully created symbolic link: ${COMPILE_COMMANDS_DEST}")
endif()


###
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

