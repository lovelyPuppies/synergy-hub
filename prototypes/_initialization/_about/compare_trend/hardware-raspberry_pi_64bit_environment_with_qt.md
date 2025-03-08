# Transitioning Raspberry Pi to 64-bit Environment for Modern Trends

📅 Written at 2025-01-11 21:44:30

## Overview

This document provides insights and instructions for transitioning to a 64-bit environment on Raspberry Pi, highlighting the trends in software and hardware compatibility as of 2025. Transitioning ensures compatibility, improved performance, and access to the latest features in the software ecosystem, particularly when using frameworks like Qt. It includes comparisons, historical data, and step-by-step guidelines for achieving optimal development setups.

### Why 64-bit?

By 2025, the majority of the software and hardware ecosystem has transitioned to 64-bit for the following reasons:

- **Performance:** 64-bit architectures offer greater memory addressing and improved performance.
- **Hardware Compatibility:** Modern devices like Raspberry Pi 4 and NVIDIA Jetson Nano are designed for 64-bit operations.
- **Software Trends:** Many frameworks, including Qt 6+, have deprecated 32-bit support.

## Historical Context and Trends

| Feature/Release                 | Year          | Notes                                   |
| ------------------------------- | ------------- | --------------------------------------- |
| Raspberry Pi 3 Hardware         | 2016          | Introduced 64-bit ARMv8-A architecture  |
| 64-bit Raspberry Pi OS (Beta)   | May 2020      | Initial beta release                    |
| 64-bit Raspberry Pi OS (Stable) | February 2022 | Officially supported                    |
| Qt 6 Release                    | December 2020 | 🗑️ Dropped support for 32-bit platforms |
| Qt Online Installer (64-bit)    | 2021          | ⭕ Only 64-bit versions provided        |

### Industry Shift to 64-bit

- **Modernization:** 64-bit is now the default across industries.
- **Compatibility Issues:** Using 32-bit environments has become increasingly restrictive, particularly with frameworks like Qt that no longer support 32-bit builds as of Qt 6.

## Key Considerations for Raspberry Pi

### 1. Qt Online Installer

#### Supported Platforms

The Qt Online Installer provides pre-built binaries for 64-bit platforms:

| Platform        | Installer Name                      |
| --------------- | ----------------------------------- |
| Windows (x64)   | qt-unified-windows-x64-online.exe   |
| Windows (ARM64) | qt-unified-windows-arm64-online.exe |
| macOS (x64)     | qt-unified-mac-x64-online.dmg       |
| Linux (x64)     | qt-unified-linux-x64-online.run     |
| Linux (ARM64)   | qt-unified-linux-arm64-online.run   |

#### Notes:

- **No 32-bit support:** Starting from Qt 6, all installers target 64-bit systems exclusively.
- **Benefits:** Automated dependency resolution, easy add-on installation (e.g., QtMultimedia, QtWebEngine).

### 2. Compatibility in Hybrid Configurations

Hybrid configurations (64-bit user space with 32-bit kernel) have limitations:

| Component       | Compatibility               |
| --------------- | --------------------------- |
| Kernel Drivers  | Requires matching bitness   |
| Qt Applications | Incompatible in hybrid mode |

#### Testing and Findings:

- 64-bit user space cannot execute 64-bit Qt applications on a 32-bit kernel.
- Full 64-bit (user space + kernel) is recommended for seamless operation.

### 3. Challenges in Cross-Compiling Qt

Efforts to cross-compile Qt libraries for Raspberry Pi or Jetson Nano revealed significant challenges:

- **Basic QtBase Compilation:** Achievable but complex.
- **Add-ons Compilation:** Nearly impossible without precise documentation.
- **Lack of Official Guidance:** Qt's official documentation lacks detailed steps for cross-compiling add-ons.
- **Frequent Errors:** Build errors and configuration failures are common.

#### Options for Building:

1. **Cloning Qt Repository:**

   - Use `git clone` for the [Qt source](https://github.com/qt/qt5) and attempt to build the modules.

     🛍️ e.g. (My Attempt)

     ```bash
      #!/usr/bin/env fish

      # copy RaspberryPi (sysroot) ...

      # Ensure QEMU and ARM/v7 support is activated for Docker buildx
      if not docker buildx inspect --bootstrap | grep -q linux/arm/v7
         echo "linux/arm/v7 not found, performing the task..."
         docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
         docker buildx inspect --bootstrap | grep linux/arm/v7
      else
         echo "linux/arm/v7 is already present."
      end
      # ...

      # ... Install many dependencies
      git clone --single-branch --branch 6.8.1 https://github.com/qt/qt5.git
      ./init-repository --module-subset=default --branch
      # ... Export pkg-config
      ./configure FEATURE_clang=ON -prefix $WORKDIR/qt6/host -- -Wno-dev
     ```

     **Reference**

     - https://github.com/PhysicsX/QTonRaspberryPi

2. **Manual Download:**
   - Download individual modules from [Qt Releases](https://download.qt.io/official_releases/qt/6.8/6.8.1/).
   - ⚠️ Note: Manual downloads may take longer due to slower server response times compared to Git's cloning protocol.

Due to these issues, the recommended approach is using the **Qt Online Installer**, which automates the process.

#### Addressing Installation Size Concerns

- Installation size often includes GUI tools like Qt Creator. These can be excluded during installation.
- By selecting only required modules (e.g., `QtBase`, `QtMultimedia`), the installation can be reduced to match the size of manually compiled binaries.
- ⚠️ For deploying to target devices, avoid installing development headers and tools (`-dev` packages).

⭕ Refer to

1.  [**Qt Online Installer (64-bit)**](https://download.qt.io/official_releases/online_installers/)
2.  [**Get and Install Qt with Command Line Interface**](https://doc.qt.io/qt-6/get-and-install-qt-cli.html#installing-with-user-interaction) for details on minimizing installation size. Below is a breakdown of package contents:

| Alias Package Name       | Contents                                                            |
| ------------------------ | ------------------------------------------------------------------- |
| `qt6.8.0-essentials`     | Essential module libraries, runtime tools, development tools        |
| `qt6.8.0-essentials-dev` | Includes headers, private headers, development tools                |
| `qt6.8.0-full`           | All modules (essential + add-ons), runtime tools, development tools |
| `qt6.8.0-full-dev`       | Full package with headers, private headers, development tools       |
| `qt6.8.0-full-dbg`       | Debug information for essential and add-on modules                  |
| `qt6.8.0-sdk`            | Qt Creator, Ninja, CMake, and all development tools and modules     |

## Transition Guide to 64-bit Environment

### Prepare 64-bit Raspberry Pi OS

1. **Download the OS:**
   - [Raspberry Pi OS (64-bit)](https://www.raspberrypi.com/software/).
2. **Install:**
   - Use Raspberry Pi Imager to flash the OS onto an SD card.

### Configure the Kernel Driver for 64-bit

1. **Set Kernel Parameters:**

   - (⚖️ default) Ensure `/boot/config.txt` includes `arm_64bit=1` for enabling 64-bit mode.

2. **Build Kernel Drivers:**
   - Use the `aarch64-linux-gnu-` toolchain.
   - Update the Makefile:
     ```makefile
     # Change to 64-bit toolchain
     TARGET_TOOLCHAIN := aarch64-linux-gnu
     KERNEL_ARCHITECTURE := arm64
     CPU_ARCH_FLAGS := -march=armv8-a
     ```
