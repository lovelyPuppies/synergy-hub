## 🎱 Mini-Project - Customize Boot Logo for Raspberry Pi B4

Written at 📅 2024-12-13 11:38:28

- [🎱 Mini-Project - Customize Boot Logo for Raspberry Pi B4](#-mini-project---customize-boot-logo-for-raspberry-pi-b4)
  - [✔️ Basic Repository Setup](#️-basic-repository-setup)
    - [Prepare a custom boot logo image](#prepare-a-custom-boot-logo-image)
  - [✔️ Add Custom Boot Logo: include/linux/linux_logo.h](#️-add-custom-boot-logo-includelinuxlinux_logoh)
  - [✔️ Add Custom Boot Logo Logic: drivers/video/logo/logo.c](#️-add-custom-boot-logo-logic-driversvideologologoc)
  - [✔️ Define Custom Boot Logo Config: drivers/video/logo/Kconfig](#️-define-custom-boot-logo-config-driversvideologokconfig)
  - [✔️ Register Custom Boot Logo File: drivers/video/logo/Makefile](#️-register-custom-boot-logo-file-driversvideologomakefile)
  - [✔️ Configure Boot Logo Option](#️-configure-boot-logo-option)
  - [✔️ Configure boot logo option](#️-configure-boot-logo-option-1)
  - [✔️ Build and Deploy Custom Kernel](#️-build-and-deploy-custom-kernel)

### ✔️ Basic Repository Setup

📁 Default Workspace: linux/ from `git clone https://github.com/raspberrypi/linux`

- Set up the kernel repository and prepare for customization.

  ```bash
  #!/usr/bin/env fish
  mkdir -p $HOME/repos/kernels/
  cd $HOME/repos/kernels/

  git clone https://github.com/raspberrypi/linux raspberry-pi

  # Create and switch to a new branch that tracks the remote branch origin
  git switch --create my-raspberry --track origin/rpi-6.6.y
  ```

- Edit `/boot/config.txt` on the Raspberry Pi to ensure it boots in 32-bit mode.

  ```ini
  arm_64bit=0
  ```

- Backup the current kernel image on the Raspberry Pi.

  ```bash
  ssh pi@r-pi.local '
    cp /boot/kernel7l.img /boot/kernel7l_backup.img
  '
  ```

#### Prepare a custom boot logo image

- Create a custom image for the boot logo and convert it to the required format.

  ```bash
  #!/usr/bin/env fish

  # 🪱 clut: Color Look-Up Table
  # Reduce the color palette of the image to 224 colors and save it as "puppies_logo_clut224.ppm"
  gm convert -colors 224 puppies_840x480.ppm puppies_logo_clut224.ppm

  # Convert the color-reduced image to ASCII PPM format and save it as "puppies_logo_clut224_ascii.ppm"
  gm convert -compress none puppies_logo_clut224.ppm puppies_logo_clut224_ascii.ppm

  # Move the ASCII PPM file to the Linux kernel's logo directory for custom logo integration
  mv puppies_logo_clut224_ascii.ppm drivers/video/logo/logo_custom_clut224.ppm
  ```

### ✔️ Add Custom Boot Logo: include/linux/linux_logo.h

- Declare the new custom logo structure for use in the kernel.

  ```c
  extern const struct linux_logo logo_spe_clut224;
  ```

- after:

  ```c
  //// ⚙️
  extern const struct linux_logo logo_kcci_clut224;
  ```

### ✔️ Add Custom Boot Logo Logic: drivers/video/logo/logo.c

- Integrate the new logo into the kernel's boot process.

  ```c
  //// ⚙️
  #ifdef CONFIG_LOGO_CUSTOM_CLUT224
      logo = &logo_custom_clut224;
  #endif
  ```

- after:

  ```c
  #ifdef CONFIG_LOGO_SUPERH_CLUT224
      /* SuperH Linux logo */
      logo = &logo_superh_clut224;
  #endif
  ```

### ✔️ Define Custom Boot Logo Config: drivers/video/logo/Kconfig

- Add a configuration option to enable the custom logo in the kernel.

  ```ini
  # ⚙️
  config LOGO_CUSTOM_CLUT224
    bool "kcci 224--color Linux logo"
    depends on LOGO
    default y
  ```

- before:

  ```ini
  endif # LOGO
  ```

### ✔️ Register Custom Boot Logo File: drivers/video/logo/Makefile

- Ensure the custom logo file is included in the build process.

  ```Makefile
  # ⚙️
  obj-$(CONFIG_LOGO_CUSTOM_CLUT224)     += logo_custom_clut224.o
  ```

- after:

  ```Makefile
  obj-$(CONFIG_LOGO_SUPERH_CLUT224)    += logo_superh_clut224.o
  ```

### ✔️ Configure Boot Logo Option

- Load default configuration for Raspberry Pi and enable custom boot logo options.

  ```bash
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
  ```

### ✔️ Configure boot logo option

- ...

  ```bash
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig

  ###
  # Navigate to:
  # Device Drivers
  #   Graphics Support
  #     Bootup logo
  #       ✔️ CONFIG_LOGO_CUSTOM_CLUT224
  ###
  ```

### ✔️ Build and Deploy Custom Kernel

- Build the customized kernel and deploy it to the Raspberry Pi.

  ```bash
  # Build the kernel image
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage -j$(nproc)

  # Copy the built kernel image
  cp arch/arm/boot/zImage /nfs/class/pi_kernel/kernel7l.img

  # Deploy kernel to Raspberry Pi
  scp /nfs/class/pi_kernel/kernel7l.img pi@r-pi.local:/boot/kernel7l.img
  ```
