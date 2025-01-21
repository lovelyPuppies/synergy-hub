# FAQ

- [FAQ](#faq)
  - [1. Required Steps for Kernel Module Build with Clang](#1-required-steps-for-kernel-module-build-with-clang)
    - [➡️ Set the flag `fno-pic`](#️-set-the-flag-fno-pic)
      - [🆚 Comparison: Flag "fno-pic" in Clang vs. GCC](#-comparison-flag-fno-pic-in-clang-vs-gcc)
        - [⚖️ Default behavior and purpose of `-fno-pic`:](#️-default-behavior-and-purpose-of--fno-pic)
      - [💡 Why disable PIC for kernel modules?](#-why-disable-pic-for-kernel-modules)
      - [⚠️ Issue if `-fno-pic` is not used when building kernel modules:](#️-issue-if--fno-pic-is-not-used-when-building-kernel-modules)
      - [🔑 Key benefits of PIC:](#-key-benefits-of-pic)
  - [2. General Information](#2-general-information)
    - [🆚 Comparison: (Hard-float vs. Soft-float)](#-comparison-hard-float-vs-soft-float)
      - [Hard-float](#hard-float)
      - [Soft-float](#soft-float)

## 1. Required Steps for Kernel Module Build with Clang

### ➡️ Set the flag `fno-pic`

Written at 📅 2024-12-23 00:35:28

#### 🆚 Comparison: Flag "fno-pic" in Clang vs. GCC

##### ⚖️ Default behavior and purpose of `-fno-pic`:

- **GCC**:

  - Default: Disabled.
  - Kernel modules are built without PIC by default, as GCC optimizes for kernel requirements.

- **Clang**:
  - Default: 🚣 Enabled.
    - Modern compilers prioritize a balance of security and performance.
  - 🪱 PIC (Position-Independent Code) is enabled by default to enhance security and support for dynamic libraries in user-space applications.

#### 💡 Why disable PIC for kernel modules?

- Kernel modules are not dynamic libraries and are directly mapped to fixed memory addresses.
- PIC introduces additional registers and memory access overhead, which are unnecessary in the kernel environment.
- Kernel modules do not benefit from PIC's runtime address relocation as the kernel already manages its own address space and memory protection.
- **Drawbacks of PIC in kernel modules**:
  - Performance degradation due to runtime address calculations.
  - Potential relocation issues caused by unnecessary PIC instructions.

#### ⚠️ Issue if `-fno-pic` is not used when building kernel modules:

- When running `insmod` (Insert Module):
  - Error: `insmod: ERROR: could not insert module /mnt/host/drivers/kernel_timer_dev.ko: Invalid module format`.
- In `dmesg` (diagnostic message):
  - Logs show: `[  724.582528] kernel_timer_dev: unknown relocation: 96`.

#### 🔑 Key benefits of PIC:

- **Designed for user-space applications** that utilize dynamic libraries or 🪱 ASLR (Address Space Layout Randomization).
- **Runtime memory addresses are calculated dynamically**:
  - Allows the same code to be shared across multiple processes or libraries.
- **Security advantages**:
  - Avoids fixed address spaces, reducing vulnerabilities like buffer overflow attacks.
  - Enables support for ASLR, making memory exploits harder to execute.
- **Flexibility advantages**:
  - Simplifies dynamic linking, allowing libraries to be loaded at different memory locations.
  - Reduces overall memory usage by sharing a single instance of the library across processes.

---

## 2. General Information

### 🆚 Comparison: (Hard-float vs. Soft-float)

Written at 📅 2024-12-23 00:35:28

#### Hard-float

- Performs floating-point operations using the CPU's built-in 🪱 Floating Point Unit (FPU).
- Calculation speed is faster as the FPU directly handles operations, freeing up the CPU for other tasks.
- 🛍️ **e.g.** In ARMv7, FPU can be utilized with the 🪱 flag `-mfloat-abi=hard`.

#### Soft-float

- Emulates floating-point operations through software routines (libraries) without using an FPU.
- Calculation speed is slower as the CPU directly processes floating-point calculations.
- 🛍️ **e.g.** ARM Cortex-M0 (no FPU available).
