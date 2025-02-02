```bash
# clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

protoc -I=. --cpp_out=. ./addressbook.proto

clang++ ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf| string split -n " ") -std=c++23 -fclang-abi-compat=17 \
    -static

clang++ ./addressbook.pb.cc ./read_message.cpp -o ./read_message.out \
    $(pkg-config --libs --cflags protobuf| string split -n " ") -std=c++23 -fclang-abi-compat=17 \
    -static


./write_message.out
./read_message.out


```
