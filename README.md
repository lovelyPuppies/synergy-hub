# Project Setup Instructions

📝 Note that

- This directory includes prototypes to compose new project.
- After the installation for basic settings, additional installation is required for each project.
- Its purpose is to compose project-specific isolated environment with cross-platform and cross-compiling in Windows 11.
  - But some may be different like executable extension, built-in shell commands, compiler, etc.
- the README.md written at 📅 2024-08-29 00:24:41

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

## Project Name Origin

Written at 📅 2024-12-14 10:39:25

**synergy-hub**

- **"Synergy"**: This project is not a single-purpose repository but a collection of diverse domains, such as notes, designs, and code. The term "synergy" represents the collaboration and integration between these elements to create greater value.
- **"Hub"**: It emphasizes the project's role as a central point where multiple projects and ideas converge, fostering growth and serving as a platform for further expansion.

The name reflects the project's vision of being more than just a repository — a foundation for creative collaboration and innovation.

## \_Doing

<details>
<summary>Click to expand</summary>

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

### Conan \(C++\) : Order of Tasks C++

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

</details>
