## System and Architecture Settings
# Specify the target system and architecture
set(CMAKE_SYSTEM_NAME Linux)              # Target operating system
set(CMAKE_SYSTEM_PROCESSOR arm)           # Target architecture

## Clang Cross-Compile Target and Sysroot
# Path to the sysroot for cross-compilation
set(SYSROOT_PATH "$ENV{HOME}/rpi-sysroot")

## Add sysroot to C and C++ compiler flags
# set(CMAKE_C_FLAGS "--target=arm-linux-gnueabihf --sysroot=${SYSROOT_PATH}")
set(CMAKE_CXX_FLAGS "--target=arm-linux-gnueabihf --sysroot=${SYSROOT_PATH}")

## Library and Header Search Settings for Cross-Compilation
# Configure paths for finding libraries and headers in the cross-compilation environment
set(CMAKE_FIND_ROOT_PATH ${SYSROOT_PATH})         # Base path for cross-compilation
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)      # Do not search for executables in the sysroot
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)       # Only search for libraries in the sysroot
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)       # Only search for headers in the sysroot



##### Include Path Settings for Cross-Compilation 📅 2025-01-06 07:30:00
# Automatically detect and configure include paths for the standard library
file(GLOB STANDARD_LIB_PATHS "/usr/arm-linux-gnueabihf/include/c++/*")
list(SORT STANDARD_LIB_PATHS)
list(REVERSE STANDARD_LIB_PATHS)
list(GET STANDARD_LIB_PATHS 0 SELECTED_CPP_PATH)  # Select the latest detected standard library path

message(STATUS "Detected C++ standard library path: ${SELECTED_CPP_PATH}")

# Define additional include paths
set(CROSS_COMPILE_INCLUDE_PATHS
    "${SELECTED_CPP_PATH}"
    "${SELECTED_CPP_PATH}/arm-linux-gnueabihf"
    "/usr/arm-linux-gnueabihf/include"
)

# Append include paths to C++ compiler flags
foreach(PATH ${CROSS_COMPILE_INCLUDE_PATHS})
    # Uncomment the line below if set           "CMAKE_C_COMPILER": "clang",        in CMakePresets.json - configurePresets - cacheVariables
    # string(APPEND CMAKE_C_FLAGS " -I${PATH}")
    string(APPEND CMAKE_CXX_FLAGS " -I${PATH}")
endforeach()




set(COMMENT_BLOCK "
    ✅ (How-to) Run an Executable on Raspberry Pi 4 B from the Host Machine 📅 2025-01-06 07:22:55
    file build/arm32v7-raspberrypi4/Debug/testQt
    mkdir -p /nfs/qt
    cp build/arm32v7-raspberrypi4/Debug/testQt /nfs/qt/

    # Wait for NFS synchronization to complete
    sleep 1

    ssh r-pi.local '
        ## if in fish shell instead of bash shell
        # set -gx LD_LIBRARY_PATH \"$LD_LIBRARY_PATH\":/usr/local/qt6/lib/
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/
        ls -l /mnt/host/qt/testQt
        /mnt/host/qt/testQt
    '
")

