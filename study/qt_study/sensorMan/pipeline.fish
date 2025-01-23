#!/usr/bin/env fish

## Build with Clang using Make
# 🧮 compiledb make
## ❗ Reopen source codes in order to recognize the generated compile_commands.json in VSCode



## 📟 in Terminal 1
#  🧮 ssh -t r-pi.local 'journalctl -k --since "now" -f'



## 📟 in Terminal 2 
ssh r-pi.local '
sudo mknod /dev/ledKey_dev c 230 0
sudo chmod 666 /dev/ledKey_dev
'
ssh r-pi.local 'sudo insmod /mnt/host/drivers/kernel_timer_dev.ko'


# ssh r-pi.local 'sudo rmmod kernel_timer_dev'
