```bash
clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

clang++ -o write_message write_message.cpp addressbook.pb.cc

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf)
clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf | string split -n " ")

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf) \
    -Wl,-rpath,'$ORIGIN/lib:/home/linuxbrew/.linuxbrew/opt/protobuf/lib:/usr/local/lib:/usr/lib'


clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf)

protoc -I=. --cpp_out=. ./addressbook.proto

clang++ ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf| string split -n " ") -std=c++23 -fclang-abi-compat=17 \
    -static

clang++ ./addressbook.pb.cc ./read_message.cpp -o ./read_message.out \
    $(pkg-config --libs --cflags protobuf| string split -n " ") -std=c++23 -fclang-abi-compat=17 \
    -static


ls -lh test-shared.out
readelf -d test-shared.out | grep NEEDED | head -n 1
#   >> 0x0000000000000001 (NEEDED)             Shared library: [libprotobuf.so.29.3.0]
./test-shared.out


## 🧪📵 Using Shared library

PKG_CONFIG_PATH=/opt/protobuf-shared/lib/pkgconfig:$PKG_CONFIG_PATH \
          clang++ -v ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
          $(pkg-config --cflags --libs protobuf | string split -n " ") \
          -Wl,-rpath,/opt/protobuf-shared/lib

/usr/bin/ld: /tmp/addressbook-e26f32.o: in function `absl::lts_20240116::log_internal::LogMessage::operator<<(unsigned long)':
addressbook.pb.cc:(.text._ZN4absl12lts_2024011612log_internal10LogMessagelsEm[_ZN4absl12lts_2024011612log_internal10LogMessagelsEm]+0x19): undefined reference to `_ZN4absl12lts_2024011612log_internal10LogMessagelsImTnNSt9enable_ifIXntsr4absl16HasAbslStringifyIT_EE5valueEiE4typeELi0EEERS2_RKS5_'
clang++: error: linker command failed with exit code 1 (use -v to see invocation)


# https://github.com/protocolbuffers/protobuf/issues/12292#issuecomment-1921936350
```
