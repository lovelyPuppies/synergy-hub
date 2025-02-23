// sudo apt install mingw-w64
// clang++ --target=x86_64-w64-mingw32 -o cpp2.exe cpp2.cpp
// 🧪📵 clang++ --target=x86_64-pc-windows-msvc -o cpp2.exe cpp2.cpp
// scp wbfw109v2@<ip>:... ...
/*
# https://stackoverflow.com/questions/23248989/clang-c-cross-compiler-generating-windows-executable-from-mac-os-x
🧪
export WINSDK_PATH="$HOME/winsdk"
xwin --accept-license splat --preserve-ms-arch-notation --output "$WINSDK_PATH"


clang -o cpp2.exe \
  -target x86_64-pc-windows-msvc \
  -isystem "$WINSDK_PATH/crt/include" \
  -isystem "$WINSDK_PATH/sdk/Include/ucrt" \
  -isystem "$WINSDK_PATH/sdk/Include/shared" \
  -isystem "$WINSDK_PATH/sdk/Include/um" \
  -Xclang --dependent-lib=msvcrt \
  -fuse-ld=lld "-L$WINSDK_PATH/crt/lib/x64" \
  "-L$WINSDK_PATH/sdk/Lib/ucrt/x64" \
  "-L$WINSDK_PATH/sdk/Lib/um/x64" \
  -flto \
  -march=x86-64-v3 \
  cpp2.cpp



wbfw109v2@iot-04:~/repos/synergy-hub/temp$ wine cpp2.exe
Hello world







🧪
clang++ --target=x86_64-pc-windows-msvc -fuse-ld=lld -o cpp2.exe cpp2.cpp --sysroot (xwin sysroot)
SYSROOT_PATH=.xwin-cache/splat
clang++ --target=x86_64-pc-windows-msvc -fuse-ld=lld -o cpp2.exe cpp2.cpp \
  --sysroot $SYSROOT_PATH \
  -I$SYSROOT_PATH/crt/include \
  -v

>> ignoring nonexistent directory ".xwin-cache/splat/crt/crt/include"
  ignoring nonexistent directory ".xwin-cache/splat/crt/sdk/include/ucrt"


fd libcpmt.lib .xwin-cache/splat/

❯ xwin -V
xwin 0.6.5

wbfw109v2@iot-04:~/repos/synergy-hub/temp$ fd iostream .xwin-cache/splat/
.xwin-cache/splat/crt/include/iostream
xwin --accept-license download
❯  fd -I -e msi . .xwin-cache/
.xwin-cache/dl/Win11SDK_10.0.26100_headers.msi
.xwin-cache/dl/Win11SDK_10.0.26100_libs_x86_64.msi
.xwin-cache/dl/Win11SDK_10.0.26100_store_headers.msi
.xwin-cache/dl/Win11SDK_10.0.26100_store_headers_onecoreuap.msi
.xwin-cache/dl/Win11SDK_10.0.26100_store_libs.msi
.xwin-cache/dl/Win11SDK_10.0.26100_uap_headers.msi
.xwin-cache/dl/Win11SDK_10.0.26100_x64_headers.msi
.xwin-cache/dl/ucrt.msi
.xwin-cache/unpack/Win11SDK_10.0.26100_headers.msi/
.xwin-cache/unpack/Win11SDK_10.0.26100_libs_x86_64.msi/
.xwin-cache/unpack/Win11SDK_10.0.26100_store_headers.msi/
.xwin-cache/unpack/Win11SDK_10.0.26100_store_headers_onecoreuap.msi/
.xwin-cache/unpack/Win11SDK_10.0.26100_store_libs.msi/
.xwin-cache/unpack/Win11SDK_10.0.26100_uap_headers.msi/
.xwin-cache/unpack/Win11SDK_10.0.26100_x64_headers.msi/
.xwin-cache/unpack/ucrt.msi/
❯ ls -d .xwin-cache/splat/*
.xwin-cache/splat/crt/  .xwin-cache/splat/sdk/



xwin --accept-license unpack
xwin --accept-license list

ls -d ./.xwin-cache/*
❯ file cpp2.exe
cpp2.exe: PE32+ executable (console) x86-64, for MS Windows, 19 sections

❯ wine cpp2.exe
00f0:err:module:import_dll Library libstdc++-6.dll (which is needed by L"Z:\\home\\wbfw109v2\\repos\\synergy-hub\\temp\\cpp2.exe") not found
00f0:err:module:loader_init Importing dlls for L"Z:\\home\\wbfw109v2\\repos\\synergy-hub\\temp\\cpp2.exe" failed, status c0000135

🧪🆗 clang++ -v --target=x86_64-linux-gnu -o cpp2 cpp2.cpp

내 기본 타겟 확인
🧪🆗 ❯ clang --print-target-triple
x86_64-unknown-linux-gnu
🧪🆗 clang++ -v cpp2.cpp -o cpp2


*/
#include <iostream>

int main() {
  std::cout << "Hello world" << std::endl;

  return 0;
}
