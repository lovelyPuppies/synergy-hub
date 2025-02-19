```bash
#!/usr/bin/env fish

# ⚙️ Adjust your environment variable for cmake
./setup_dev_env.fish

# https://learn.microsoft.com/en-us/vcpkg/users/buildsystems/cmake-integration
# vcpkg does not automatically add any include or links paths into your project. To use a header-only library you can use find_path() which will correctly work on all platforms:
vcpkg install fmt:x64-linux fmt:arm64-linux

-- Building arm64-linux-dbg
-- Building arm64-linux-rel
-- Fixing pkgconfig file: /home/wbfw109v2/repos/vcpkg/packages/fmt_arm64-linux/lib/pkgconfig/fmt.pc
-- Fixing pkgconfig file: /home/wbfw109v2/repos/vcpkg/packages/fmt_arm64-linux/debug/lib/pkgconfig/fmt.pc
-- Installing: /home/wbfw109v2/repos/vcpkg/packages/fmt_arm64-linux/share/fmt/usage
-- Installing: /home/wbfw109v2/repos/vcpkg/packages/fmt_arm64-linux/share/fmt/copyright

-- Building x64-linux-dbg
-- Building x64-linux-rel
-- Fixing pkgconfig file: /home/wbfw109v2/repos/vcpkg/packages/fmt_x64-linux/lib/pkgconfig/fmt.pc
-- Fixing pkgconfig file: /home/wbfw109v2/repos/vcpkg/packages/fmt_x64-linux/debug/lib/pkgconfig/fmt.pc
-- Installing: /home/wbfw109v2/repos/vcpkg/packages/fmt_x64-linux/share/fmt/usage
-- Installing: /home/wbfw109v2/repos/vcpkg/packages/fmt_x64-linux/share/fmt/copyright

The package fmt provides CMake targets:

    find_package(fmt CONFIG REQUIRED)
    target_link_libraries(main PRIVATE fmt::fmt)

    # Or use the header-only version
    find_package(fmt CONFIG REQUIRED)
    target_link_libraries(main PRIVATE fmt::fmt-header-only)

# cmake -B build -S /my/project --preset debug


qemu-system-aarch64

qemu-aarch64 -L /usr/aarch64-linux-gnu build/aarch64-linux-gnu/fmt_example
```