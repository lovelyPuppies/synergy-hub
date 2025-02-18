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

## Retrospective

### 1. 인증 체계의 보완 필요성

- 🚩 **기존 문제점**
  현재 내가 username, 암호화된 password로 auth message 를 보내서 인증을 해서 내가 서버에 등록된 이 정보에 따라 nodetype, src id 를 DB에 있는대로 클라이언트 세션에 할당하여 관리한다는거지? 


  현재 IoT 서버는 클라이언트가 접속할 때 **NodeType**과 **NodeType별 ID**를 기반으로만 인증을 수행하고 있다. 그러나 이 방식은 다음과 같은 보안적 한계가 존재한다:

  - **NodeType/ID의 추측 가능성:** 공격자가 예상 가능한 NodeType 및 ID 패턴으로 무차별 대입(Brute Force Attack)을 시도할 수 있음.
  - **동일 NodeType/ID 중복 문제:** 동일한 NodeType과 ID를 가진 다른 기기가 접속할 가능성.
  - **기기 식별 불가:** 클라이언트 기기가 물리적으로 변경되더라도 서버는 이를 인지하지 못함.
  
  ➡️ 실무 사례 조사를 바탕으로 소켓 통신에 대한 보안 적용 필요.

---


<!--
Introduction in PPT 📅 2025-02-10 19:01:44
  * Server 🔪 Asynchronous Multithreading
    안녕하십니까? 서버-노드 간 언어별 API 작성 및 구현을 맡은 박준수 입니다.​

    서버는 비동기 멀티쓰레딩 방식으로 구현되었습니다.​
    이 시스템은 아파트 단지 내 다수의 택배 보관함, 사용자, 배달 로봇, 엘리베이터 등이 하나의 서버를 통해 서로 연동되는 환경을 가정하고 개발되었습니다. ​
    따라서 수백 개의 노드가 동시에 연결되고 데이터를 주고받는 상황에서도 일정한 속도와 안정성을 유지해야 합니다.​
    이를 위해 Boost.Asio 라이브러리를 활용하여 동시 요청을 효과적으로 처리하고, 리소스를 최적화할 수 있도록 구현했습니다.​

    ​
    ❓ [Q&A]​
      🔹 Blocking I/O 모델과의 현재 모델과의 차이
        일반적인 Blocking I/O 모델에서는 read() 같은 함수를 호출하면, 해당 쓰레드가 데이터를 받을 때까지 블로킹되어 대기합니다. 이 경우, 새로운 요청이 들어올 때마다 추가적인 쓰레드가 필요하게 되고, 동시 요청이 많아질수록 쓰레드가 계속 증가하면서 성능 저하와 리소스 낭비가 발생할 수 있습니다. ​

        비동기 방식에서는 클라이언트가 요청을 보낸 후, 처리가 완료될 때까지 쓰레드가 대기하지 않고 다른 작업을 수행할 수 있습니다. 이후 처리가 완료되면 커널이 이벤트를 발생시켜 적절한 쓰레드가 해당 작업을 이어서 처리합니다.​

        이를 통해 동시 요청을 보다 효과적으로 처리할 수 있어 높은 처리량을 제공하며, 불필요한 쓰레드 점유를 최소화해 리소스를 절약하면서도 빠른 응답 속도를 유지할 수 있습니다.​

  * Server 🔪 Protocol Buffers, NanoPB
    네, 다음은 서버의 통신 방식에 대한 내용입니다."
    저희 서버는 Protocol Buffer 또는 NanoPB를 사용하여 노드와 통신합니다.

    저희 시스템에서는 각 노드가 서로 다른 프로그래밍 언어(C, C++, Python 등)를 사용하여 소켓 통신을 합니다.
    또한, 각 노드마다 요구하는 메시지 사양이 달랐기 때문에, 구조화된 데이터를 동일한 API를 통해 일관되게 통신하는 것이 중요했습니다.

    이를 해결하기 위해 Protocol Buffer를 도입했습니다.
    Protocol Buffer는 데이터를 이진 형식으로 직렬화(객체를 네트워크 전송이 가능한 상태로 변환)하며,
    각 노드가 미리 정의된 스키마 구조를 공유하기 때문에 전송 크기를 줄이고, 네트워크 대역폭을 절약할 수 있는 장점이 있습니다.

      ❓ [Q&A]
        🔹 왜 단순한 구분자 기반 텍스트 포맷이나 JSON 대신 Protocol Buffer를 사용했나요?
          일반적으로 텍스트 기반 데이터 포맷(JSON, CSV 등)은 크기가 크고, 파싱 속도가 느립니다.
          반면, Protocol Buffer는 데이터를 이진 형식으로 변환하여 크기를 줄이고, 파싱 속도를 크게 향상시킬 수 있습니다.
          또한, 텍스트 기반 포맷에서는 구분자를 임의로 설정해야 하고, 필드 구조를 변경하기 어렵지만, Protocol Buffer는 정형화된 스키마를 기반으로 안정적인 데이터 전송이 가능합니다.

        🔹 NanoPB는 어떤 용도로 사용되었나요?
          일반적인 Protocol Buffer는 데이터를 직렬화할 때 동적 메모리 할당합니다.
          그러나, 이는 자원이 제한된 임베디드 환경에서는 동적 메모리 할당이 문제가 될 수 있습니다.

          예를 들어, 현재 저희 시스템의 엘레베이터 노드에서 사용하는 MCU: ESP32는 SRAM이 520KB로 제한되어 있으며, 시스템이 사용할 메모리를 제외하면 실제로 사용할 수 있는 공간은 더 작습니다.
          이러한 제한된 환경에서는 동적 할당이 메모리 파편화와 성능 저하를 유발할 수 있기 때문에, 보다 가벼운 데이터 직렬화 방식이 필요합니다.

          이를 해결하기 위해 NanoPB를 사용했습니다.

          NanoPB는 경량화된 Protocol Buffer 구현체로, 동적 메모리 할당 없이 정적 메모리 기반으로 동작할 수 있도록 최적화되어 있습니다.
          이를 통해, ESP32와 같은 메모리 제약이 있는 임베디드 장치에서도 안정적으로 사용할 수 있습니다.


10K 문제는 "동시 사용자 1만명(Concurrent 10K users)"이 접속하는 서버를 구현하는 문제입니다.
 -->
