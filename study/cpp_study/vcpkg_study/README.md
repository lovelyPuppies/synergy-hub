- 목표
  1. 크로스 컴파일
  2. 크로스 컴파일 (+ 외부 라이브러리 사용)
  3. 크로스 컴파일된 실행파일 디버깅

```bash
#!/usr/bin/env fish

# ⚙️ Adjust your environment variable for cmake
./setup_dev_env.fish

# https://learn.microsoft.com/en-us/vcpkg/users/buildsystems/cmake-integration
# vcpkg does not automatically add any include or links paths into your project. To use a header-only library you can use find_path() which will correctly work on all platforms:

# https://vcpkg.io/en/package/fmt
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
qemu-aarch64 -g 1234 -L /usr/aarch64-linux-gnu build/aarch64-linux-gnu/fmt_example

❯ ls $VCPKG_ROOT/installed/x64-linux/debug/lib
libcrypto.a  libfmtd.a  libmariadb.a@  libmariadbclient.a  libmariadbcpp.a@  libmariadbcpp-static.a  libssl.a  libz.a  pkgconfig/




%VSCode> CMake: Run Without Debugging


# https://github.com/microsoft/vcpkg-docs/blob/main/vcpkg/get_started/get-started-vscode.md
vcpkg new --application
vcpkg add port spdlog
# https://vcpkg.io/en/package/spdlog
# https://github.com/microsoft/vcpkg/issues/18865
vcpkg install --triplet x64-linux
vcpkg install --triplet arm64-linux


The package spdlog provides CMake targets:

    find_package(spdlog CONFIG REQUIRED)
    target_link_libraries(main PRIVATE spdlog::spdlog)

    # Or use the header-only version
    find_package(spdlog CONFIG REQUIRED)
    target_link_libraries(main PRIVATE spdlog::spdlog_header_only)

    
```