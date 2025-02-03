```bash
# clang++ -o hello write_message.cpp addressbook.pb.cc -ltcmalloc_minimal

protoc -I=. --cpp_out=. ./addressbook.proto

clang++ ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -fclang-abi-compat=17 \
    -static

clang++ ./addressbook.pb.cc ./read_message.cpp -o ./read_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -fclang-abi-compat=17 \
    -static


clang++ ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -fclang-abi-compat=17



🧮 clang-18

clang++-17 ./addressbook.pb.cc ./read_message.cpp -o ./read_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -fuse-ld=lld

clang++-17 ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -fuse-ld=lld



🧪🆗 g++-12, g++-14
g++-14 -flto=auto -pipe ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -lstdc++

g++-14 -flto=auto -pipe ./addressbook.pb.cc ./read_message.cpp -o ./read_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -lstdc++

./read_message.out addressbook.log

🧪
clang++ ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -lstdc++
clang++ ./addressbook.pb.cc ./read_message.cpp -o ./read_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -lstdc++

clang++ ./addressbook.pb.cc ./write_message.cpp -o ./write_message.out \
    $(pkg-config --libs --cflags protobuf | string split -n " ") -fclang-abi-compat=17


./read_message.out addressbook.log



./write_message.out addressbook.log

 hexdump -C addressbook.log | head

00000000  0a 2b 0a 05 6e 61 6d 65  31 10 01 1a 06 65 6d 61  |.+..name1....ema|
00000010  69 6c 32 22 0b 0a 07 31  30 31 30 31 30 31 10 01  |il2"...1010101..|
00000020  22 0b 0a 07 31 30 31 30  31 30 31 10 02           |"...1010101..|
0000002d


  {
    // Read the existing address book.
    fstream input(argv[1], ios::in | ios::binary);
    cout << "??1" << endl;
    if (!address_book.ParseFromIstream(&input)) {
      cerr << "Failed to parse address book." << endl;
      return -1;
    }
    cout << "??2" << endl;
  }
❯ ./read_message.out addressbook.bin
??1
fish: Job 1, './read_message.out addressbook.…' terminated by signal SIGSEGV (Address boundary error)

❓ protobuf SerializeToOstream and parse segmentation fault

hexdump >>>
brew install hexyl
==> Verifying attestation for hexyl
Error: The bottle for hexyl could not be verified.

This typically indicates an outdated or incompatible `gh` CLI.

Please confirm that you're running the latest version of `gh`
by performing an upgrade before retrying:

  brew update
  brew upgrade gh

sudo apt install hexyl
```
