```bash
clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

clang++ -o write_message write_message.cpp addressbook.pb.cc

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf)
clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf | string split -n " ")

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf) \
    -Wl,-rpath,'$ORIGIN/lib:/home/linuxbrew/.linuxbrew/opt/protobuf/lib:/usr/local/lib:/usr/lib'


clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf)
```
