# https://www.raspberrypi.com/documentation/computers/linux_kernel.html#building
mkdir -p /nfs/class/pi_kernel
sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/nfs/class/pi_kernel modules_install
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- headers_install

mkdir -p /nfs/class/pi_kernel/dts
mkdir -p /nfs/class/pi_kernel/dts/overlays
cp arch/arm/boot/zImage /nfs/class/pi_kernel/kernel7l.img
cp arch/arm/boot/dts/broadcom/*.dtb* /nfs/class/pi_kernel/dts/
cp arch/arm/boot/dts/overlays/*.dtb* /nfs/class/pi_kernel/dts/overlays/
cp arch/arm/boot/dts/overlays/README /nfs/class/pi_kernel/dts/overlays/
if test $status -eq 0
    echo "Copy from nfs ..."
    ssh r-pi.local '\
    sudo cp /mnt/host/class/pi_kernel/kernel7l.img /boot/firmware/
    sudo reboot
    '

    ssh r-pi.local 'sudo cp -r /mnt/host/class/pi_kernel/lib/modules/6.6.63-v7l+ /lib/modules/'
    # sudo cp /boot/firmware/kernel7l.img /boot/firmware/kernel7l_orgigin.img

    ssh r-pi.local 'sudo cp -r /mnt/host/class/pi_kernel/dts/* /boot/firmware/'
    ssh r-pi.local 'du -hd 1 /lib/modules/ | grep 6.6.63-v7l+'
end

: '
🚧 Requires
# uname -a
#   Linux pi19 6.6.51+rpt-rpi-v8 #1 SMP PREEMPT Debian 1:6.6.51-1+rpt3 (2024-10-08) aarch64 GNU/Linux
# set this in "[all]" in /boot/firmware/config.txt
arm_64bit=0

# uname -a
#   Linux pi19 6.6.63-v7l+ #1 SMP Fri Dec  6 12:07:32 KST 2024 armv7l GNU/Linux


'
