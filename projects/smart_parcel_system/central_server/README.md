# Smart Parcel system 🔪 Central Server

## [Socket IoT System](socket_iot_system)

🏷️ C++, boost, Asynchronous, Multithreading, Conan, CMake, Cross-compilation

- Initialize

  ```bash
  #!/usr/bin/env fish
  ## Install libc++ packages for clang
  sudo apt update
  sudo apt install -y crossbuild-essential-arm64 libc6-dev-arm64-cross \
    gcc-12-aarch64-linux-gnu g++-12-aarch64-linux-gnu \
    libc++-dev libc++abi-dev

  ## Set environment
  poetry install
  # poetry init
  # poetry add conan
  # conan new cmake_exe --define name=iot_server --define version=1.0 --output iot_server



  ### Mariadb C++ Connector
  # https://mariadb.com/downloads/connectors/connectors-data-access/cpp-connector
  ## If in Raspberry Pi
  # curl -L https://dlm.mariadb.com/3907413/Connectors/cpp/connector-cpp-1.1.5/mariadb-connector-cpp_1.1.5-1+maria~bookworm_arm64.deb -o mariadb-connector-cpp.deb
  # ☑️ mariadb-connector-cpp depends on libmariadb3, and libmariadb3 depends on mariadb-common
  sudo apt install -y mariadb-common libmariadb3

  set mariadb_connector_cpp_deb_path (mktemp --suffix=.deb)
  curl -L https://dlm.mariadb.com/3978240/Connectors/cpp/connector-cpp-1.1.5/mariadb-connector-cpp_1.1.5-1+maria~noble_amd64.deb -o $mariadb_connector_cpp_deb_path
  sudo dpkg --install $mariadb_connector_cpp_deb_path


  ```

- Configure environment

  - 🧮 %VSCode> Python: Select Interpreter

- Build

  - 🔗 Refer to 🧮 %VSCode> Run Task

- Debugging / Verification

  - Verify the required library versions for the binary file (💮 on the host environment or the target device)

    ```bash
    #!/usr/bin/env fish

    objdump --dynamic-syms ./iot_server | grep 'GLIBC_' | awk -F'[()]' '{print $2}' | sort -V | tail -1
    objdump --dynamic-syms ./iot_server | grep 'GLIBCXX_' | awk -F'[()]' '{print $2}' | sort -V | tail -1
    # or
    readelf --syms ./iot_server | grep -E '@GLIBC_' | awk -F'@' '{print $2}' | sed 's/ (.*)//g' | sort -V | tail -1
    readelf --syms ./iot_server | grep -E '@GLIBCXX_' | awk -F'@' '{print $2}' | sed 's/ (.*)//g' | sort -V | tail -1


    #   >> GLIBC_2.34
    #   >> GLIBCXX_3.4.21
    ```

  - Check the library versions supported by the target environment (💮 on the target device)

    ```bash
    #!/usr/bin/env fish
    echo "GLIBC: $(/lib/aarch64-linux-gnu/libc.so.6 | head -n 1)" && strings /usr/lib/aarch64-linux-gnu/libstdc++.so.6 | grep GLIBCXX | sort -V | tail -2 | head -1
    #   >> GLIBC: GNU C Library (Debian GLIBC 2.36-9+rpt2+deb12u9) stable release version 2.36.
    #   >> GLIBCXX_3.4.30
    ```

- doing 📰

  ```
  readelf -d ./test.out  | grep 'R.*PATH'
  ```

## [Interconnection Protocol](interconnection_protocol)

🏷️ tag: protobuf, nanopb

- Optimization (📰 TODO)

  - **[nanoPB]** Using Callback type instead of default

    🛍️ e.g. ListFilesResponse.file type:FT_CALLBACK, callback_datatype:"DIR\*"

  - **[protobuf]** compile with argument -ltcmalloc_minimal

- doing 📰
  ```
  gRPC 를 함께 사용하려 했으나 소켓통신에 사용하는 용도가 아님.
  proto 가 조건적으로
  ```

## TODO

- Cross compile: Protobuf, Boost
- Callback Implementation for nanoPB instead of fixed message size
