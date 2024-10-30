
# Overview of Yocto Project and Jetson Boards

This document provides an overview of the relationship between **Linux for Tegra (L4T)**, Yocto Project branches, and the Jetson boards supported by each version of L4T.

## Yocto Branches and Jetson Board Compatibility

| **Yocto Branch**    | **L4T Version** | **JetPack Version** | **Supported Jetson Boards**                                                                                   |
|---------------------|-----------------|---------------------|---------------------------------------------------------------------------------------------------------------|
| **Kirkstone-32.xx** | L4T 32.x.x       | JetPack 4.x         | Jetson Nano, Jetson TX1, Jetson TX2, Jetson Xavier NX, Jetson AGX Xavier                                       |
| **Scarthgap-36.xx** | L4T 36.x.x       | JetPack 6.x         | Jetson Orin Nano, Jetson Orin NX, Jetson AGX Orin, Jetson AGX Orin Industrial                                  |

### Key Notes on Compatibility

- **L4T 32.x** is intended for older Jetson boards such as Jetson Nano and TX series.
- **L4T 36.x** is geared toward the newer Orin series boards.

## Setting Up Yocto for Jetson Nano Using `kas`

If you are working with the `kirkstone-l4t-r32.7.x` branch, you can efficiently configure Yocto using the `kas` tool for declarative management of the setup.

### Example `kas` YAML Configuration

Below is an example YAML configuration file for setting up the Yocto environment using `kas`:

```yaml
header:
  version: 10

repos:
  poky:
    url: https://git.yoctoproject.org/poky
    refspec: kirkstone
  meta-openembedded:
    url: https://git.openembedded.org/meta-openembedded
    refspec: kirkstone
  meta-tegra:
    url: https://github.com/OE4T/meta-tegra.git
    refspec: kirkstone-l4t-r32.7.x
  meta-yocto-bsp:
    url: https://git.yoctoproject.org/meta-yocto-bsp
    refspec: kirkstone

target:
  machine: "jetson-nano-devkit"

build:
  bitbake_target: "core-image-sato-dev"
```

### YAML File Breakdown

1. **`repos`**: Lists the repositories used for layers in Yocto. For example, `poky` and `meta-tegra` are important for building images for Jetson Nano.
2. **`target`**: Defines the target hardware (Jetson Nano in this case) using the `jetson-nano-devkit` setting.
3. **`build`**: Specifies the target image for building, such as `core-image-sato-dev`.

### Running the Build

Once you have the YAML file ready, you can start the build with this command:

```bash
kas build path_to_kas_yaml.yml
```

This will automatically fetch all necessary layers and build the image for Jetson Nano.

## Machine Configuration in Yocto for Jetson Nano

The `MACHINE = "jetson-nano-devkit"` setting in Yocto tells the build system to configure for Jetson Nano. This informs Yocto which machine-specific settings to load.

### Source of `jetson-nano-devkit` Configuration

The configuration for Jetson Nano is found in the **`meta-tegra`** layer, which contains machine-specific files for Jetson boards. The relevant configuration file is located here:

```bash
meta-tegra/conf/machine/jetson-nano-devkit.conf
```

This file specifies hardware settings such as the kernel version, device tree, and bootloader.

### Example Configuration in `jetson-nano-devkit.conf`

```bash
# meta-tegra/conf/machine/jetson-nano-devkit.conf

PREFERRED_PROVIDER_virtual/kernel = "linux-tegra"
KERNEL_DEVICETREE = "nvidia/tegra210-p3448-0000-p3449-0000-a02.dtb"
UBOOT_MACHINE = "jetson-nano-qspi"
...
```

## Workflow Summary for Jetson Nano

1. Set `MACHINE = "jetson-nano-devkit"` to specify the hardware.
2. Yocto looks up the machine configuration file in **`meta-tegra`**.
3. The configurations define hardware details like the kernel and bootloader.
4. Yocto uses these settings to build a compatible Linux image for the Jetson Nano.



## Building Images for Other Jetson Devices

Other Jetson boards like Jetson TX2 and Jetson Orin Nano have their own machine configuration files in the **`meta-tegra`** layer. Here are examples of other device configurations:

- **Jetson TX2**: The configuration file is located at `meta-tegra/conf/machine/jetson-tx2-devkit.conf`.
- **Jetson Orin Nano**: The configuration file is located at `meta-tegra/conf/machine/jetson-orin-nano-devkit.conf`.

