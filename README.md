# Project Setup Instructions

📝 Note that

- This directory includes prototypes to compose new project.
- After the installation for basic settings, additional installation is required for each project.
- Its purpose is to compose project-specific isolated environment with cross-platform and cross-compiling in Windows 11.
  - But some may be different like executable extension, built-in shell commands, compiler, etc.
- the README.md written at 📅 2024-08-29 00:24:41

## Table of contents

- [Project Setup Instructions](#project-setup-instructions)
  - [Table of contents](#table-of-contents)
    - [Update commands](#update-commands)
    - [1. VSCode Extension Installation](#1-vscode-extension-installation)
    - [2. Other settings](#2-other-settings)
    - [4. \[Optional\] Device settings](#4-optional-device-settings)
      - [USB camera](#usb-camera)
  - [Order of Tasks for using C++](#order-of-tasks-for-using-c)
  - [Changelog](#changelog)
  - [legacy](#legacy)
    - [Packages Managed by "pixi" command](#packages-managed-by-pixi-command)
  - [Project Name Origin](#project-name-origin)
  - [📰 Doing](#-doing)
    - [latex Workshop ; https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop](#latex-workshop--httpsmarketplacevisualstudiocomitemsitemnamejames-yulatex-workshop)
    - [VS code and github cli](#vs-code-and-github-cli)


### Update commands
🪠 (fish shell)
```bash
#!/usr/bin/env fish

sudo apt update && sudo apt upgrade -y

brew update && brew upgrade
```

### 1. VSCode Extension Installation

- %VSCode> Preferences: Open User Settings (JSON)
  User settings

- .vscode/settings.json
  Project-specific settings

- .vscode/extensions.json
  Install recommended extension of VScode

- .vscode/c_cpp_properties.json
  Set C/C++ Intellisesne

- .vscode/tasks.json
---

### 2. Other settings

Other settings is already written to integrate with VSCode.: **Intellisense**, **Toolchain**, clang-format
- CMakeLists.txt
- conanfile.py


---

### 4. \[Optional\] Device settings

If you want to use USB device specifically Camera, you must set following options.

#### USB camera

If your OS is **Windows 11**

1. First, check connected USB Camera Device is in Device Manager - Camera

2. Windows Settings
   - Privacy & security
     - Camera
       - ☑️ Camera access
       - ☑️ Let apps access your camera
         - ☑️ Let desktop apps access your camera

   - FAQ
     - ❓ When using multiple cameras, there were cases where opencv-python did not recognize two cameras on the same port hub.
        > cv2.VideoCapture(index).isOpend() is True, but frame returned by read() is False.

---

## Order of Tasks for using C++

1. Configure my cpp sources

   ```cmake
   # 🛍️ e.g. CMake configuration for cpp_study target
   # ➡️ whenever structure of directory is changed, use this.
   add_executable(cpp_study
       src/cpp_study.cpp
       src/main.cpp
       <new cpp source1>
       <new cpp source2> # ...
   )
   ```

2. Install dependencies and set the build type to Debug:

   ```bash
   # shell command
   # ➡️ whenever conanfile.py is changed, use this.
   conan install . -s build_type=Debug --build=missing
   ```

3. CMake Configure Preset; configure preset:

   ```bash
   # shell command
   # ➡️ whenever CMakeLists is changed, use this.
   cmake --preset conan-debug
   ```

4. CMake Build; build project:

   ```bash
   # shell command
   # ➡️ whenever (source | include) file is changed, use this.
   cmake --build --preset conan-debug
   ```

5. Run the created executable:

   ```bash
   # shell command
   ./build/Debug/cpp_study
   ```

## Changelog

- 📅 2024-08-26 21:50:50
  - The settings environment is changed from WSL Ubuntu settings to Windows 11 because WSL2 Ubuntu not supports well USB camera drivers.
     > I have tried building with a custom kernel and followed all the steps for [USB device sharing](https://learn.microsoft.com/en-us/windows/wsl/connect-usb) as recommended by Microsoft. However, I still could not access video devices from OpenCV in WSL2 (/dev/video* are None).
- 📅 2024-08-29 00:19:46
  - I decided to re-use WSL2 Ubuntu in home, and use Ubuntu OS (not WSL) in outside.
  - Many C++ tools and libraries seem to be tailored to the unix-lke operating system.
    - Even tools that are known to work on Windows, when applied with custom options, result in many build errors for the libraries, and the work to resolve them is also limited and cumbersome.
    - If you want to use USB Device Camera in Opencv in local, work it outside such as at company.

## legacy

### Packages Managed by "pixi" command

   ~~Package Manager for Cross-platform~~ | ~~pixi~~   | ~~**Latest Stable;** >= 0.28.1~~                 | ~~[Install pixi](https://pixi.sh/)~~                                                                                  |

- pixi is a very new tool, and if I only going to use Unix-like OS, I probably better off using another tool.

   🗝️ This tool is used to install and manage packages for project-specific isolated environment configurations.
   ⚠️ Do Not install these as global package

   There are common packages that you may need to install for development on certain systems.

   | Type                              | Name   | Version                     | Reference                                          |
   | --------------------------------- | ------ | --------------------------- | -------------------------------------------------- |
   | Package Manager for C++           | conan  | **Latest Stable;** >= 2.6.0 | [Install Conan 2](https://pypi.org/project/conan/) |
   | Python interpreter                | python | **\<Custom Version\>**      |                                                    |
   | Tools for install python packages | pip    | **Latest Stable;** >= 2.6.0 | [Install pip](https://pypi.org/project/conan/)     |

- pip is only used when [Python Interactive window](https://code.visualstudio.com/docs/python/jupyter-support-py) with [Jupyter extension](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter) in VS code for development. not for Release

   🪠 Refer to each project prototypes for package details ➡️

   ---




## Project Name Origin

Written at 📅 2024-12-14 10:39:25

**synergy-hub**  
- **"Synergy"**: This project is not a single-purpose repository but a collection of diverse domains, such as notes, designs, and code. The term "synergy" represents the collaboration and integration between these elements to create greater value.  
- **"Hub"**: It emphasizes the project's role as a central point where multiple projects and ideas converge, fostering growth and serving as a platform for further expansion.

The name reflects the project's vision of being more than just a repository — a foundation for creative collaboration and innovation.



## 📰 Doing


### latex Workshop ; https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop
```bash
# shell command
sudo apt install -y texlive-full 
```

### VS code and github cli

```bash
#!/bin/bash
gh auth login
```
📰🚨 Issue tracking
  - https://github.com/conan-io/conan/issues/16905
  - https://github.com/conan-io/conan-center-index/issues/25075


Missing Python Development Headers when install and build python libraries in pyenv ?
```bash
sudo apt-get install python3-dev
# https://rustup.rs/ when install datumaro from otx[full]
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
