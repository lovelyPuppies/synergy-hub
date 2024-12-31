# Synergy Hub Documentation

- [Synergy Hub Documentation](#synergy-hub-documentation)
  - [🗂 Directory Structure](#-directory-structure)
  - [📌 Project Shortcuts](#-project-shortcuts)
  - [🔧 Tech Stack](#-tech-stack)
  - [🚀 Project Setup Instructions (Ubuntu)](#-project-setup-instructions-ubuntu)

## 🗂 Directory Structure

```
📁 projects (📰 TODO)
└── 📂 embedded
├── 📁 project_alarm_clock
└── 📁 smart_trash_bin
```

## 📌 Project Shortcuts

- [**Raspberry Pi 4 B 기반 커널 모듈 및 디바이스 드라이버 구현 (LED 제어)**](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer)
- [**Jetson Nano와 Edge AI를 활용한 실시간 수신호 인식 자율주행 RC카 개발 프로젝트**](https://github.com/opmaksim/Signal-Project) (External Link)
- **STM32 Nucleo F411RE 기반 디지털 시계 및 알람 시스템 구현**: TODO
- [**Python 및 MediaPipe 기반 카메라 필터 애플리케이션 개발**](prototypes/study/python_study/camera_filter_app)
- [**환경 및 네트워크 초기화 자동화 스크립트 작성**](prototypes/_initialization)
- **ATmega128 기반 스마트 선풍기 제어 시스템 개발**: TODO
- [**IoT의 안전한 운영을 위한 Docker 기반 시스템 환경 설 계 및 구현**](https://github.com/wbfw109/safe_iot_architecture) \(External Link\)
- [**Python 및 IPython 기반 CS 지식 연구 결과를 웹에 시각화하기 위한 라이브러리 개발**](https://github.com/wbfw109/study-core?tab=readme-ov-file#31-python-utilities) \(External Link\)
- [**Pynecone를 활용한 CS 용어 사전 웹 애플리케이션 개발**](https://github.com/wbfw109/study-core?tab=readme-ov-file#41-glossary-service) \(External Link\)

## 🔧 Tech Stack

tree [**prototypes/\_lab/tech_stack**](prototypes/_lab/tech_stack)  
├── build_tool  
│&nbsp;&nbsp;&nbsp;&nbsp;├── build_system  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── meta_build_system  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── yocto_project  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [bitbake.txt](prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/bitbake.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [yocto.txt](prototypes/_lab/tech_stack/build_tool/build_system/meta_build_system/yocto_project/yocto.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [ninja.txt](prototypes/_lab/tech_stack/build_tool/build_system/ninja.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── build_system_generator  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [cmake.txt](prototypes/_lab/tech_stack/build_tool/build_system_generator/cmake.txt)  
├── code_quality_tool  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [ruff.txt](prototypes/_lab/tech_stack/code_quality_tool/ruff.txt)  
├── design_pattern_and_uml  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [d2.txt](prototypes/_lab/tech_stack/design_pattern_and_uml/d2.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [design_pattern.txt](prototypes/_lab/tech_stack/design_pattern_and_uml/design_pattern.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [mermaid_example.md](prototypes/_lab/tech_stack/design_pattern_and_uml/mermaid_example.md)  
├── editor  
│&nbsp;&nbsp;&nbsp;&nbsp;├── gui_based-ide  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [microchip_studio.txt](prototypes/_lab/tech_stack/editor/gui_based-ide/microchip_studio.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── [visual_studio.txt](prototypes/_lab/tech_stack/editor/gui_based-ide/visual_studio.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [vs_code.txt](prototypes/_lab/tech_stack/editor/gui_based-ide/vs_code.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── terminal_based  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [helix.txt](prototypes/_lab/tech_stack/editor/terminal_based/helix.txt)  
├── [fonts.txt](prototypes/_lab/tech_stack/fonts.txt)  
├── hardware_and_os  
│&nbsp;&nbsp;&nbsp;&nbsp;├── arm  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [arm_compiler.txt](prototypes/_lab/tech_stack/hardware_and_os/arm/arm_compiler.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── hardware  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [nvidia.txt](prototypes/_lab/tech_stack/hardware_and_os/hardware/nvidia.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [Issues.md](prototypes/_lab/tech_stack/hardware_and_os/Issues.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── os  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;├── linux  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── [ubuntu.txt](prototypes/_lab/tech_stack/hardware_and_os/os/linux/ubuntu.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;└── **[linux.txt](prototypes/_lab/tech_stack/hardware_and_os/os/linux.txt)**  
│&nbsp;&nbsp;&nbsp;&nbsp;└── serial_tools  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [tio.txt](prototypes/_lab/tech_stack/hardware_and_os/serial_tools/tio.txt)  
├── libraries  
│&nbsp;&nbsp;&nbsp;&nbsp;└── cpp  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [google_test.txt](prototypes/_lab/tech_stack/libraries/cpp/google_test.txt)  
├── llvm_stack  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [clang.txt](prototypes/_lab/tech_stack/llvm_stack/clang.txt)  
├── mathmatics  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [mathmatics_symbols.txt](prototypes/_lab/tech_stack/mathmatics/mathmatics_symbols.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── ml  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── [ml-glossary.md](prototypes/_lab/tech_stack/mathmatics/ml/ml-glossary.md)  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [openmmlab.txt](prototypes/_lab/tech_stack/mathmatics/ml/openmmlab.txt)  
├── monitoring_tools  
│&nbsp;&nbsp;&nbsp;&nbsp;└── file_system_monitoring  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [watchman.txt](prototypes/_lab/tech_stack/monitoring_tools/file_system_monitoring/watchman.txt)  
├── package_manager  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [env-nix.txt](prototypes/_lab/tech_stack/package_manager/env-nix.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [env-volta.txt](prototypes/_lab/tech_stack/package_manager/env-volta.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-cargo.txt](prototypes/_lab/tech_stack/package_manager/lang-cargo.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-conan.txt](prototypes/_lab/tech_stack/package_manager/lang-conan.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-pipx.txt](prototypes/_lab/tech_stack/package_manager/lang-pipx.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [lang-poetry.txt](prototypes/_lab/tech_stack/package_manager/lang-poetry.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-choco.txt](prototypes/_lab/tech_stack/package_manager/sys-choco.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-homebrew.txt](prototypes/_lab/tech_stack/package_manager/sys-homebrew.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pacman.txt](prototypes/_lab/tech_stack/package_manager/sys-pacman.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [sys-pixi.txt](prototypes/_lab/tech_stack/package_manager/sys-pixi.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [sys-scoop.txt](prototypes/_lab/tech_stack/package_manager/sys-scoop.txt)  
├── programming_languages  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [c+cpp.txt](prototypes/_lab/tech_stack/programming_languages/c+cpp.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [java.txt](prototypes/_lab/tech_stack/programming_languages/java.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [python.txt](prototypes/_lab/tech_stack/programming_languages/python.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [rust.txt](prototypes/_lab/tech_stack/programming_languages/rust.txt)  
├── remote_access_tools  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [tailscale.txt](prototypes/_lab/tech_stack/remote_access_tools/tailscale.txt)  
├── scm  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [git.txt](prototypes/_lab/tech_stack/scm/git.txt)  
├── shell  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [fish.txt](prototypes/_lab/tech_stack/shell/fish.txt)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [powershell.txt](prototypes/_lab/tech_stack/shell/powershell.txt)  
├── virtualization  
│&nbsp;&nbsp;&nbsp;&nbsp;└── os_level_virtualization  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [container-dev_container.txt](prototypes/_lab/tech_stack/virtualization/os_level_virtualization/container-dev_container.txt)  
└── web  
 ├── web_browser  
 │&nbsp;&nbsp;&nbsp;&nbsp;└── [edge.txt](prototypes/_lab/tech_stack/web/web_browser/edge.txt)  
 └── web_server  
 └── [nginx.txt](prototypes/_lab/tech_stack/web/web_server/nginx.txt)

## 🚀 Project Setup Instructions (Ubuntu)

1. Common Configurations:

   - 🎱 Copy **[settings.json](prototypes/_initialization/.vscode/_user-settings.jsonc)** to your user settings.
   - 🎱 Copy **[keybindings.json](prototypes/_initialization/.vscode/_user-keybindings.jsonc)** to your user keybindings.
   - 🎱 Copy **[extensions.json](prototypes/_initialization/.vscode/extensions.json)** to the mono-repository for VS Code recommendations.
   - 🎱 Copy **[tasks.json](prototypes/_initialization/.vscode/tasks.jsonc)** for common task settings.

2. Run **[initialization script](prototypes/_initialization/ubuntu/init_in_bash.sh)**:

   ```bash
   #!/bin/bash
   bash prototypes/_initialization/ubuntu/init_in_bash.sh
   ```

3. **[Use semi-automatic script snippets for user-interactive tasks](prototypes/_initialization/ubuntu/init_in_fish_semi_automatic.fish)**

   ➡️ Refer to `prototypes/_initialization/ubuntu/init_in_fish_semi_automatic.fish`

   > This file contains script snippets for user-interactive tasks.  
   > Please **read the script carefully** and install only the necessary packages.

4. Update and upgrade your system periodically:

   ```bash
   #!/bin/bash
   brew update && brew upgrade
   sudo apt update && sudo apt upgrade -y
   sudo snap refresh
   flatpak update
   ```