By specifying the `MACHINE` variable, such as `MACHINE = "jetson-orin-nano-devkit"`, Yocto will apply the correct configurations for building an image compatible with your target Jetson device.

## Customizing Yocto for Jetson Nano

Jetson Nano usually runs **JetPack SDK**, which provides tools like CUDA, TensorRT, and more for AI development. However, using **Yocto** allows you to build a more minimal Linux system tailored to your needs.

### Important Concepts for Yocto and Jetson Nano

- **Tegra X1 SoC**: Jetson Nano is powered by NVIDIA’s Tegra X1 SoC, which includes a Maxwell GPU and ARM Cortex-A57 CPU, making it ideal for AI workloads.
  
- **ARM Architecture**: Jetson Nano uses a quad-core ARM Cortex-A57 CPU. ARM architecture is commonly used in embedded systems due to its balance of performance and energy efficiency.

- **Yocto Layers**: Yocto builds are modular and rely on layers for customization. For Jetson Nano, you would use the **meta-tegra** layer, which provides support for key NVIDIA technologies, such as CUDA and TensorRT, while keeping the system lightweight and customizable.

## Yocto and Meta-tegra Integration for Jetson Nano

The **meta-tegra** layer is essential for enabling Jetson Nano’s hardware features and leveraging NVIDIA's Linux for Tegra (L4T). With **meta-tegra**, you can build a custom Linux distribution with the flexibility of Yocto while still benefiting from NVIDIA's platform-specific optimizations.

### Workflow for Custom Yocto Images on Jetson Nano

1. **Set up Yocto**: Begin by setting up Yocto with the necessary layers, including **meta-tegra** for NVIDIA Jetson support.
2. **Customize Recipes**: Modify the build recipes to include only the packages you need, creating a more minimal or specialized distribution.
3. **Build and Flash**: Build the image and flash it to your Jetson Nano. You’ll have a custom-built system designed for your use case, with hardware acceleration and essential NVIDIA libraries.

## Useful Resources

Here are some useful references and resources for working with Yocto and NVIDIA Jetson platforms:

1. **Yocto Project Releases**: Yocto regularly releases updates for its build system. You can find more information about the available versions and their release schedules here: [Yocto Project Releases](https://www.yoctoproject.org/development/releases/).

2. **meta-tegra Repository**: The `meta-tegra` repository is maintained by the OpenEmbedded for Tegra (OE4T) community and provides support for building Yocto-based distributions for Jetson boards. Visit the repository here: [meta-tegra GitHub](https://github.com/OE4T/meta-tegra).

3. **RidgeRun Yocto Support for Jetson**: RidgeRun provides detailed guidance on setting up Yocto for NVIDIA Jetson platforms, including instructions on flashing and integrating NVIDIA-specific software like CUDA and TensorRT. Their guide is available here: [RidgeRun Yocto for NVIDIA Jetson](https://developer.ridgerun.com/wiki/index.php/Yocto_Support_for_NVIDIA_Jetson_Platforms_-_Setting_up_Yocto).


## References

https://github.com/kennymckormick/pyskl/blob/main/tools/data/README.md




## Summary: Testing Yocto ARM64 Image in QEMU

1. **Yocto ARM64 Image as a Standalone OS**
   - Yocto-built ARM64 images include a complete OS with a kernel, filesystem, drivers, and libraries for ARM64 devices (e.g., Jetson Nano).
   - This image can run directly on QEMU without needing an additional OS, as it’s already designed for ARM64.

2. **Booting Yocto Image in QEMU**
   - Use `qemu-system-aarch64` to set up an ARM64 virtual environment and boot the Yocto image directly.
   - This allows you to test the image’s functionality in an ARM64 environment before deploying to Jetson Nano.

3. **No Need for an Additional OS**
   - Since the Yocto image is a complete ARM64 OS, there’s no need to add another ARM64 OS (e.g., Ubuntu ARM64).
   - You can use QEMU to boot the Yocto image directly for testing.

4. **Conclusion**
   - Yocto-built ARM64 images are fully compatible with ARM64 devices, so no extra OS is required in QEMU.
   - Configure QEMU for ARM64, and boot the Yocto image directly for testing.

