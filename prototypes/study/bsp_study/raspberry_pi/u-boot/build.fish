## One-time
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- rpi_4_32b_defconfig
# 이미 .config 파일이 존재하는 경우, make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- rpi_4_32b_defconfig 명령어를 실행하면 기존의 .config 파일이 덮어씌워집니다
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- all
if test $status -eq 0
    echo "Copy to nfs ..."
    cp u-boot.bin /nfs/class/
    ssh r-pi.local 'sudo cp /mnt/host/class/u-boot.bin /boot/firmware/'
    ssh r-pi.local 'ls -la /boot/firmware/u-boot.bin && sudo reboot'
end
