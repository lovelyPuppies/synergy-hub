# Synergy Hub Documentation

📅 Modified at 2024-12-31 19:44:10

- [Synergy Hub Documentation](#synergy-hub-documentation)
  - [📌 Project Shortcuts](#-project-shortcuts)
  - [🌐 Open Source Contributions](#-open-source-contributions)
    - [Issues Overview](#issues-overview)
    - [Steam Workshop Contributions](#steam-workshop-contributions)
  - [🔧 Tech Stack](#-tech-stack)
  - [🖋️ Scripts](#️-scripts)
  - [📈 Trend](#-trend)
  - [🚀 Project Setup Instructions (Ubuntu)](#-project-setup-instructions-ubuntu)
  - [📏 Rule](#-rule)

## 📌 Project Shortcuts

- [**Jetson Nano와 Edge AI를 활용한 실시간 수신호 인식 자율주행 RC카 개발 프로젝트**](https://github.com/lovelyPuppies/Project_SignalMaster) (External Link)

  🏷️ Tag: Python 3, C, Edge AI, On-Device, Yolo v11, JetSon Nano

  - 팀원: 3

    📜 **역할**: [젯슨 나노 통합 및 머신러닝 모델 파이프라인 구현](https://github.com/lovelyPuppies/Project_SignalMaster/tree/main/src/jetson-nano-mount/README.md) (External Link)

- [**ATmega128 기반 선풍기 제어 시스템**](https://github.com/lovelyPuppies/fanProject) (External Link)

  🏷️ Tag: C, ATmega128, AVR, Peripherals (UART, I2C, PWM, Timer), Design Pattern (MVP), Finite State Machine

- [**Opencv 및 MediaPipe 기반 카메라 필터 애플리케이션 개발**](prototypes/study/python_study/camera_filter_app)

  🏷️ Tag: Python 3, OpenCV, MediaPipe, PySide6, Face Detection, Landmark Processing, Alpha Blending, Real-time Filters

  - 팀원: 4

    📜 **역할**: [🌟 팀장] 토끼 귀 필터 구현 및 리팩터링, 프로젝트 다이어그램 작성.

- [**Raspberry Pi 4 B 기반 커널 모듈 및 디바이스 드라이버 구현 (LED 제어)**](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer)

  🏷️ Tag: C, Make, clang

- [**환경 및 네트워크 초기화 자동화 스크립트 작성**](#️-scripts)

  🏷️ Tag: Fish script, PowerShell

- [synergy-hub **LFS using docker**](prototypes/_initialization/lfs)

  🏷️ Tag: Docker, LFS

- [**Python 및 IPython 기반 CS 지식 연구 결과를 웹에 시각화하기 위한 라이브러리 개발**](https://github.com/wbfw109/study-core?tab=readme-ov-file#31-python-utilities) \(External Link\)

  &nbsp;&nbsp; ➡️ [Web Hosting](https://wbfw109.github.io/visualization_manager/ipython_central_control.html)

  🏷️ Tag: Python 3, GitHub Pages, Jupyter

- [**Turtlebot 3**](prototypes/study/ros_study/ros-noetic-turtlebot3)

  📰 Doing ...

- **STM32 Nucleo F411RE 기반 디지털 시계 및 알람 시스템 구현**

  📰 Doing ...

- [**Pynecone (현재 Reflex) 를 활용한 CS 용어 사전 웹 애플리케이션 개발**](https://github.com/wbfw109/study-core?tab=readme-ov-file#41-glossary-service) \(External Link\)

  🏷️ Tag: Python 3, [Pynecone](https://github.com/reflex-dev) (Full-stack framework)

- [**IoT의 안전한 운영을 위한 Docker 기반 시스템 환경 설계 및 구현**](https://github.com/wbfw109/safe_iot_architecture) \(External Link\)

  🏷️ Tag: Java, Gradle, Docker, Docker Swarm

  ❗ **Broken:** The original README.md file is missing because a team member deleted the repository.

## 🌐 Open Source Contributions

### Issues Overview

- ⏳ **Pending Issues**

  - 📅 2025-01-19: fish-shell/fish-shell 🔪 [whenever run `fish -c "sudo -v"`, it requires password every time in same terminal session](https://github.com/fish-shell/fish-shell/issues/11064)
  - 📅 2024-08-29: conan-io/conan 🔪 [[bug] in Ubuntu, clang, Ninja enviornment. ERROR: pulseaudio/14.2: Error in build() method, line 131 (external link)](https://github.com/conan-io/conan/issues/16905)
  - 📅 2024-08-29: conan-io/conan-center-index 🔪 [\[package\] pulseaudio/14.2 : I'm using clang 18 but error; Compiler does not support -std=gnu11](https://github.com/conan-io/conan-center-index/issues/25075)
  - 📅 2024-08-26: prefix-dev/pixi 🔪 [in VS Code, manifest PIXI_PROJECT_MANIFEST is not changed when open by command "code <path>](https://github.com/prefix-dev/pixi/issues/1907)

- ✅ **Resolved Issues**

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

## 🔧 Tech Stack

tree [**prototypes/\_lab/tech_stack**](prototypes/_lab/tech_stack)  
 ├── 📂 build_tool  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 build_system  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 meta_build_system  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 yocto_project  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/bitbake.txt"><img src="https://img.shields.io/badge/-Bitbake-00599C?logo=yocto&logoColor=white" alt="bitbake" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/yocto.txt"><img src="https://img.shields.io/badge/-Yocto-00599C?logo=yocto&logoColor=white" alt="yocto" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/build_tool/build_system/ninja.txt"><img src="https://img.shields.io/badge/-Ninja-013243?logo=ninja&logoColor=white" alt="ninja" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/build_tool/build_system/make.txt"><img src="https://img.shields.io/badge/-Make-940E1B?logo=gnu&logoColor=white" alt="make" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 build_system_generator  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/build_tool/build_system_generator/cmake.txt"><img src="https://img.shields.io/badge/-CMake-064F8C?logo=cmake&logoColor=white" alt="cmake" /></a>  
 ├── 📂 code_quality_tool  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/code_quality_tool/ruff.txt"><img src="https://img.shields.io/badge/-Ruff-000000?logo=python&logoColor=white" alt="ruff" /></a>  
 ├── 📂 design_pattern_and_uml  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [d2](prototypes/_lab/tech_stack/design_pattern_and_uml/d2.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [design_pattern](prototypes/_lab/tech_stack/design_pattern_and_uml/design_pattern.txt)  
 ├── 📂 editor  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 gui_based-ide  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [microchip_studio](prototypes/_lab/tech_stack/editor/gui_based-ide/microchip_studio.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [visual_studio](prototypes/_lab/tech_stack/editor/gui_based-ide/visual_studio.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/editor/gui_based-ide/vs_code.txt"><img src="https://img.shields.io/badge/-VS%20Code-007ACC?logo=visualstudiocode&logoColor=white" alt="vs_code" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 terminal_based  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/editor/terminal_based/helix.txt"><img src="https://img.shields.io/badge/-Helix-4A4A4A?logo=helix&logoColor=white" alt="helix" /></a>  
 ├── [fonts](prototypes/_lab/tech_stack/fonts.txt)  
 ├── 📂 hardware_and_os  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 arm  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [arm_compiler](prototypes/_lab/tech_stack/hardware_and_os/arm/arm_compiler.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [Issues.md](prototypes/_lab/tech_stack/hardware_and_os/Issues.md)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 os  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 linux  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/hardware_and_os/os/linux/ubuntu.txt"><img src="https://img.shields.io/badge/-Ubuntu-E95420?logo=ubuntu&logoColor=white" alt="ubuntu" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/hardware_and_os/os/linux/raspberry_pi.txt"><img src="https://img.shields.io/badge/-Raspberry%20Pi-A22846?style=flat-square&logo=raspberrypi&logoColor=white" alt="Raspberry Pi" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/hardware_and_os/os/linux.txt"><img src="https://img.shields.io/badge/-Linux-FCC624?logo=linux&logoColor=black" alt="linux" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 serial_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [tio](prototypes/_lab/tech_stack/hardware_and_os/serial_tools/tio.txt)  
 ├── 📂 libraries_and_frameworks  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 robot  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/libraries_and_frameworks/robot/framework-ros.txt"><img src="https://img.shields.io/badge/-ROS-22314E?logo=ros&logoColor=white" alt="ros" /></a>  
 ├── 📂 llvm_stack  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/llvm_stack/clang.txt"><img src="https://img.shields.io/badge/-Clang-F34B7D?logo=llvm&logoColor=white" alt="clang" /></a>  
 ├── 📂 mathmatics  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [mathmatics_symbols](prototypes/_lab/tech_stack/mathmatics/mathmatics_symbols.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 ml  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [ml-glossary.md](prototypes/_lab/tech_stack/mathmatics/ml/ml-glossary.md)  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [openmmlab](prototypes/_lab/tech_stack/mathmatics/ml/openmmlab.txt)  
 ├── 📂 monitoring_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 file_system_monitoring  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/monitoring_tools/file_system_monitoring/inotify-tools.txt"><img src="https://img.shields.io/badge/-Inotify--Tools-0C91A1" alt="inotify-tools" /></a>  
 ├── 📂 package_manager  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [env-nix](prototypes/_lab/tech_stack/package_manager/env-nix.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [env-volta](prototypes/_lab/tech_stack/package_manager/env-volta.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-cargo](prototypes/_lab/tech_stack/package_manager/lang-cargo.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/package_manager/lang-conan.txt"><img src="https://img.shields.io/badge/-Conan-004080?logo=conan&logoColor=white" alt="lang-conan" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-pipx](prototypes/_lab/tech_stack/package_manager/lang-pipx.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/package_manager/lang-poetry.txt"><img src="https://img.shields.io/badge/-Poetry-60A5FA?logo=python&logoColor=white" alt="lang-poetry" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-choco](prototypes/_lab/tech_stack/package_manager/sys-choco.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-homebrew](prototypes/_lab/tech_stack/package_manager/sys-homebrew.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pacman](prototypes/_lab/tech_stack/package_manager/sys-pacman.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pixi](prototypes/_lab/tech_stack/package_manager/sys-pixi.txt)  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [sys-scoop](prototypes/_lab/tech_stack/package_manager/sys-scoop.txt)  
 ├── 📂 programming_languages  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/programming_languages/c+cpp.txt"><img src="https://img.shields.io/badge/-C-00599C?logo=c&logoColor=white" alt="C" /></a><a href="prototypes/_lab/tech_stack/programming_languages/c+cpp.txt"><img src="https://img.shields.io/badge/-C++-00599C?logo=cplusplus&logoColor=white" alt="C++" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/programming_languages/java.txt"><img src="https://img.shields.io/badge/-Java-007396?logo=java&logoColor=white" alt="Java" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/programming_languages/python.txt"><img src="https://img.shields.io/badge/-Python-3776AB?logo=python&logoColor=white" alt="python" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/programming_languages/rust.txt"><img src="https://img.shields.io/badge/-Rust-000000?logo=rust&logoColor=white" alt="rust" /></a>  
 ├── 📂 remote_access_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [tailscale](prototypes/_lab/tech_stack/remote_access_tools/tailscale.txt)  
 ├── 📂 scm  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/scm/git.txt"><img src="https://img.shields.io/badge/-Git-F05032?logo=git&logoColor=white" alt="Git" /></a>  
 ├── 📂 shell  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── <a href="prototypes/_lab/tech_stack/shell/fish.txt"><img src="https://img.shields.io/badge/-Fish%20Shell-FFCB2F?logo=fish&logoColor=white" alt="fish" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/shell/powershell.txt"><img src="https://img.shields.io/badge/-PowerShell-5391FE?logo=powershell&logoColor=white" alt="PowerShell" /></a>  
 ├── 📂 terminal  
 │&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 emulator  
 │&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/terminal/emulator/wezterm.txt"><img src="https://img.shields.io/badge/-WezTerm-4D4D4D" alt="wezterm" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 graphics_tools  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/terminal/graphics_tools/timg.txt"><img src="https://img.shields.io/badge/-Timg-0099CC" alt="timg" /></a>  
 ├── 📂 virtualization  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 os_level_virtualization  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/virtualization/os_level_virtualization/dev_env-devcontainer.txt"><img src="https://img.shields.io/badge/-DevContainer-0078D7?logo=visualstudiocode&logoColor=white" alt="dev_env-devcontainer" /></a>  
 │&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/virtualization/os_level_virtualization/runtime-docker.txt"><img src="https://img.shields.io/badge/-Docker-2496ED?logo=docker&logoColor=white" alt="runtime-docker" /></a>  
 └── 📂 web  
 ├── 📂 web_browser  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [edge](prototypes/_lab/tech_stack/web/web_browser/edge.txt)  
 └── 📂 web_server  
 &nbsp;&nbsp;&nbsp;&nbsp;└── <a href="prototypes/_lab/tech_stack/web/web_server/nginx.txt"><img src="https://img.shields.io/badge/-Nginx-269539?logo=nginx&logoColor=white" alt="nginx" /></a>

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
│&nbsp;&nbsp;&nbsp;&nbsp;├── [snippet.fish](prototypes/_initialization/ubuntu/howto/snippet.fish)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 template  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [README.md](prototypes/_initialization/ubuntu/howto/template/README.md)  
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

   📝 Note that this script requires the password to be entered multiple times \(about 4 times\), because **[Homebrew command invalidates the sudo timestamp \(sudo password cache\)](https://github.com/Homebrew/brew/issues/17905#issuecomment-2258522878)**.

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
