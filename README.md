# Synergy Hub Documentation

- [Synergy Hub Documentation](#synergy-hub-documentation)
  - [🔧 Tech Stack](#-tech-stack)
  - [📌 Project Shortcuts](#-project-shortcuts)
    - [Mini Project](#mini-project)
  - [🌐 Open Source Contributions](#-open-source-contributions)
    - [Issues Overview](#issues-overview)
    - [Steam Workshop Contributions](#steam-workshop-contributions)
  - [🖋️ Scripts](#️-scripts)
  - [📈 Trend](#-trend)
  - [🚀 Project Setup Instructions (Ubuntu)](#-project-setup-instructions-ubuntu)
  - [📏 Rule](#-rule)

## 🔧 Tech Stack

tree [**prototypes/\_lab/tech_stack**](prototypes/_lab/tech_stack)  
 ├── 📂 build_tool  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 build_system  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 meta_build_system  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 yocto_project  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [**BitBake**](prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/bitbake.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [**Yocto**](prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/yocto.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [**Ninja**](prototypes/_lab/tech_stack/build_tool/build_system/ninja.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [**Make**](prototypes/_lab/tech_stack/build_tool/build_system/make.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 build_system_generator  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [![CMake](https://img.shields.io/badge/CMake-%23008FBA.svg?style=plastic&logo=cmake&logoColor=white)](prototypes/_lab/tech_stack/build_tool/build_system_generator/cmake.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [![Gradle](https://img.shields.io/badge/Gradle-02303A.svg?style=plastic&logo=Gradle&logoColor=white)](prototypes/_lab/tech_stack/build_tool/build_system_generator/gradle.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [![PlatformIO](https://img.shields.io/badge/PlatformIO-%23222.svg?style=plastic&logo=platformio&logoColor=%23f5822a)](prototypes/_lab/tech_stack/build_tool/build_system_generator/gradle.txt)  
 ├── 📂 ci+cd  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=plastic&logo=githubactions&logoColor=white)](prototypes/_lab/tech_stack/ci+cd/github_actions.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [**Make**](prototypes/_lab/tech_stack/build_tool/build_system/make.txt)  
 ├── 📂 code_quality_tool  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [Ruff](prototypes/_lab/tech_stack/code_quality_tool/ruff.txt)  
 ├── 📂 database  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=plastic&logo=mariadb&logoColor=white)](prototypes/_lab/tech_stack/database/mariadb.txt)  
 ├── 📂 design_pattern_and_uml  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [d2](prototypes/_lab/tech_stack/design_pattern_and_uml/d2.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [design_pattern](prototypes/_lab/tech_stack/design_pattern_and_uml/design_pattern.txt)  
 ├── 📂 editor  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 gui_based-ide  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [microchip_studio](prototypes/_lab/tech_stack/editor/gui_based-ide/microchip_studio.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [visual_studio](prototypes/_lab/tech_stack/editor/gui_based-ide/visual_studio.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=plastic&logo=visual-studio-code&logoColor=white)](prototypes/_lab/tech_stack/editor/gui_based-ide/vs_code.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 terminal_based  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [![Helix](https://img.shields.io/badge/Helix-%2328153e.svg?style=plastic&logo=helix&logoColor=white)](prototypes/_lab/tech_stack/editor/terminal_based/helix.txt)  
 ├── [fonts](prototypes/_lab/tech_stack/fonts.txt)  
 ├── 📂 hardware_and_os  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 arm  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [arm_compiler](prototypes/_lab/tech_stack/hardware_and_os/arm/arm_compiler.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 board  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [![Arduino](https://img.shields.io/badge/-Arduino-00979D?style=plastic&logo=Arduino&logoColor=white)](prototypes/_lab/tech_stack/hardware_and_os/board/arduino.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 os  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 linux  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [![Kubuntu](https://img.shields.io/badge/-KUbuntu-%230079C1?style=plastic&logo=kubuntu&logoColor=white)](prototypes/_lab/tech_stack/hardware_and_os/os/linux/kubuntu.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=plastic&logo=ubuntu&logoColor=white)](prototypes/_lab/tech_stack/hardware_and_os/os/linux/ubuntu.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [![Linux](https://img.shields.io/badge/Linux-FCC624?style=plastic&logo=linux&logoColor=black)](prototypes/_lab/tech_stack/hardware_and_os/os/linux.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 platform  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [![Raspberry Pi](https://img.shields.io/badge/-Raspberry_Pi-C51A4A?style=plastic&logo=Raspberry-Pi)](prototypes/_lab/tech_stack/hardware_and_os/platform/linux-raspberry_pi.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 serial_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [tio](prototypes/_lab/tech_stack/hardware_and_os/serial_tools/tio.txt)  
 ├── 📂 libraries_and_frameworks  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 mobile  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [![Android](https://img.shields.io/badge/Android-3DDC84?style=plastic&logo=android&logoColor=white)](prototypes/_lab/tech_stack/libraries_and_frameworks/mobile/android_sdk.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 multimedia  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 vision  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [![OpenCV](https://img.shields.io/badge/opencv-%23white.svg?style=plastic&logo=opencv&logoColor=white)](prototypes/_lab/tech_stack/libraries_and_frameworks/multimedia/vision/library-opencv.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 robot  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [![ROS](https://img.shields.io/badge/ros-%230A0FF9.svg?style=plastic&logo=ros&logoColor=white)](prototypes/_lab/tech_stack/libraries_and_frameworks/robot/framework-ros.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [![Qt](https://img.shields.io/badge/Qt-%23217346.svg?style=plastic&logo=Qt&logoColor=white)](prototypes/_lab/tech_stack/libraries_and_frameworks/framework-qt.txt)  
 ├── 📂-![LLVM](https://img.shields.io/badge/LLVM-%23262D3A.svg?style=plastic&logo=llvm&logoColor=white)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [**clang**](prototypes/_lab/tech_stack/llvm_stack/clang.txt)  
 ├── 📂 mathematics  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [mathematics_symbols](prototypes/_lab/tech_stack/mathematics/mathematics_symbols.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 ml  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [ml-glossary.md](prototypes/_lab/tech_stack/mathematics/ml/ml-glossary.md)  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [openmmlab](prototypes/_lab/tech_stack/mathematics/ml/openmmlab.txt)  
 ├── 📂 monitoring_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 file_system_monitoring  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [inotify-tools](prototypes/_lab/tech_stack/monitoring_tools/file_system_monitoring/inotify-tools.txt)  
 ├── 📂 package_manager  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![Nix](https://img.shields.io/badge/NIX-5277C3.svg?style=plastic&logo=NixOS&logoColor=white)](prototypes/_lab/tech_stack/package_manager/env-nix.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![Conan](https://img.shields.io/badge/Conan-%236699CB.svg?style=plastic&logo=conan&logoColor=white)](prototypes/_lab/tech_stack/package_manager/lang-conan.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![Poetry](https://img.shields.io/badge/Poetry-%233B82F6.svg?style=plastic&logo=poetry&logoColor=0B3D8D)](prototypes/_lab/tech_stack/package_manager/lang-poetry.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![Homebrew](https://img.shields.io/badge/Homebrew-%23FBB040.svg?style=plastic&logo=homebrew&logoColor=white)](prototypes/_lab/tech_stack/package_manager/sys-homebrew.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [env-volta](prototypes/_lab/tech_stack/package_manager/env-volta.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-cargo](prototypes/_lab/tech_stack/package_manager/lang-cargo.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-pipx](prototypes/_lab/tech_stack/package_manager/lang-pipx.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-choco](prototypes/_lab/tech_stack/package_manager/sys-choco.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pacman](prototypes/_lab/tech_stack/package_manager/sys-pacman.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pixi](prototypes/_lab/tech_stack/package_manager/sys-pixi.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [sys-scoop](prototypes/_lab/tech_stack/package_manager/sys-scoop.txt)  
 ├── 📂 programming_languages  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![C](https://img.shields.io/badge/c-%2300599C.svg?style=plastic&logo=c&logoColor=white)](prototypes/_lab/tech_stack/programming_languages/c+cpp.txt) [![C++](https://img.shields.io/badge/c++-%2300599C.svg?style=plastic&logo=c%2B%2B&logoColor=white)](prototypes/_lab/tech_stack/programming_languages/c+cpp.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=plastic&logo=openjdk&logoColor=white)](prototypes/_lab/tech_stack/programming_languages/java.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![Kotlin](https://img.shields.io/badge/kotlin-%237F52FF.svg?style=plastic&logo=kotlin&logoColor=white)](prototypes/_lab/tech_stack/programming_languages/kotlin.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [![Python](https://img.shields.io/badge/python-3670A0?style=plastic&logo=python&logoColor=ffdd54)](prototypes/_lab/tech_stack/programming_languages/python.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=plastic&logo=rust&logoColor=white)](prototypes/_lab/tech_stack/programming_languages/rust.txt)  
 ├── 📂 remote_access_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [tailscale](prototypes/_lab/tech_stack/remote_access_tools/tailscale.txt)  
 ├── 📂 scm  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [![Git](https://img.shields.io/badge/git-%23F05033.svg?style=plastic&logo=git&logoColor=white)](prototypes/_lab/tech_stack/scm/git.txt)  
 ├── 📂 shell  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [**Fish**](prototypes/_lab/tech_stack/shell/fish.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=plastic&logo=powershell&logoColor=white)](prototypes/_lab/tech_stack/shell/powershell.txt)  
 ├── 📂 terminal  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 emulator  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [**wezterm**](prototypes/_lab/tech_stack/terminal/emulator/wezterm.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 graphics_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [timg](prototypes/_lab/tech_stack/terminal/graphics_tools/timg.txt)  
 ├── 📂 virtualization  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 os_level_virtualization  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [**dev_env-devcontainer**](prototypes/_lab/tech_stack/virtualization/os_level_virtualization/dev_env-devcontainer.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=plastic&logo=docker&logoColor=white)](prototypes/_lab/tech_stack/virtualization/os_level_virtualization/runtime-docker.txt)  
 └── 📂 web  
 ├── 📂 web_browser  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [![Edge](https://img.shields.io/badge/Edge-0078D7?style=plastic&logo=Microsoft-edge&logoColor=white)](prototypes/_lab/tech_stack/web/web_browser/edge.txt)  
 └── 📂 web_server  
 &nbsp;&nbsp;&nbsp;&nbsp;└── [![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=plastic&logo=nginx&logoColor=white)](prototypes/_lab/tech_stack/web/web_server/nginx.txt)

## 📌 Project Shortcuts

- 🎱 📰 (Doing) [**스마트 택배 시스템**](prototypes/study/ros_study/ros-noetic-turtlebot3/README.md)

  📅 2025-01-20 ~

  🏷️ Tag: Turtlebot 3, ROS 1 Noetic, STM32 (Nucleo F411RE), CMake, Cross-Compilation (Qt), Qt, APM stack, TCP/IP, Android

  - 팀원: 6

  <!-- **STM32 Nucleo F411RE 기반 디지털 시계 및 알람 시스템** + -->

- 🎱 [**타이머 기반 LED 제어 시스템 (디바이스 드라이버, 애플리케이션)**](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/README.md)

  🏷️ Tag: C, Make, **ARMv8-a** (Raspberry Pi 4 B), Cross-Compilation (Kernel), clang, **Device Driver** (ioctl, Button ISR)

- 🎱 [**실시간 수신호 기반 자율주행 RC카**](https://github.com/lovelyPuppies/Project_SignalMaster) (External Link)

  🏷️ Tag: C, Python 3, Edge AI, On-Device, **Machine Learning** (Yolo v11), Arduino, JetSon Nano, Multi-Threading

  - 팀원: 3

    📜 역할: [**젯슨 나노 통합 및 머신러닝 모델 파이프라인 구현**](https://github.com/lovelyPuppies/Project_SignalMaster/tree/main/src/jetson-nano-mount/README.md) (External Link)

- 🎱 [**카메라 필터 애플리케이션**](prototypes/study/python_study/camera_filter_app/README.md)

  🏷️ Tag: Python 3, OpenCV, PySide6, **Machine Learning** (MediaPipe, Face Detection, Landmark Processing), Alpha Blending, Real-time Filters

  - 팀원: 4

    📜 역할: **[🌟 팀장] 토끼 귀 필터 구현 및 리팩터링, 프로젝트 다이어그램 작성.**

- 🎱 [**선풍기 제어 시스템**](https://github.com/lovelyPuppies/fanProject) (External Link)

  🏷️ Tag: C, ATmega128, AVR, **Peripherals** (UART, I2C, PWM, Timer), **Design Pattern** (MVP), Finite State Machine

- 🎱 [**환경 및 네트워크 초기화 자동화 스크립트 작성**](#️-scripts)

  🏷️ Tag: Fish script, PowerShell

- 🎱 [Private **LFS using docker**](prototypes/_initialization/lfs)

  🏷️ Tag: Docker, LFS

- 🎱 [**CS 연구 시각화 라이브러리**](https://github.com/wbfw109/study-core?tab=readme-ov-file#31-python-utilities) \(External Link\)

  &nbsp;&nbsp; ➡️ [**Web Hosting**](https://wbfw109.github.io/visualization_manager/ipython_central_control.html)

  🏷️ Tag: Python 3, GitHub Pages, Jupyter, IPython

- 🎱 [**CS 용어 사전 웹 애플리케이션**](https://github.com/wbfw109/study-core?tab=readme-ov-file#41-glossary-service) \(External Link\)

  🏷️ Tag: Python 3, [Pynecone (New: Reflex)](https://github.com/reflex-dev) (Full-stack framework)

- 🎱 [**IoT의 안전한 운영을 위한 Docker 기반 시스템 환경 설계 및 구현**](https://github.com/wbfw109/safe_iot_architecture) \(External Link\)

  🏷️ Tag: Java, Gradle, Docker, Docker Swarm

  ❗ **Broken:** The original README.md file is missing because a team member deleted the repository.

### Mini Project

- 🎱 [**Yocto for Raspberry Pi B4**](prototypes/study/bsp_study/raspberry_pi/kernel/mini-yocto.md)

  🏷️ Tag: Yocto Project, Raspberry Pi 4 B

## 🌐 Open Source Contributions

### Issues Overview

- ⏳ **Pending Issues**

  - 📅 2024-08-29: conan-io/conan 🔪 [[bug] in Ubuntu, clang, Ninja enviornment. ERROR: pulseaudio/14.2: Error in build() method, line 131 (external link)](https://github.com/conan-io/conan/issues/16905)
  - 📅 2024-08-29: conan-io/conan-center-index 🔪 [\[package\] pulseaudio/14.2 : I'm using clang 18 but error; Compiler does not support -std=gnu11](https://github.com/conan-io/conan-center-index/issues/25075)
  - 📅 2024-08-26: prefix-dev/pixi 🔪 [in VS Code, manifest PIXI_PROJECT_MANIFEST is not changed when open by command "code <path>](https://github.com/prefix-dev/pixi/issues/1907)

- ✅ **Resolved Issues**

  - 📅 2025-01-19: fish-shell/fish-shell 🔪 [whenever run `fish -c "sudo -v"`, it requires password every time in same terminal session](https://github.com/fish-shell/fish-shell/issues/11064)

    ➡️ Execute the raw output of eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" directly in your shell configuration in order to avoid **sudo cache invalidation** caused by **Homebrew policy changes**.

  - 📅 2024-10-17: opmaksim/Project_SignalMaster 🔪 [Python Jupyter Interactive Kernel crashed when use cv2.imshow()](https://github.com/opmaksim/Project_SignalMaster/issues/14)

    ➡️ On Jetson Nano and VS Code, avoid using `cv2.imshow()`. Instead, use the following workaround:

    ```python
    from IPython.display import clear_output, display
    ```

    The issue appears to stem from a combination of:

    - Accessing Jetson Nano via **VS Code's Remote-SSH**.
    - Running **Jupyter Notebook (IPython)**.
    - Using OpenCV without hardware acceleration.

    These factors likely led to increased CPU usage and memory shortage, resulting in a kernel crash in Jupyter Notebook.

### Steam Workshop Contributions

- 📅 2024-10-15: Choro Ark 🔪 Workshop Mod KR Localization 🔪 [Automation Scripts](https://steamcommunity.com/sharedfiles/filedetails/?id=3343188695&searchtext=)

  It identifies the Steam installation path, updates the `config.ini` file with the correct paths, and runs the localization application without manual intervention.

  ```powershell
  # 🐚 %shell> Powershell
  # 🚧 Prerequisite
  #   - Windows OS
  #   - Donet Installation: https://dotnet.microsoft.com/en-us/download/dotnet/8.0/runtime?cid=getdotnetcore&amp;os=windows&amp;arch=x64

  $steamInstallPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam").SteamPath
  $basePath = "$steamInstallPath\steamapps\workshop\content\1188930\3343188695\LocailzationAutoCopy"
  $configPath = "$basePath\config.ini"
  (Get-Content $configPath) | ForEach-Object {
  ($_ -match '^steampath\s*=') ? "steampath = $($steamInstallPath -replace '\\', '/')/steamapps" : $_
  } | Set-Content $configPath
  pushd $basePath; $env:DOTNET_ROOT = "C:\Program Files\dotnet"; & "$basePath\LocailzationAutoCopy.exe"; popd
  ```

## 🖋️ Scripts

tree [**prototypes/\_initialization/ubuntu**](prototypes/_initialization/ubuntu)  
├── 📂 fish_modules  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [\_import_all.fish](prototypes/_initialization/ubuntu/fish_modules/_import_all.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [argparse_utils.fish](prototypes/_initialization/ubuntu/fish_modules/argparse_utils.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [bookmark_utils.fish](prototypes/_initialization/ubuntu/fish_modules/bookmark_utils.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 io_utils  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [text_processing.fish](prototypes/_initialization/ubuntu/fish_modules/io_utils/text_processing.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [network_utils.fish](prototypes/_initialization/ubuntu/fish_modules/network_utils.fish)  
├── 📂 howto  
│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 beta  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [qcnet.fish](prototypes/_initialization/ubuntu/howto/beta/qcnet.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [template-netplan_static_ip_setup.fish](prototypes/_initialization/ubuntu/howto/beta/template-netplan_static_ip_setup.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 config-jetson_nano  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [setup_jetson_nano_vnc.fish](prototypes/_initialization/ubuntu/howto/config-jetson_nano/setup_jetson_nano_vnc.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 config-raspberry_pi  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [\_setup_fish_shell.fish](prototypes/_initialization/ubuntu/howto/config-raspberry_pi/_setup_fish_shell.sh)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [set_raspberry_pi_kernel_bitness.fish](prototypes/_initialization/ubuntu/howto/config-raspberry_pi/set_raspberry_pi_kernel_bitness.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 general  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [generate_clangdb.fish](prototypes/_initialization/ubuntu/howto/general/generate_clangdb.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [init_nfs-client_to_server.fish](prototypes/_initialization/ubuntu/howto/general/init_nfs-client_to_server.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [init_resolv_conf.fish](prototypes/_initialization/ubuntu/howto/general/init_resolv_conf.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [init_samba-client_to_server.fish](prototypes/_initialization/ubuntu/howto/general/init_samba-client_to_server.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [setup_x11_docker.fish](prototypes/_initialization/ubuntu/howto/general/setup_x11_docker.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [setup_xauthority.fish](prototypes/_initialization/ubuntu/howto/general/setup_xauthority.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 general_beta  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [migrate-apt-key-to-keyring.fish](prototypes/_initialization/ubuntu/howto/general_beta/migrate-apt-key-to-keyring.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [poetry_install_requirements.fish](prototypes/_initialization/ubuntu/howto/general_beta/poetry_install_requirements.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── \_internal  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 file_supervisor  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [inotify-make_fish_utilities_executable.fish](prototypes/_initialization/ubuntu/howto/_internal/file_supervisor/inotify-make_fish_utilities_executable.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [snippet.fish](prototypes/_initialization/ubuntu/howto/snippet.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 template  
├── [init_in_bash.sh](prototypes/_initialization/ubuntu/init_in_bash.sh)  
├── **[init_in_fish.fish](prototypes/_initialization/ubuntu/init_in_fish.fish)**  
├── [init_in_fish_semi_automatic.fish](prototypes/_initialization/ubuntu/init_in_fish_semi_automatic.fish)  
├── [init_in_fish_semi_automatic-vision.fish](prototypes/_initialization/ubuntu/init_in_fish_semi_automatic-vision.fish)  
└── 📂 recipes  
&nbsp;&nbsp;&nbsp;&nbsp;└── [fix_locale_warning.recipe.fish](prototypes/_initialization/ubuntu/recipes/fix_locale_fallback_warning.fish)

## 📈 Trend

tree [**prototypes/\_initialization/\_about**](prototypes/_initialization/_about)  
├── [about-intellisense_for_c_cpp.md](prototypes/_initialization/_about/about-intellisense_for_c_cpp.md)  
├── 📂 compare_similar_functinalities  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [kmsg_vs_journalctl.md](prototypes/_initialization/_about/compare_similar_functinalities/kmsg_vs_journalctl.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [video_streaming-seraizliation_vs_compression.md](prototypes/_initialization/_about/compare_similar_functinalities/video_streaming-seraizliation_vs_compression.md)  
└── 📂 compare_trend  
&nbsp;&nbsp;&nbsp;&nbsp;├── [git_switch_and_restore_instead_of_git_checkout.md](prototypes/_initialization/_about/compare_trend/git_switch_and_restore_instead_of_git_checkout.md)  
&nbsp;&nbsp;&nbsp;&nbsp;├── [netplan-efficient-usage.md](prototypes/_initialization/_about/compare_trend/netplan-efficient-usage.md)  
&nbsp;&nbsp;&nbsp;&nbsp;├── [netplan-vs-etc_network_interfaces.md](prototypes/_initialization/_about/compare_trend/netplan-vs-etc_network_interfaces.md)  
&nbsp;&nbsp;&nbsp;&nbsp;├── [preferring_gpiod_and_other_control_methods_over_sysfs_and_ioctl_for_device_control.md](prototypes/_initialization/_about/compare_trend/preferring_gpiod_and_other_control_methods_over_sysfs_and_ioctl_for_device_control.md)  
&nbsp;&nbsp;&nbsp;&nbsp;├── [raspberry_pi_64bit_environment_with_qt.md](prototypes/_initialization/_about/compare_trend/raspberry_pi_64bit_environment_with_qt.md)  
&nbsp;&nbsp;&nbsp;&nbsp;└── [why_thread_became_the_standard_in_matter.md](prototypes/_initialization/_about/compare_trend/why_thread_became_the_standard_in_matter.md)

---

## 🚀 Project Setup Instructions (Ubuntu)

1. Common Configurations:

   - 🎱 Copy **[settings.json](prototypes/_initialization/.vscode/_user-settings.jsonc)** to your user settings.
   - 🎱 Copy **[keybindings.json](prototypes/_initialization/.vscode/_user-keybindings.jsonc)** to your user keybindings.
   - 🎱 Copy **[extensions.json](prototypes/_initialization/.vscode/extensions.json)** to your project settings for VS Code recommendations in the mono-repository
   - 🎱 Copy **[tasks.json](prototypes/_initialization/.vscode/tasks.jsonc)** your project settings for common tasks.

2. Run **[initialization script](prototypes/_initialization/ubuntu/init_in_bash.sh)**:

   📝 Note that this script requires the password to be entered multiple times \(3 times\), because **[Homebrew command invalidates the sudo timestamp \(sudo password cache\)](https://github.com/Homebrew/brew/issues/17905#issuecomment-2258522878)**.

   > `This is likely a WONTFIX, sorry. We clear the sudo password cache intentionally as a precaution against privilege escalation attacks. See https://brew.sh/2024/07/30/homebrew-security-audit/.`

   ```bash
   #!/bin/bash
   bash prototypes/_initialization/ubuntu/init_in_bash.sh
   ```

   It automatically and additionally runs 🚣 **[init_in_fish.fish](prototypes/_initialization/ubuntu/init_in_fish.fish)** as the last line in the script.

3. **[Use semi-automatic script snippets for user-interactive tasks](prototypes/_initialization/ubuntu/init_in_fish_semi_automatic.fish)**

   ➡️ Refer to `prototypes/_initialization/ubuntu/init_in_fish_semi_automatic.fish`

   > This file contains script snippets for user-interactive tasks.  
   > Please **read the script carefully** and install only the necessary packages.

4. Update and upgrade your system periodically:

   ```bash
   #!/bin/bash
   sudo apt update && sudo apt upgrade -y
   sudo snap refresh
   flatpak update -y
   brew update && brew upgrade
   ```

## 📏 Rule

- [Emoji rule](prototypes/_initialization/_rule/emoji.txt)
- [Badge rule](prototypes/_initialization/_rule/badge.txt)
