APPLICATION1 := kernel_timer_app1
APPLICATION2 := kernel_timer_app2_ioctl
KERNEL_MODULE := kernel_timer_dev
OBJECT_FILES := $(APPLICATION1).o $(APPLICATION2).o
obj-m := $(KERNEL_MODULE).o  # ❗ Don't change this reserved name

CROSS_COMPILE_OPTIONS = ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
COMPILER := arm-linux-gnueabihf-gcc
KERNEL_DIRECTORY := $(HOME)/repos/kernels/raspberry-pi
CURRENT_DIRECTORY := $(shell pwd)

default: $(OBJECT_FILES)
	$(MAKE) -C $(KERNEL_DIRECTORY) M=$(CURRENT_DIRECTORY) modules $(CROSS_COMPILE_OPTIONS)
	cp $(KERNEL_MODULE).ko /nfs/drivers

%.o: %.c
	$(COMPILER) -o $*.out $<
	cp $*.out /nfs/drivers

clean:
	rm -rf *.ko
	rm -rf *.mod.*
	rm -rf .*.cmd
	rm -rf *.o
	rm -rf *.out
	rm -rf modules.order
	rm -rf Module.symvers
	rm -rf $(KERNEL_MODULE).mod
	rm -rf .tmp_versions
