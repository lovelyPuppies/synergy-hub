#!/bin/bash
if [ -f /dev/ledkey_dev ]; then 
	sudo chmod 666 /dev/ledkey_dev
else
	sudo mknod /dev/ledkey_dev c 230 0
	sudo chmod 666 /dev/ledkey_dev
fi
sudo insmod $1



: '
echo 85 > /proc/ledkey/led
echo 0 > /proc/ledkey/led
echo 255 > /proc/ledkey/led


cp proc_test_app /nfs/drivers/


./proc_test_app 255
./proc_test_app 85


'

ssh r-pi.local '
sudo mknod /dev/kernel_timer c 230 0
sudo chmod 666 /dev/kernel_timer
sudo insmod /mnt/host/drivers/kernel_timer_dev.ko
'