🏷️ C++, ePoll, Multithreading, Protocol Buffers (Nano PB)

- Usage in Raspberry Pi 4

  ```
  #!/usr/bin/env fish
  sudo apt update
  sudo apt install -y software-properties-common python3-launchpadlib

  # https://stackoverflow.com/a/77075793
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  sudo apt update
  sudo apt install --only-upgrade libstdc++6

  gcc --version
  strings /lib/aarch64-linux-gnu/libstdc++.so.6 | grep GLIBCXX

  ```

- Initialize

  ```bash
  #!/usr/bin/env fish
  # Install libc++ packages for clang
  sudo apt update
  sudo apt install -y libc++-dev libc++abi-dev


  # Set environment
  poetry init
  poetry add conan
  conan new cmake_exe --define name=iot_server --define version=1.0 --output iot_server
  ```

- Build

  - Refer to 🧮 %VSCode> Run Task
