##### Project setup and configuration
cmake_minimum_required(VERSION 3.15)
project(socket_iot_system CXX C)

# Enable Clang tooling support: Creates `compile_commands.json` during the CMake configure step
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

### ✅ (how-to); Symbolic link creation for compile_commands.json after the CMake configure step 📅 2025-01-28 05:17:32
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



##### Define and configure executables
set(IOT_SERVER_DIR src/app/iot_server)
set(IOT_CLIENT_CPP_DIR src/app/iot_client_cpp)
set(IOT_CLIENT_C1_DIR src/app/iot_client_c1)
set(IOT_CLIENT_C2_DIR src/app/iot_client_c2)

add_executable(iot_server ${IOT_SERVER_DIR}/iot_server.cpp ${IOT_SERVER_DIR}/main.cpp)
add_executable(iot_client_cpp ${IOT_CLIENT_CPP_DIR}/iot_client_cpp.cpp ${IOT_CLIENT_CPP_DIR}/main.cpp)
add_executable(iot_client_c1 ${IOT_CLIENT_C1_DIR}/main.c)
add_executable(iot_client_c2 ${IOT_CLIENT_C2_DIR}/main.c)

# set_target_properties(iot_server PROPERTIES CXX_STANDARD 23 CXX_STANDARD_REQUIRED YES)
# set_target_properties(iot_client_cpp PROPERTIES CXX_STANDARD 23 CXX_STANDARD_REQUIRED YES)
# set_target_properties(iot_client_c PROPERTIES C_STANDARD 23 C_STANDARD_REQUIRED YES)


# Common include directory
set(COMMON_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/src/common)
target_include_directories(iot_server PRIVATE ${COMMON_INCLUDE_DIR})
target_include_directories(iot_client_cpp PRIVATE ${COMMON_INCLUDE_DIR})
target_include_directories(iot_client_c1 PRIVATE ${COMMON_INCLUDE_DIR})
target_include_directories(iot_client_c2 PRIVATE ${COMMON_INCLUDE_DIR})




##### Install configuration 📰 TODO
install(TARGETS iot_server DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        )

install(TARGETS iot_client_cpp
        DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
)

install(TARGETS iot_client_c1
        DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
)


install(TARGETS iot_client_c2
        DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
)

