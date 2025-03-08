## protobuf

📅 Written at 2025-02-01 14:50:56

```bash
#!/usr/bin/env fish
## Compile .proto
protoc -I=. --cpp_out=. ./test.proto


## 🧪🆗 Using Static library
clang++ ./test.pb.cc ./main.cpp -o ./test-static.out \
    $(pkg-config --cflags --libs protobuf | string split -n " ") \
    -static
ls -lh test-static.out
./test-static.out


## 🧪🆗 Using Shared library
PKG_CONFIG_PATH=/opt/protobuf-shared/lib/pkgconfig:$PKG_CONFIG_PATH \
    clang++ ./test.pb.cc ./main.cpp -o ./test-shared.out \
    $(pkg-config --cflags --libs protobuf | string split -n " ") \
    -Wl,-rpath,/opt/protobuf-shared/lib
ls -lh test-shared.out
readelf -d test-shared.out | grep NEEDED | head -n 1
#   >> 0x0000000000000001 (NEEDED)             Shared library: [libprotobuf.so.29.3.0]
./test-shared.out

```

## nanoPB

📰 Doing

```bash
#!/usr/bin/env fish

set test_dir $HOME/Downloads/nanopb
python3 $test_dir/generator/nanopb_generator.py message.proto


pip3 install protobuf grpcio-tools

❯ python generator/nanopb_generator.py $test_dir/message.proto

         **********************************************************************
         *** Could not import the Google protobuf Python libraries          ***
         ***                                                                ***
         *** Easiest solution is often to install the dependencies via pip: ***
         ***    pip install protobuf grpcio-tools                           ***
         **********************************************************************
https://github.com/nanopb/nanopb/tree/master/examples
```
