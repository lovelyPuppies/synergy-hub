# Should Static and Shared Libraries Be Installed in the Same Directory?

📅 Written at 2025-02-01 00:12:49

## ✅ Overview

- Typically, static (.a) and shared (.so or .dylib) libraries are placed in the same directory.
- This is a common convention in Unix-based systems, followed by package managers like Homebrew.
- This simplifies library management and deployment.

🚨

- However, keeping them together may cause issues with tools like clang, Xcode, and build systems such as CMake, Conan, etc.
- If both static and shared libraries exist in the same directory, unintended dynamic linking might occur.

## ❓ Why Can Mixing Static & Shared Libraries in the Same Directory Cause Issues?

### 🔹 1. Compilers Default to Shared Libraries

When using `-lfmt`, compilers prioritize shared libraries (`libfmt.so****`) over static libraries (`libfmt.a****`).

If both versions exist in the same directory, the shared version is used by default.

🛍️ e.g. **Example:**

```sh
g++ main.cpp -lfmt  # Links libfmt.so, not libfmt.a
```

🚨 If you want to force static linking, you must specify the full path:

```sh
g++ main.cpp /path/to/libfmt.a
```

This is inefficient and prone to errors. Separating static & shared libraries into different directories solves this problem.

### 🔹 2. Problems with Xcode & macOS Hardened Runtime

Even if a static library is explicitly linked, Xcode may still select the shared version.

macOS Hardened Runtime enforces extra security on shared libraries, requiring additional signing.

If static libraries are preferred, this behavior can cause unnecessary complexity.

✅ **Solution:** Place static and shared libraries in different directories to ensure proper selection.

### 🔹 3. Conflicts in Build Systems like CMake & Conan

When using `find_package()`, having both `.a` and `.so` files in the same directory may cause ambiguity.

Some package managers (e.g., APT, Homebrew, Conan) already separate static and shared libraries.

🛍️ e.g. **Example:** `libprotobuf-dev` contains `.a` files, while `libprotobuf` contains `.so` files.

✅ **Solution:**

Explicitly configure CMake to look in separate static & shared directories.

```cmake
set(STATIC_LIB_DIR "/opt/protobuf-static/lib")
set(SHARED_LIB_DIR "/opt/protobuf-shared/lib")

target_link_libraries(MyApp PRIVATE ${STATIC_LIB_DIR}/libfmt.a)  # Static linking
# OR
target_link_libraries(MyApp PRIVATE ${SHARED_LIB_DIR}/libfmt.so)  # Shared linking
```

## Should You Separate Static & Shared Libraries?

| Same Directory Works If                                  | 🚀 Separate Directories Are Better If                                                             |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Static & shared libraries have the same build settings   | Build settings differ (e.g., `-fPIC` needed for shared, but not for static)                       |
| Simple build environments (e.g., local development)      | Cross-compilation (ARM, x86_64, etc.) requires different configurations                           |
| CI/CD where managing everything together is easier       | Package managers like APT, Brew, Conan require separate handling                                  |
| `find_package()` in CMake can correctly detect libraries | Some static libraries must be embedded into shared libraries instead of being dynamically linked. |

- Placing static & shared libraries in the same directory is possible, but conflicts may arise depending on the use case.
- In real-world applications, they are usually managed separately for efficiency and predictability. 🚀

## References

- [Why put static and dynamic libraries in the same directory?](https://github.com/orgs/Homebrew/discussions/4672)
