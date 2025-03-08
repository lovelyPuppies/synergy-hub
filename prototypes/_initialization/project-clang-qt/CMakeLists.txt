# 📅 Written at 2024-12-30 10:21:09
cmake_minimum_required(VERSION 3.19)
project(testQt LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Widgets LinguistTools)

qt_standard_project_setup()

qt_add_executable(testQt
    WIN32 MACOSX_BUNDLE
    main.cpp
    CustomWidget.cpp
    CustomWidget.h
)

qt_add_translations(
    TARGETS testQt
    # TS_FILES testQt_ko_KR.ts
)

target_link_libraries(testQt
    PRIVATE
        Qt::Core
        Qt::Widgets
)

include(GNUInstallDirs)

install(TARGETS testQt
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_app_script(
    TARGET testQt
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})




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


#####
# 📝 Note: 
#   - If you have divided build directories using presets, to use 🧮 %VSCODE >CMake: Run Without Debugging 📅 2025-01-06 07:15:01
#     , you need to add ':/bin:/usr/bin' to 'CMakePresets.json - configurePresets - environment - PATH'.


