#!/usr/bin/env fish

ssh r-pi.local '
sudo mknod /dev/ledkey_dev c 230 0
sudo chmod 666 /dev/ledkey_dev
'
ssh r-pi.local 'sudo insmod /mnt/host/drivers/ledkey_block_io_dev.ko'

ssh -t r-pi.local '/mnt/host/drivers/ledkey_block_io_app 0x55'

ssh r-pi.local 'sudo rmmod ledkey_block_io_dev'
