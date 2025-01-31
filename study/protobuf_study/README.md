```bash
clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

clang++ -o write_message write_message.cpp addressbook.pb.cc

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf)
clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf | string split -n " ")

clang++ test.pb.cc main.cpp -o test.out $(pkg-config --cflags --libs protobuf) \
    -Wl,-rpath,'$ORIGIN/lib:/home/linuxbrew/.linuxbrew/opt/protobuf/lib:/usr/local/lib:/usr/lib'

wbfw109v2@iot-04:~/repos/synergy-hub/study/protobuf_study/test$ ldd ./test.out
        linux-vdso.so.1 (0x0000750814822000)
        libprotobuf.so.29.3.0 => /home/linuxbrew/.linuxbrew/Cellar/protobuf/29.3/lib/libprotobuf.so.29.3.0 (0x0000750814400000)
        libabsl_log_internal_check_op.so.2407.0.0 => not found
        libabsl_leak_check.so.2407.0.0 => not found
        libabsl_die_if_null.so.2407.0.0 => not found
        libabsl_log_internal_conditions.so.2407.0.0 => not found
        libabsl_log_internal_message.so.2407.0.0 => not found
        libabsl_examine_stack.so.2407.0.0 => not found
        libabsl_log_internal_format.so.2407.0.0 => not found
        libabsl_log_internal_proto.so.2407.0.0 => not found
        libabsl_log_internal_nullguard.so.2407.0.0 => not found
        libabsl_log_internal_log_sink_set.so.2407.0.0 => not found


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


❯ fd "libprotobuf" /home/linuxbrew/.linuxbrew/opt/protobuf
    /home/linuxbrew/.linuxbrew/opt/protobuf/lib/libprotobuf-lite.so
    /home/linuxbrew/.linuxbrew/opt/protobuf/lib/libprotobuf-lite.so.29.3.0
    /home/linuxbrew/.linuxbrew/opt/protobuf/lib/libprotobuf.so
    /home/linuxbrew/.linuxbrew/opt/protobuf/lib/libprotobuf.so.29.3.0

❯ fd "libprotobuf" /home/linuxbrew/.linuxbrew/lib
    /home/linuxbrew/.linuxbrew/lib/libprotobuf-lite.so
    /home/linuxbrew/.linuxbrew/lib/libprotobuf-lite.so.29.3.0
    /home/linuxbrew/.linuxbrew/lib/libprotobuf.so
    /home/linuxbrew/.linuxbrew/lib/libprotobuf.so.29.3.0
```

clang++ test.pb.cc main.cpp -o test.out (pkg-config --cflags --libs protobuf)
