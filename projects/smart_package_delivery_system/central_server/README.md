# Smart Package Delivery system 🔪 Central Server

## [Socket IoT System](socket_iot_system)

🏷️ C++, Asynchronous, Multithreading, Smart pointer, Conan, CMake, Cross-compilation, boost

- **Design Pattern**
  - Concurrency patterns: (Thread pool, Proactor)

### Setup

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
- Callback Implementation (Optimization) for nanoPB instead of fixed message size for `repeated`, `string` fields.

<!--
Introduction in PPT
  저희는 비동기 멀티쓰레딩 서버를 사용했습니다.​
    비동기 방식에서는 클라이언트가 요청을 보낸 후, 처리가 완료될 때까지 쓰레드가 대기하지 않고 다른 작업을 수행할 수 있습니다. 이후 처리가 완료되면 커널이 이벤트를 발생시켜 적절한 쓰레드가 해당 작업을 이어서 처리합니다.​

    이를 통해 동시 요청을 보다 효과적으로 처리할 수 있어 높은 처리량을 제공하며, 불필요한 쓰레드 점유를 최소화해 리소스를 절약하면서도 빠른 응답 속도를 유지할 수 있습니다.​

    이러한 특징 덕분에 저희는 더 빠르고 안정적인 서비스 제공이 가능해졌습니다.​

  🔹 질문이 들어오면​
    일반적인 Blocking I/O 모델에서는 read() 같은 함수를 호출하면, 해당 쓰레드가 데이터를 받을 때까지 블로킹되어 대기합니다. 이 경우, 새로운 요청이 들어올 때마다 추가적인 쓰레드가 필요하게 되고, 동시 요청이 많아질수록 쓰레드가 계속 증가하면서 성능 저하와 리소스 낭비가 발생할 수 있습니다.​



10K 문제는 "동시 사용자 1만명(Concurrent 10K users)"이 접속하는 서버를 구현하는 문제입니다.
 -->
