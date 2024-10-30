APP := call_app
APP_OUT := $(APP).out
MOD := call_dev
SRC := $(APP).c
obj-m := $(MOD).o

CROSS = ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
CC := arm-linux-gnueabihf-gcc
KDIR := $(HOME)/repos/kernels/raspberry-pi
PWD := $(shell pwd)

default: $(APP_OUT)
	$(MAKE) -C $(KDIR) M=$(PWD) modules $(CROSS)
	cp $(MOD).ko /nfs/drivers

# $< : The first dependency file (in this case, $(SRC) → call_app.c)
# $@ : The target file name (in this case, $(APP_OUT) → call_app.out)

$(APP_OUT): $(SRC)
	$(CC) $< -o $@
	cp $@ /nfs/drivers

clean:
	rm -rf *.ko
	rm -rf *.mod.*
	rm -rf .*.cmd
	rm -rf *.o
	rm -rf modules.order
	rm -rf Module.symvers
	rm -rf $(MOD).mod
	rm -rf .tmp_versions
	rm -rf $(APP_OUT)
