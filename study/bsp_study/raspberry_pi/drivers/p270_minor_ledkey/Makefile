APP := minor_app
MOD := minor_dev
OBJ := $(APP).o
obj-m := $(MOD).o

CROSS = ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
CC := arm-linux-gnueabihf-gcc
KDIR := $(HOME)/repos/kernels/raspberry_pi

PWD := $(shell pwd)

default:$(OBJ)
	$(MAKE) -C $(KDIR) M=$(PWD) modules $(CROSS)
	cp $(MOD).ko /nfs/drivers
%.o:%.c
	$(CC) -o $(APP) $<
	cp $(APP) /nfs/drivers
clean:
	rm -rf *.ko
	rm -rf *.mod.*
	rm -rf .*.cmd
	rm -rf *.o
	rm -rf modules.order
	rm -rf Module.symvers
	rm -rf $(MOD).mod
	rm -rf .tmp_versions
	rm -rf $(APP)
