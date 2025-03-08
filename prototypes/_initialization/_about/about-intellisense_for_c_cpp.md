# about-intellisense_for_c_cpp.md

📅 Written at 2024-12-18 04:33:15

## Why I use clangd instead of Microsoft's C/C++ IntelliSense

### Background

- The `c_cpp_properties.json` file is specific to Microsoft's C/C++ extension for VSCode.
- It requires **manual configuration** of paths for IntelliSense.
- Even with proper configuration, the **IntelliSense and autocompletion** provided are **poor** when cross-compiling kernel modules.

🚨 I personally encountered this issue when setting up cross-compilation for ARM kernel drivers. Even for regular local variables, name autocompletion does not work. Switching to `clangd` resulted in a much better experience for both IntelliSense and autocompletion.

---

## ⭕ Recommended Setup: Using Clangd with Microsoft's C/C++ Extension

**Reference:** https://stackoverflow.com/questions/51885784/how-to-setup-vs-code-for-c-with-clangd-support

- ⭕ Microsoft's C/C++ extension is great for debugging, and I still recommend installing it.
- ⭕ However, for IntelliSense, `clangd` provides a **more accurate result** for:
  - Finding references
  - Autocompletion

### How to Disable IntelliSense in C/C++ Extension and Use Clangd

1. Add the following lines to your `settings.json`:

   ```json
   "C_Cpp.intelliSenseEngine": "disabled",

   "clangd.path": "/path/to/your/clangd",
   "clangd.arguments": [
     "-log=verbose",
     "-pretty",
     "--background-index",
     //"--query-driver=/bin/arm-buildroot-linux-gnueabihf-g++", // for cross compile usage
     "--compile-commands-dir=/path/to/your/compile_commands_dir/"
   ]
   ```

2. 📝 **Note**: The directory `/path/to/your/compile_commands_dir/` must contain the `compile_commands.json` file.

---

## 📝 Additional Notes on Clangd

- If you generate `compile_commands.json` in individual folders using 🪱 `compiledb make`, you **do not need** to specify `--compile-commands-dir`.
- 🔧 **Clangd Mechanism**:
  - Clangd automatically searches **parent directories** for the `compile_commands.json` file if it is not found in the current folder.
- **Options**:
  - Generate `compile_commands.json` **in each folder** (individually), or
  - Generate it **once in a parent folder** (works globally for all child folders).
- Use `clangd.arguments` **only** if you need to explicitly override the file location.

---

## 🆚 Comparison: compiledb vs bear vs intercept-build

**Reference**: https://www.reddit.com/r/neovim/comments/112lpm5/comment/j8luxcv/

- **compiledb** is faster than **bear** and does not require a rebuild.

  🪱 compiledb ; Generate a Clang compilation database for Make-based build systems

### Tools Overview

- **❌ bear**: Build EAR; generates compilation database for clang tooling
  - **Downside**: Requires a full build.
  - **Note**: `compiledb` is faster.

### Testing and Results

#### 🧪 intercept-build (included in clang-tools)

- Command:
  ```bash
  intercept-build make
  make clean; rm compile_commands.json
  ```
- Result:
  - IntelliSense does **not work**.

#### 🧪 bear

**Reference**: https://github.com/rizsotto/Bear

- Command:
  ```bash
  bear -- make
  make clean; rm compile_commands.json
  ```
- Result:
  - IntelliSense **works**.
  - Applied only to a **single module directory**.

#### 🧪 compiledb

- Command:
  ```bash
  compiledb -- make
  make clean; rm compile_commands.json
  ```
- Result:
  - IntelliSense **works**.
  - Applied only to a **single module directory**.

### ➡️ Final Choice: compiledb

- `compiledb` is faster than `bear` and does not require a rebuild.
- For generating `compile_commands.json`, `compiledb` is the preferred tool.

---

## ☑️ (issue); Dry-run Make Does Not Work for Kernel Builds

### Problem Description

- Errors occur during a **dry-run make** (`make -n`) when generating `compile_commands.json`:
  ```
  make[3]: *** No rule to make target '/home/wbfw109v2/repos/synergy-hub/study/bsp_study/raspberry_pi/drivers/p106_led/modules.order', needed by '/home/wbfw109v2/repos/synergy-hub/study/bsp_study/raspberry_pi/drivers/p106_led/Module.symvers'.
  make[2]: *** [/home/wbfw109v2/repos/kernels/raspberry_pi/Makefile:1873: modpost] Error 2
  make[1]: *** [Makefile:234: __sub-make] Error 2
  make: *** [Makefile:12: dryrun] Error 2
  ```

### Why Does It Require a Build?

1. **Build Command Collection Method**

   - Both `compiledb` and `bear` record the build commands to generate `compile_commands.json`.
   - During this process:
     - **Dependency checks** and **command execution** are required.
     - In a **dry-run (`make -n`) state**, file dependencies are **not created**, causing errors.

2. **Kernel Module Build Characteristics**

   - Kernel builds require intermediate files:
     - `modules.order`
     - `Module.symvers`
   - In a dry-run (`make -n`), these files are **not generated**, which leads to build errors.

   - `make -n`: Dry-run execution **prints commands only** (no file generation).
     - Result: Incomplete and fails.

---

## Summary

- Disable Microsoft's C/C++ IntelliSense and use `clangd` for a better experience.
- For generating `compile_commands.json`, **compiledb** is faster than `bear`.
- Kernel module builds require an actual build due to intermediate file dependencies.
- Use tools like `compiledb` or `bear` carefully in such scenarios.

➡️ generate_clangdb.fish
