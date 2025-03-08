cmake_minimum_required(VERSION 3.19)
project(vckpg_study LANGUAGES CXX)



add_executable(fmt_example main.cpp)
find_package(fmt CONFIG REQUIRED)
find_package(spdlog CONFIG REQUIRED)
find_package(protobuf CONFIG REQUIRED)
find_package(nanopb CONFIG REQUIRED)
find_package(unofficial-mariadb-connector-cpp CONFIG REQUIRED)
find_package(unofficial-argon2 CONFIG REQUIRED)
find_package(boost_asio REQUIRED CONFIG)
find_package(boost_redis REQUIRED CONFIG)
target_link_libraries(fmt_example PRIVATE
    fmt::fmt
    spdlog::spdlog
    unofficial::mariadb-connector-cpp::mariadbcpp
    unofficial::argon2::libargon2
    protobuf::libprotobuf
    nanopb::protobuf-nanopb-static
    Boost::asio
    Boost::redis
)

##### 🌀 Title: Creating a Symbolic Link or Copying compile_commands.json to build/compile_commands.json for IntelliSense in VSCode with the clangd Extension 📅 2025-01-06 07:07:23
## Define the paths for compile_commands.json
#   - COMPILE_COMMANDS_SRC: Path where 🚣 compile_commands.json is generated during 🪱 the configure phase 
#     (🚣 requires CMAKE_EXPORT_COMPILE_COMMANDS=ON).
#   - COMPILE_COMMANDS_DEST: Path for the symbolic link in the source directory, 
#     used by clangd in VSCode for IntelliSense.
set(COMPILE_COMMANDS_SRC "${CMAKE_BINARY_DIR}/compile_commands.json")
set(COMPILE_COMMANDS_DEST "${CMAKE_SOURCE_DIR}/build/compile_commands.json")

## Attempt to create the symbolic link after the configure phase
#   - 🚣 execute_process() runs the provided command immediately after the 🪱 configure phase completes.
#     💡 The symbolic link creation is attempted every time CMakeLists.txt is processed during configuration.
#       This ensures the link is automatically created when compile_commands.json becomes available.
#   ❔ CMAKE_COMMAND       -E           = CMake command mode.  Run "cmake -E" for a summary of commands.
execute_process(
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${COMPILE_COMMANDS_SRC}" "${COMPILE_COMMANDS_DEST}"
    # RESULT_VARIABLE stores the result of the command (0 for success, non-zero for failure).
    RESULT_VARIABLE result
    # ERROR_VARIABLE captures any error message from the command execution.
    ERROR_VARIABLE error_message
)

## Print the result of the symbolic link creation
#   - If the result is non-zero (failure), a warning is displayed along with the error message.
#   - If the result is zero (success), a status message confirms the symbolic link creation.
if(result)
    # Failed to create the symbolic link, log a warning message
    message(WARNING "Failed to create symbolic link for compile_commands.json: ${error_message}")
else()
    # Successfully created the symbolic link, log a status message
    message(STATUS "Successfully created symbolic link: ${COMPILE_COMMANDS_DEST}")
endif()




##### 🌀 Title: Automatically detect and create symbolic links for all executable files Whenever build
function(create_executable_symlinks)
    # Retrieve the list of all registered executable targets in the current directory
    get_directory_property(TARGETS BUILDSYSTEM_TARGETS)

    foreach(TARGET ${TARGETS})
        # Check if the target is an executable
        get_target_property(TARGET_TYPE ${TARGET} TYPE)
        if(NOT TARGET_TYPE STREQUAL "EXECUTABLE")
            continue()
        endif()

        # Get the executable file path
        get_target_property(EXECUTABLE_PATH ${TARGET} RUNTIME_OUTPUT_DIRECTORY)
        if(NOT EXECUTABLE_PATH)
            # Set default build directory
            set(EXECUTABLE_PATH "${CMAKE_BINARY_DIR}")
        endif()
        set(EXECUTABLE_FILE "${EXECUTABLE_PATH}/${TARGET}")
        # Desired symbolic link location
        set(SYMLINK_PATH "${CMAKE_SOURCE_DIR}/build/${TARGET}")

        # Create the symbolic link
        add_custom_command(
            TARGET ${TARGET} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E create_symlink "${EXECUTABLE_FILE}" "${SYMLINK_PATH}"
            COMMENT "Creating symbolic link for ${TARGET}: ${SYMLINK_PATH} -> ${EXECUTABLE_FILE}"
        )

        message(STATUS "Created symbolic link for ${TARGET}: ${SYMLINK_PATH} -> ${EXECUTABLE_FILE}")
    endforeach()
endfunction()

# Execute the function (Automatically runs in the CMake project)
create_executable_symlinks()
