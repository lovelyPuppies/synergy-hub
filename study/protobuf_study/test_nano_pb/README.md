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

```
