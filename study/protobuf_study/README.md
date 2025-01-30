```bash
clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

clang++ -o write_message write_message.cpp addressbook.pb.cc

clang++ -o write_message write_message.cpp addressbook.pb.cc \
  -L/home/linuxbrew/.linuxbrew/opt/protobuf/lib -I/home/linuxbrew/.linuxbrew/opt/protobuf/include \
  -L/home/linuxbrew/.linuxbrew/opt/absl/lib -I/home/linuxbrew/.linuxbrew/opt/absl/include


g++ -o write_message write_message.cpp addressbook.pb.cc -I/home/linuxbrew/.linuxbrew/opt/protobuf/include -L/home/linuxbrew/.linuxbrew/opt/protobuf/lib -lprotobuf



Protobuf 3.8 이후 버전은 Abseil (absl)을 내부적으로 사용합니다.
하지만 컴파일할 때 -labsl_log_internal_check_op 같은 Abseil 관련 라이브러리를 명시적으로 추가하지 않았기 때문에, undefined reference 에러가 발생한 것입니다.

/usr/bin/ld: /tmp/cc4CFPLm.o: undefined reference to symbol '_ZN4absl12lts_2024072212log_internal17MakeCheckOpStringIbbEEPNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEET_T0_PKc'
/usr/bin/ld: /home/linuxbrew/.linuxbrew/opt/abseil/lib/libabsl_log_internal_check_op.so.2407.0.0: error adding symbols: DSO missing from command line
collect2: error: ld returned 1 exit status

clang++ -o write_message write_message.cpp -I/home/linuxbrew/.linuxbrew/opt/protobuf/include


protoc -I=src --cpp_out=src src/addressbook.proto
```

g++ -o write_message write_message.cpp addressbook.pb.cc \
 (pkg-config --cflags --libs protobuf)

Simple Protocol Buffers program works when compiled with g++ but not clang++
https://stackoverflow.com/questions/21413852/simple-protocol-buffers-program-works-when-compiled-with-g-but-not-clang

```
protoc -I=test --cpp_out=test test/test.proto

g++ test.pb.cc main.cpp -lprotobuf -o g++.out


/usr/bin/ld: /tmp/cc2xuBOZ.o: undefined reference to symbol '_ZN4absl12lts_2024072212log_internal17MakeCheckOpStringIbbEEPNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEET_T0_PKc'
/usr/bin/ld: /home/linuxbrew/.linuxbrew/opt/abseil/lib/libabsl_log_internal_check_op.so.2407.0.0: error adding symbols: DSO missing from command line
collect2: error: ld returned 1 exit status

https://stackoverflow.com/questions/24096807/dso-missing-from-command-line
  DSO here means Dynamic Shared Object; since the error message says it's missing from the command line, I guess you have to add it to the command line.
  That is, try adding -lpthread to your command line.


https://github.com/protocolbuffers/protobuf/issues/15993
https://gitlab.com/kicad/code/kicad/-/issues/18080
  https://github.com/protocolbuffers/protobuf/issues/15604
  https://github.com/protocolbuffers/protobuf/issues/12637
```

```

protoc -I=test --cpp_out=test test/test.proto
cd test
clang++ test.pb.cc main.cpp -o test.out -I/home/linuxbrew/.linuxbrew/opt/protobuf/include
clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf)

>>
  undefined reference to `absl::lts_20240722::log_internal::LogMessageFatal::~LogMessageFatal()'
  undefined reference to `void google::protobuf::internal::InternalMetadata::DoMergeFrom<google::protobuf::UnknownFieldSet>(google::protobuf::UnknownFieldSet const&)'


clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf)
clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf)
clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf)

fish shell 문제엿나?;;
clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf)
https://github.com/fish-shell/fish-shell/issues/982

?? 됫네.?
eval clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf)
```
