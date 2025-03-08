# Common Issues
// 삭제 예정. 잘못된 부분도 있음..
brew install arm-none-eabi-gcc arm-none-eabi-gdb

#### ☑️🚨 (Issue: Error); Could not determine GDB version using command: arm-none-eabi-gdb --version

Reported Date: 📅 2024-12-07 20:11:35

##### **Error Message**:

```
Could not determine GDB version using command: arm-none-eabi-gdb --version
arm-none-eabi-gdb: error while loading shared libraries: libncurses.so.5: cannot open shared object file: No such file or directory
```

##### **Category**:

- Missing dependencies or tools for ARM development environment.

##### **Root Cause**:

- When using STM32CubeIDE, tools like `arm-none-eabi-gdb` and `arm-none-eabi-gcc` are **not automatically installed**. They must be installed manually.
- In contrast, when using the STM32 extension in Visual Studio Code, the installation of `stm32cubeclt` automatically includes these tools.
  ```bash
  which arm-none-eabi-gdb
  ```
  Example output:
  ```
  /home/username/st/stm32cubeclt/GNU-tools-for-STM32/bin/arm-none-eabi-gdb
  ```

##### ➡️ **Resolution**:

1. Install the missing tools if necessary:
   ```bash
   brew install gcc-arm-none-eabi gdb-arm-none-eabi
   ```
2. add Debugger setting in STM32 IDE

##### **Additional Notes**:

- `arm-none-eabi-gdb` is a specific version of GNU Debugger (GDB) designed for debugging ARM microcontrollers.
