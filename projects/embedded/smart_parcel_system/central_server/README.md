🏷️ C++, ePoll, Multithreading, Protocol Buffers (Nano PB)

- Initialize

  ```bash
  #!/usr/bin/env fish
  poetry init
  poetry add conan
  conan new cmake_exe --define name=iot_server --define version=1.0 --output iot_server
  ```

- Build

  ```bash
  #!/usr/bin/env fish
  cd iot_server
  conan install . --build=missing --profile:all profiles/linux-debug

  # `chmod` only be required in Fish shell. not Bash shell.
  chmod +x build/Release/generators/conanbuild.sh
  replay build/Release/generators/conanbuild.sh

  # cmake ../.. -DCMAKE_TOOLCHAIN_FILE=generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release

  cmake --preset conan-debug
  cmake --build --preset conan-debug


  ```
