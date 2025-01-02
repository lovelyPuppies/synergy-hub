# Synergy Hub Documentation

📅 Modified at 2024-12-31 19:44:10

- [Synergy Hub Documentation](#synergy-hub-documentation)
  - [🗂 Directory Structure](#-directory-structure)
  - [📌 Project Shortcuts](#-project-shortcuts)
  - [🔧 Tech Stack](#-tech-stack)
  - [❓ Issues tracking](#-issues-tracking)
  - [🚀 Project Setup Instructions (Ubuntu)](#-project-setup-instructions-ubuntu)
  - [📏 Rule](#-rule)

## 🗂 Directory Structure

```
📁 projects (📰 TODO)
└── 📂 embedded
├── 📁 project_alarm_clock
└── 📁 smart_trash_bin
```

## 📌 Project Shortcuts

- [**ATmega128 기반 선풍기 제어 시스템**](https://github.com/lovelyPuppies/fanProject) (External Link)

  🏷️ Tag: ATmega128, AVR, Peripherals (UART, I2C, PWM, Timer), Design Pattern (MVP), Finite State Machine

- [**Raspberry Pi 4 B 기반 커널 모듈 및 디바이스 드라이버 구현 (LED 제어)**](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/README.md)
  🏷️ Tag: ...

- [**Jetson Nano와 Edge AI를 활용한 실시간 수신호 인식 자율주행 RC카 개발 프로젝트**](https://github.com/opmaksim/Signal-Project) (External Link)

  🏷️ Tag: Edge AI, On-Device, Yolo v11, JetSon Nano, ...

- **STM32 Nucleo F411RE 기반 디지털 시계 및 알람 시스템 구현**: TODO
- [**Python 및 MediaPipe 기반 카메라 필터 애플리케이션 개발**](prototypes/study/python_study/camera_filter_app)
  🏷️ Tag: OpenCV, MediaPipe, ...

- [**환경 및 네트워크 초기화 자동화 스크립트 작성**](prototypes/_initialization)
  🏷️ Tag: Fish script, ...

- [synergy-hub **LFS using docker**](prototypes/_initialization/lfs/README.md)
  🏷️ Tag: Docker, LFS

- [**IoT의 안전한 운영을 위한 Docker 기반 시스템 환경 설 계 및 구현**](https://github.com/wbfw109/safe_iot_architecture) \(External Link\)
- [**Python 및 IPython 기반 CS 지식 연구 결과를 웹에 시각화하기 위한 라이브러리 개발**](https://github.com/wbfw109/study-core?tab=readme-ov-file#31-python-utilities) \(External Link\)
- [**Pynecone를 활용한 CS 용어 사전 웹 애플리케이션 개발**](https://github.com/wbfw109/study-core?tab=readme-ov-file#41-glossary-service) \(External Link\)

## 🔧 Tech Stack

tree [**prototypes/\_lab/tech_stack**](prototypes/_lab/tech_stack)  
├── build_tool  
│&nbsp;&nbsp;&nbsp;&nbsp;├── build_system  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── meta_build_system  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── yocto_project  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [bitbake](prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/bitbake.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [yocto](prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/yocto.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [ninja](prototypes/_lab/tech_stack/build_tool/build_system/ninja.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── build_system_generator  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── **[cmake](prototypes/_lab/tech_stack/build_tool/build_system_generator/cmake.txt)**  
├── code_quality_tool  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [ruff](prototypes/_lab/tech_stack/code_quality_tool/ruff.txt)  
├── design_pattern_and_uml  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [d2](prototypes/_lab/tech_stack/design_pattern_and_uml/d2.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [design_pattern](prototypes/_lab/tech_stack/design_pattern_and_uml/design_pattern.txt)  
├── editor  
│&nbsp;&nbsp;&nbsp;&nbsp;├── gui_based-ide  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [microchip_studio](prototypes/_lab/tech_stack/editor/gui_based-ide/microchip_studio.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [visual_studio](prototypes/_lab/tech_stack/editor/gui_based-ide/visual_studio.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── **[vs_code](prototypes/_lab/tech_stack/editor/gui_based-ide/vs_code.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;└── terminal_based  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [helix](prototypes/_lab/tech_stack/editor/terminal_based/helix.txt)  
├── [fonts](prototypes/_lab/tech_stack/fonts.txt)  
├── hardware_and_os  
│&nbsp;&nbsp;&nbsp;&nbsp;├── arm  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [arm_compiler](prototypes/_lab/tech_stack/hardware_and_os/arm/arm_compiler.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── hardware  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [nvidia](prototypes/_lab/tech_stack/hardware_and_os/hardware/nvidia.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [Issues.md](prototypes/_lab/tech_stack/hardware_and_os/Issues.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── os  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── linux  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── **[ubuntu](prototypes/_lab/tech_stack/hardware_and_os/os/linux/ubuntu.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── **[linux](prototypes/_lab/tech_stack/hardware_and_os/os/linux.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;└── serial_tools  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [tio](prototypes/_lab/tech_stack/hardware_and_os/serial_tools/tio.txt)  
├── libraries  
│&nbsp;&nbsp;&nbsp;&nbsp;└── cpp  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [google_test](prototypes/_lab/tech_stack/libraries/cpp/google_test.txt)  
├── llvm_stack  
│&nbsp;&nbsp;&nbsp;&nbsp;└── **[clang](prototypes/_lab/tech_stack/llvm_stack/clang.txt)**  
├── mathmatics  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [mathmatics_symbols](prototypes/_lab/tech_stack/mathmatics/mathmatics_symbols.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── ml  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [ml-glossary.md](prototypes/_lab/tech_stack/mathmatics/ml/ml-glossary.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [openmmlab](prototypes/_lab/tech_stack/mathmatics/ml/openmmlab.txt)  
├── monitoring_tools  
│&nbsp;&nbsp;&nbsp;&nbsp;└── file_system_monitoring  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [watchman](prototypes/_lab/tech_stack/monitoring_tools/file_system_monitoring/watchman.txt)  
├── package_manager  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [env-nix](prototypes/_lab/tech_stack/package_manager/env-nix.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [env-volta](prototypes/_lab/tech_stack/package_manager/env-volta.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-cargo](prototypes/_lab/tech_stack/package_manager/lang-cargo.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── **[lang-conan](prototypes/_lab/tech_stack/package_manager/lang-conan.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-pipx](prototypes/_lab/tech_stack/package_manager/lang-pipx.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── **[lang-poetry](prototypes/_lab/tech_stack/package_manager/lang-poetry.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-choco](prototypes/_lab/tech_stack/package_manager/sys-choco.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-homebrew](prototypes/_lab/tech_stack/package_manager/sys-homebrew.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pacman](prototypes/_lab/tech_stack/package_manager/sys-pacman.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pixi](prototypes/_lab/tech_stack/package_manager/sys-pixi.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [sys-scoop](prototypes/_lab/tech_stack/package_manager/sys-scoop.txt)  
├── programming_languages  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [c+cpp](prototypes/_lab/tech_stack/programming_languages/c+cpp.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [java](prototypes/_lab/tech_stack/programming_languages/java.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [python](prototypes/_lab/tech_stack/programming_languages/python.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [rust](prototypes/_lab/tech_stack/programming_languages/rust.txt)  
├── remote_access_tools  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [tailscale](prototypes/_lab/tech_stack/remote_access_tools/tailscale.txt)  
├── scm  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [git](prototypes/_lab/tech_stack/scm/git.txt)  
├── shell  
│&nbsp;&nbsp;&nbsp;&nbsp;├── **[fish](prototypes/_lab/tech_stack/shell/fish.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [powershell](prototypes/_lab/tech_stack/shell/powershell.txt)  
├── terminal  
│&nbsp;&nbsp;&nbsp;&nbsp;├── emulator  
│&nbsp;&nbsp;&nbsp;&nbsp;└── **[wezterm](prototypes/_lab/tech_stack/terminal_emulator/wezterm.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── **[wezterm](prototypes/_lab/tech_stack/terminal/emulator/wezterm.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;└── graphics_tools  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── **[timg](prototypes/_lab/tech_stack/terminal/graphics_tools/timg.txt)**  
├── virtualization  
│&nbsp;&nbsp;&nbsp;&nbsp;└── os_level_virtualization  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [container-dev_container](prototypes/_lab/tech_stack/virtualization/os_level_virtualization/container-dev_container.txt)  
└── web  
├── web_browser  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [edge](prototypes/_lab/tech_stack/web/web_browser/edge.txt)  
└── web_server  
&nbsp;&nbsp;&nbsp;&nbsp;└── [nginx](prototypes/_lab/tech_stack/web/web_server/nginx.txt)

## ❓ Issues tracking

- conan 🔪 [\[package\] pulseaudio/14.2 : I'm using clang 18 but error; Compiler does not support -std=gnu11](https://github.com/conan-io/conan-center-index/issues/25075)

- [Cross-compiling Qt for a 32-bit Raspberry Pi does not work well](https://github.com/PhysicsX/QTonRaspberryPi/issues/21)

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
