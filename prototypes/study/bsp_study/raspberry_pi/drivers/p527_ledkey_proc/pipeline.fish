#!/usr/bin/env fish

## Build with Clang using Make
# 🧮 compiledb make
## ❗ Reopen source codes in order to recognize the generated compile_commands.json in VSCode



## 📟 in Terminal 1
#  🧮 ssh -t r-pi.local 'journalctl -k --since "now" -f'



## 📟 in Terminal 2
ssh r-pi.local '
sudo mknod /dev/ledkey c 230 0
sudo chmod 666 /dev/ledkey
'
ssh r-pi.local 'sudo insmod /mnt/host/drivers/p527_ledkey_dev.ko'

ssh -t r-pi.local /mnt/host/drivers/p527_ledkey_app 0x55

ssh r-pi.local 'sudo rmmod p527_ledkey_dev'
