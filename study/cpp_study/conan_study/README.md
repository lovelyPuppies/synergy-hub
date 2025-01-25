# Project Setup Instructions

📰 DOING and Legacy ... because development platform is changed. 📅 2024-08-27 01:23:01

- [Project Setup Instructions](#project-setup-instructions)
  - [One-time Installation](#one-time-installation)
    - [System and Package Installation](#system-and-package-installation)
    - [C++ Package manger: Conan 2](#c-package-manger-conan-2)
  - [.vscode/c\_cpp\_properties.json in Ubuntu](#vscodec_cpp_propertiesjson-in-ubuntu)

## One-time Installation

### System and Package Installation

1. Install essential packages:

```bash
# shell command
sudo apt install -y build-essential autoconf automake libtool \
   libva-dev pkg-config libvdpau-dev libxcb-util-dev libxcb-util0-dev \
   libx11-dev libx11-xcb-dev libfontenc-dev libice-dev libsm-dev libxau-dev libxaw7-dev \
   libxcomposite-dev libxcursor-dev libxdamage-dev libxext-dev libxfixes-dev libxi-dev \
   libxinerama-dev libxkbfile-dev libxmu-dev libxmuu-dev libxpm-dev libxrandr-dev \
   libxrender-dev libxres-dev libxss-dev libxt-dev libxtst-dev libxv-dev libxxf86vm-dev \
   libxcb-glx0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-xkb-dev \
   libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-randr0-dev \
   libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-xinerama0-dev \
   libxcb-dri3-dev uuid-dev libxcb-cursor-dev libxcb-dri2-0-dev libxcb-present-dev \
   libxcb-composite0-dev libxcb-ewmh-dev libxcb-res0-dev

   set -Ux PYENV_PYTHON_PATH (pyenv which python) # for use in VSCode
   set -Ux POETRY_ENV_INFO_PATH (poetry env info --executable) # for use in VSCode

   # shell command
   pyenv install --list | grep 3.12

   sudo apt install -y build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev \
      libreadline-dev libsqlite3-dev liblzma-dev libncurses-dev tk-dev
   pyenv install 3.12

   # set default python version
   pyenv global 3.12

   sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 60
   sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 60
```

### C++ Package manger: Conan 2

1. Detect Conan profiles:

   ```bash
   # shell command
   conan profile detect --force
   ```

2. Add your package to Conan in editable mode and check this:
   ```bash
   # shell command
   conan editable add <my_package_name>
   conan editable list
   ```

## .vscode/c_cpp_properties.json in Ubuntu

```json
// .vscode/c_cpp_properties.json
{
  "configurations": [
    {
      "name": "Linux",
      "compilerArgs": ["-m32"],
      "intelliSenseMode": "linux-gcc-x86",
      "includePath": [
        "/usr/include/c++/13",
        "/usr/include/x86_64-linux-gnu",
        "/usr/lib/gcc/x86_64-linux-gnu/13/include",
        "/usr/local/include",
        "${workspaceFolder}/src",
        "${workspaceFolder}/include"
      ],
      "defines": ["${myDefines}"],
      "cStandard": "c23",
      "cppStandard": "c++23",
      "configurationProvider": "ms-vscode.cmake-tools",
      "mergeConfigurations": true,
      "customConfigurationVariables": {
        "myVar": "myvalue"
      },
      "browse": {
        "path": [
          "/usr/include/c++/13",
          "/usr/include/x86_64-linux-gnu",
          "/usr/lib/gcc/x86_64-linux-gnu/13/include",
          "/usr/local/include",
          "${workspaceFolder}/src",
          "${workspaceFolder}/include",
          "${workspaceFolder}/resource/"
        ],
        "limitSymbolsToIncludedHeaders": true
      },
      "compileCommands": "${workspaceFolder}/build/Debug/compile_commands.json"
    }
  ],
  "version": 4
}
```
