🏷️ C++, ePoll, Multithreading, Protocol Buffers (Nano PB)

- Initialize

  ```bash
  #!/usr/bin/env fish
  # Install libc++ packages for clang
  sudo apt update
  sudo apt install -y crossbuild-essential-arm64 libc6-dev-arm64-cross \
    gcc-12-aarch64-linux-gnu g++-12-aarch64-linux-gnu \
    libc++-dev libc++abi-dev

  # Set environment
  poetry init
  poetry add conan
  conan new cmake_exe --define name=iot_server --define version=1.0 --output iot_server
  ```

- Build

  - Refer to 🧮 %VSCode> Run Task

- Debugging / Verification

  - Verify the required library versions for the binary file (💮 on the host environment or the target device)

    ```bash
    #!/usr/bin/env fish

    objdump --dynamic-syms ./iot_server | grep 'GLIBC_' | awk -F'[()]' '{print $2}' | sed 's/ (.*)//g' | sort -V | tail -1
    objdump --dynamic-syms ./iot_server | grep 'GLIBCXX_' | awk -F'[()]' '{print $2}' | sed 's/ (.*)//g' | sort -V | tail -1
    # or
    readelf --syms ./iot_server | grep -E '@GLIBC_' | awk -F'@' '{print $2}' | sed 's/ (.*)//g' | sort -V | tail -1
    readelf --syms ./iot_server | grep -E '@GLIBCXX_' | awk -F'@' '{print $2}' | sed 's/ (.*)//g' | sort -V | tail -1


    #   >> GLIBC_2.34
    #   >> GLIBCXX_3.4.21
    ```

  - Check the library versions supported by the target environment (💮 on the target device)

    ```
    #!/usr/bin/env fish
    echo "GLIBC: $(/lib/aarch64-linux-gnu/libc.so.6 | head -n 1)" && strings /usr/lib/aarch64-linux-gnu/libstdc++.so.6 | grep GLIBCXX | sort -V | tail -2 | head -1
    # >> GLIBC: GNU C Library (Debian GLIBC 2.36-9+rpt2+deb12u9) stable release version 2.36.
    # >> GLIBCXX_3.4.30
    ```
