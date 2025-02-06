```bash
# clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

protoc -I=. --cpp_out=. ./addressbook.proto

# 🔗 protobuf.txt 🔪 🚨 (Issue: Error); Errors caused by ABI compatibility changes starting from LLVM 18
clang++-17 ./addressbook.pb.cc ./read_message.cpp -o ./read_message.out \
    $(pkg-config --libs --cflags protobuf) -fuse-ld=lld

clang++-17 ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -fuse-ld=lld

./write_message.out addressbook.log
./read_message.out addressbook.log

hexyl addressbook.log
```
