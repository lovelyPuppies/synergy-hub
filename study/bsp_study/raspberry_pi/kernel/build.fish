# It creates .config (it is copied from "arch/arm/configs/bcm2711_defconfig" file)
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig # only for raspberry.
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j4
## If only build kernel, add "zImage"
## If only build device drivers, add "modules"
# if test $status -eq 0
#     echo "Copy to nfs ..."
#     cp u-boot.bin /nfs/class/
#     ssh r-pi.local 'sudo cp /mnt/host/class/u-boot.bin /boot/firmware/'
#     ssh r-pi.local 'ls -la /boot/firmware/u-boot.bin && sudo reboot'
# end
arch/arm/boot/dts/overlays/Makefile
