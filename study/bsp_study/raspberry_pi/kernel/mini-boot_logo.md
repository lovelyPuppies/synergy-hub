## 🎱 Mini-Project - Customize Boot Logo for Raspberry Pi B4

📅 Written at 2024-12-13 11:38:28

- [🎱 Mini-Project - Customize Boot Logo for Raspberry Pi B4](#-mini-project---customize-boot-logo-for-raspberry-pi-b4)
  - [✔️ Basic Setup](#️-basic-setup)
    - [in ChatGPT, Say "Create puppies pictures" to "Dall-E" and Save picture for boot logo.](#in-chatgpt-say-create-puppies-pictures-to-dall-e-and-save-picture-for-boot-logo)
  - [✔️ .. 작업 디렉토리를 라즈베리파이 리눅스 커널 소스로 설정.](#️--작업-디렉토리를-라즈베리파이-리눅스-커널-소스로-설정)
  - [✔️ Configuration: include/linux/linux_logo.h](#️-configuration-includelinuxlinux_logoh)
  - [✔️ Configuration: drivers/video/logo/logo.c](#️-configuration-driversvideologologoc)
  - [✔️ Configuration: drivers/video/logo/Kconfig](#️-configuration-driversvideologokconfig)
  - [✔️ Configuration: drivers/video/logo/Makefile](#️-configuration-driversvideologomakefile)
  - [✔️🧪 Test: build and mount process for prebuilt layer **core-image-minimal**](#️-test-build-and-mount-process-for-prebuilt-layer-core-image-minimal)
  - [✔️🧪 Test: build and mount process for custom layer: **rpilinux-image**](#️-test-build-and-mount-process-for-custom-layer-rpilinux-image)
    - [✔️ Code: meta-rpilinux/recipes-rpilinux/images/rpilinux-image.bb](#️-code-meta-rpilinuxrecipes-rpilinuximagesrpilinux-imagebb)
    - [✔️ Configuration: meta-rpilinux/conf/layer.conf](#️-configuration-meta-rpilinuxconflayerconf)
  - [🚣 Additional Tip](#-additional-tip)
    - [Using `tar.bz2` File Instead of Direct Writing `.ext` File](#using-tarbz2-file-instead-of-direct-writing-ext-file)
    - [🛍️ Example Workflow:](#️-example-workflow)

### ✔️ Basic Setup

📁 Default Workspace: linux/ from `git clone https://github.com/raspberrypi/linux`

#### in ChatGPT, Say "Create puppies pictures" to "Dall-E" and Save picture for boot logo.

- Save file name as **puppies_840x480** (resolution: **800x480**, **.ppm** extension) in **GIMP**

### ✔️ .. 작업 디렉토리를 라즈베리파이 리눅스 커널 소스로 설정.

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

### ✔️ Configuration: include/linux/linux_logo.h

- Add lines

  ```c
  extern const struct linux_logo logo_spe_clut224;
  ```

  after

  ```c
  //// ⚙️
  extern const struct linux_logo logo_kcci_clut224;
  ```

### ✔️ Configuration: drivers/video/logo/logo.c

- Add lines

  ```c
  //// ⚙️
  #ifdef CONFIG_LOGO_CUSTOM_CLUT224
      logo = &logo_custom_clut224;
  #endif
  ```

  after

  ```c
  #ifdef CONFIG_LOGO_SUPERH_CLUT224
      /* SuperH Linux logo */
      logo = &logo_superh_clut224;
  #endif
  ```

### ✔️ Configuration: drivers/video/logo/Kconfig

- Add lines

  ```ini
  # ⚙️
  config LOGO_CUSTOM_CLUT224
    bool "kcci 224--color Linux logo"
    depends on LOGO
    default y
  ```

  before

  ```ini
  endif # LOGO
  ```

### ✔️ Configuration: drivers/video/logo/Makefile

- Add lines

  ```Makefile
  # ⚙️
  obj-$(CONFIG_LOGO_CUSTOM_CLUT224)	    += logo_custom_clut224.o

  ```

  after

  ```Makefile
  obj-$(CONFIG_LOGO_SUPERH_CLUT224)	+= logo_superh_clut224.o
  ```

### ✔️🧪 Test: build and mount process for prebuilt layer [**core-image-minimal**](https://layers.openembedded.org/layerindex/recipe/579/)

```bash
#!/usr/bin/env fish
bitbake core-image-minimal

: 'Other layers 🛍️ e.g.
  core-image-minimal-dev ; https://layers.openembedded.org/layerindex/recipe/580/
  core-image-full-cmdline ; https://layers.openembedded.org/layerindex/recipe/24184/
  core-image-x11 ; https://layers.openembedded.org/layerindex/recipe/351/
  core-image-sato ; https://layers.openembedded.org/layerindex/recipe/658/
'
```

```bash
#!/usr/bin/env fish
ls build/tmp/deploy/images/raspberrypi4/core-image-minimal*.ext4
set ext4_file_path build/tmp/deploy/images/raspberrypi4/core-image-minimal-raspberrypi4.rootfs.ext4

# Mount your SD card Reader Device
df -h
sudo umount /dev/sdb?
sudo dd if=$ext4_file_path of=/dev/sdb2 bs=1M status=progress
sync

# and Boot your rassbpery pi with the SD card, see terminal output from USB to TTL Serial Cable.
```

### ✔️🧪 Test: build and mount process for custom layer: **rpilinux-image**

```bash
#!/usr/bin/env fish

# Prepare to define custom layer
# refer to dicrectory structure in existing image "meta-raspberrypi"
#   🧮 fd images meta-raspberrypi/
mkdir -p meta-rpilinux/conf
mkdir -p meta-rpilinux/recipes-rpilinux/images
```

#### ✔️ Code: meta-rpilinux/recipes-rpilinux/images/rpilinux-image.bb

```bash
require recipes-core/images/core-image-minimal.bb

IMAGE_INSTALL += "libstdc++ mtd-utils"
IMAGE_INSTALL += "openssh openssl openssh-sftp-server"
IMAGE_INSTALL += "python3 gcc libgcc"
```

#### ✔️ Configuration: meta-rpilinux/conf/layer.conf

```bash
# We have a conf and classes directory, add to BBPATH
BBPATH .= ":${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "${LAYERDIR}/recipes-*/*/*.bb \
  ${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "rpilinux"
BBFILE_PATTERN_rpilinux = "^${LAYERDIR}/"
BBFILE_PRIORITY_rpilinux = "6"

LAYERSERIES_COMPAT_rpilinux = "styhead"
```

```bash
#!/usr/bin/env fish
bitbake rpilinux-image
```

```bash
#!/usr/bin/env fish

ls build/tmp/deploy/images/raspberrypi4/rpilinux-image*.ext4
set ext4_file_path build/tmp/deploy/images/raspberrypi4/rpilinux-image-raspberrypi4.rootfs.ext4

# Mount your SD card Reader Device
df -h
sudo umount /dev/sdb?
sudo dd if=$ext4_file_path of=/dev/sdb2 bs=1M status=progress
sync

# and Boot your rassbpery pi with the SD card, see terminal output from USB to TTL Serial Cable.
```

### 🚣 Additional Tip

#### Using `tar.bz2` File Instead of Direct Writing `.ext` File

Instead of writing the `.ext` file directly to the partition using `dd`, you can utilize the `tar.bz2` file after formatting the partition.

#### 🛍️ Example Workflow:

```bash
#!/usr/bin/env fish

# Unmount the partition
sudo umount /dev/sdb2

# Format the partition as ext4
sudo mkfs.ext4 /dev/sdb2

# Set a label for the partition
sudo e2label /dev/sdb2 rootfs

# Create a local mount point and mount the partition
# 📝 Note: Replace `/media/$USER/rootfs` with your desired mount point if different
sudo mkdir -p /media/$USER/rootfs
sudo mount /dev/sdb2 /media/$USER/rootfs

# Extract the root filesystem tarball to the mounted partition
# tar options:
# -x: extract
# -v: verbose (show files being extracted)
# -f: file (specifies the tar file to extract)
# -p: preserve file permissions
sudo tar xvfp core-image-minimal-raspberrypi4.rootfs.tar.bz2 -C /media/$USER/rootfs
```
