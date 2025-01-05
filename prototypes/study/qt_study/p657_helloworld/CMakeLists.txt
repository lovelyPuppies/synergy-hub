# Written at 📅 2024-12-30 10:21:09
cmake_minimum_required(VERSION 3.19)
project(testQt LANGUAGES CXX)


# ☑️ If you use Clang , you must add ...

# set(CMAKE_C_COMPILER "/home/linuxbrew/.linuxbrew/bin/clang")
# set(CMAKE_CXX_COMPILER "/home/linuxbrew/.linuxbrew/bin/clang++")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# set(CMAKE_C_COMPILER clang)
# set(CMAKE_CXX_COMPILER clang++)
# 추가 플래그 설정

# ☑️ If you use a custom compiler (e.g., GCC 14.2, Clang) instead of the Qt6 built-in GCC 📅 2024-12-29 01:45:42
#   , you must explicitly set the CMAKE_PREFIX_PATH to locate Qt6's CMake configuration files.



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




##### 🌀 Title: Creating a Symbolic Link or Copying compile_commands.json to build/compile_commands.json for IntelliSense in VSCode with the clangd Extension 📅 2025-01-06 01:59:50
# Define the path to the original compile_commands.json file in the build directory
set(COMPILE_COMMANDS_SRC "${CMAKE_BINARY_DIR}/compile_commands.json")
# Define the destination path for the symbolic link in the source directory
set(COMPILE_COMMANDS_DEST "${CMAKE_SOURCE_DIR}/build/compile_commands.json")

# Check if the source compile_commands.json file exists
if(EXISTS ${COMPILE_COMMANDS_SRC})
    # Create a symbolic link from the source file to the destination
    # If a link or file already exists at the destination, it will be overwritten
    # ❔ -E                           = CMake command mode.  Run "cmake -E" for a summary of commands.
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E create_symlink
            ${COMPILE_COMMANDS_SRC} ${COMPILE_COMMANDS_DEST}
        # Store the result of the command execution in the variable 'result'
        RESULT_VARIABLE result
    )

    # If the symbolic link creation fails, display a warning message
    if(NOT result EQUAL 0)
        message(WARNING "Failed to create symbolic link for compile_commands.json")
    else()
        # If the symbolic link is successfully created, display a success message
        message(STATUS "Symbolic link created: ${COMPILE_COMMANDS_DEST}")
    endif()
else()
    # If the source file does not exist, display a warning message
    message(WARNING "Source compile_commands.json does not exist: ${COMPILE_COMMANDS_SRC}")
endif()
