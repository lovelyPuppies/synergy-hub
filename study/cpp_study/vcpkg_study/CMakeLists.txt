cmake_minimum_required(VERSION 3.19)
project(fmt_example LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(fmt CONFIG REQUIRED)


add_executable(fmt_example main.cpp)
target_link_libraries(fmt_example PRIVATE fmt::fmt)



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
