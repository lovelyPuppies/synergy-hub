cmake_minimum_required(VERSION 3.19)
project(testQt LANGUAGES CXX)


# ☑️ If you use Clang , you must add ...
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


find_package(Qt6 6.5 REQUIRED COMPONENTS Core Widgets LinguistTools)

qt_standard_project_setup()

qt_add_executable(testQt        
    WIN32 MACOSX_BUNDLE
    main.cpp
    mainwindow.cpp
    mainwindow.h
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
# Define the paths for compile_commands.json
set(COMPILE_COMMANDS_SRC "${CMAKE_BINARY_DIR}/compile_commands.json")
set(COMPILE_COMMANDS_DEST "${CMAKE_SOURCE_DIR}/build/compile_commands.json")

# Always attempt to create the symbolic link after generate
# execute_process()는 CMakeLists.txt가 configure 단계에서 실행될 때 수행됩니다. compile_commnads.json 이 configure 단계와 generate 단계 사이에 있으므로 ...  이는 타겟을 잘 복사한다.
execute_process(
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${COMPILE_COMMANDS_SRC}" "${COMPILE_COMMANDS_DEST}"
    RESULT_VARIABLE result
    ERROR_VARIABLE error_message
)

# Print the result of the symbolic link creation
if(result)
    message(WARNING "Failed to create symbolic link for compile_commands.json: ${error_message}")
else()
    message(STATUS "Successfully created symbolic link: ${COMPILE_COMMANDS_DEST}")
endif()
