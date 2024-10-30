## 🎱 Mini-Project - Yocto for Raspberry Pi B4

Written at 📅 2024-12-12 19:21:31

- [🎱 Mini-Project - Yocto for Raspberry Pi B4](#-mini-project---yocto-for-raspberry-pi-b4)
  - [✔️ Basic Setup](#️-basic-setup)
  - [✔️ Configuration: build/conf/local.conf](#️-configuration-buildconflocalconf)
  - [✔️ Configuration: build/conf/bblayers.conf](#️-configuration-buildconfbblayersconf)
  - [✔️ Show Layers](#️-show-layers)
  - [✔️🧪 Test: build and mount process for prebuilt layer **core-image-minimal**](#️-test-build-and-mount-process-for-prebuilt-layer-core-image-minimal)
  - [✔️🧪 Test: build and mount process for custom layer: **rpilinux-image**](#️-test-build-and-mount-process-for-custom-layer-rpilinux-image)
    - [✔️ Code: meta-rpilinux/recipes-rpilinux/images/rpilinux-image.bb](#️-code-meta-rpilinuxrecipes-rpilinuximagesrpilinux-imagebb)
    - [✔️ Configuration: meta-rpilinux/conf/layer.conf](#️-configuration-meta-rpilinuxconflayerconf)
  - [🚣 Additional Tip](#-additional-tip)
    - [Using `tar.bz2` File Instead of Direct Writing `.ext` File](#using-tarbz2-file-instead-of-direct-writing-ext-file)
    - [🛍️ Example Workflow:](#️-example-workflow)

### ✔️ Basic Setup

📁 Default Workspace: poly/ from `git clone git://git.yoctoproject.org/poky`

```bash
#!/usr/bin/env fish
mkdir -p $HOME/repos/yocto_project
cd $HOME/repos/yocto_project

git clone git://git.yoctoproject.org/poky

git branch -a

# Create and switch to a new branch that tracks the remote branch origin
git switch --create my-styhead --track origin/styhead
```

```bash
#!/usr/bin/env fish

# meta-raspberrypi ; https://layers.openembedded.org/layerindex/branch/master/layer/meta-raspberrypi/
#   rpi-base.inc ; https://git.yoctoproject.org/meta-raspberrypi/tree/conf/machine/include/rpi-base.inc

git clone https://git.yoctoproject.org/git/meta-raspberrypi
rg "IMAGE_FSTYPES" meta-raspberrypi/

# activate env. it changes pwd to build/
replay source oe-init-build-env
# change pwd to yocto root (poky)
cd ../
```

### ✔️ Configuration: build/conf/local.conf

```bash
### ⚙️
# Comment this line:        MACHINE ??= "qemux86-64"
MACHINE ??= "raspberrypi4"

## Add this line or add "ext4" in "meta-raspberrypi/conf/machine/include/rpi-base.inc"
#   8:IMAGE_FSTYPES ?= "tar.bz2 ext3 wic.bz2 wic.bmap"
IMAGE_FSTYPES:append = " ext4"

## License accept flag is required when I run "bitbake core-image-x11 bitbake core-image-sato"
# https://meta-raspberrypi.readthedocs.io/en/latest/ipcompliance.html#linux-firmware-rpidistro
#   https://github.com/agherzan/meta-raspberrypi/issues/1111
LICENSE_FLAGS_ACCEPTED = "synaptics-killswitch"
```

### ✔️ Configuration: build/conf/bblayers.conf

```bash
### ⚙️ ~

# Reference: bitbake/lib/layerindexlib/tests/testdata/build/conf/bblayers.conf
LAYERSERIES_CORENAMES = "sumo"

# LAYER_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
LCONF_VERSION = "7"

BBPATH = "${TOPDIR}"
# https://stackoverflow.com/questions/38890788/why-does-the-yocto-bblayers-conf-file-use-absolute-paths
YOCTOROOT = "${@os.path.abspath(os.path.join("${TOPDIR}", os.pardir))}"

BBFILES ?= ""

BBLAYERS ?= " \
  ${YOCTOROOT}/meta \
  ${YOCTOROOT}/meta-poky \
  ${YOCTOROOT}/meta-yocto-bsp \
  ${YOCTOROOT}/meta-raspberrypi \
  ${YOCTOROOT}/meta-rpilinux \
  "
```

### ✔️ Show Layers

```bash
#!/usr/bin/env fish
bitbake-layers show-layers
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
