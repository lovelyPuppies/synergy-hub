APP := fnd_app
MOD := fnd_dev
SRC := $(APP).c
obj-m := $(MOD).o
PWD := $(shell pwd)
CROSS = ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-

#KDIR := /lib/modules/$(shell uname -r)/build
#CC := gcc
KDIR := $(HOME)/repos/kernels/raspberry-pi
CC := arm-linux-gnueabihf-gcc

APPLDFLAGS := -D_REENTRANT -pthread


default:$(APP)
	$(MAKE) -C $(KDIR) M=$(PWD) modules $(CROSS)
	cp $(MOD).ko /nfs/drivers

$(APP):$(SRC)
	$(CC) -o $@ $< $(APPLDFLAGS)
	cp $(APP) /nfs/drivers

clean:
	rm -rf *.ko
	rm -rf *.o
	rm -rf .*.cmd
	rm -rf .tmp_*
	rm -rf *.mod*
	rm -rf Module.*
	rm -rf modules.*
	rm -rf $(APP)
