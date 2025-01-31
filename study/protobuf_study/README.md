```bash
clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

clang++ -o write_message write_message.cpp addressbook.pb.cc

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf)
clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf | string split -n " ")

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf) \
    -Wl,-rpath,'$ORIGIN/lib:/home/linuxbrew/.linuxbrew/opt/protobuf/lib:/usr/local/lib:/usr/lib'



wbfw109v2@iot-04:~/repos/synergy-hub/study/protobuf_study/test$ readelf -d test.out | grep NEEDED
 0x0000000000000001 (NEEDED)             Shared library: [libprotobuf.so.29.3.0]



clang++ test.pb.cc main.cpp -o test.out \
    $(pkg-config --cflags --libs protobuf) \
    -Wl,-rpath,/home/linuxbrew/.linuxbrew/lib





protoc -I=. --cpp_out=. ./test.proto

clang++ ./test.pb.cc ./main.cpp -o ./test.out \
    (pkg-config --cflags --libs protobuf | string split -n " ") \
    -static
ls -lh test.out
./test.out


set -p PKG_CONFIG_PATH /opt/protobuf-shared/lib/pkgconfig
clang++ ./test.pb.cc ./main.cpp -o ./test.out \
    $(pkg-config --cflags --libs protobuf) \
    -Wl,-rpath,/opt/protobuf-shared/lib
ls -lh test.out

```

clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf)
