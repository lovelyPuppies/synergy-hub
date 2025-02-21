// sudo apt install mingw-w64
// clang++ --target=x86_64-w64-mingw32 -o cpp2.exe cpp2.cpp
// 🧪📵 clang++ --target=x86_64-pc-windows-msvc -o cpp2.exe cpp2.cpp
// scp wbfw109v2@<ip>:... ...
/*

❯ file cpp2.exe
cpp2.exe: PE32+ executable (console) x86-64, for MS Windows, 19 sections

❯ wine cpp2.exe
00f0:err:module:import_dll Library libstdc++-6.dll (which is needed by L"Z:\\home\\wbfw109v2\\repos\\synergy-hub\\temp\\cpp2.exe") not found
00f0:err:module:loader_init Importing dlls for L"Z:\\home\\wbfw109v2\\repos\\synergy-hub\\temp\\cpp2.exe" failed, status c0000135
*/
#include <iostream>

int main() {
  std::cout << "Hello world" << std::endl;

  return 0;
}
