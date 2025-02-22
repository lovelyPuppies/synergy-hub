#include <cassert>
#include <fmt/color.h>
#include <fmt/core.h>
#include <iostream>
#include <math.h>
#include <spdlog/spdlog.h>

int main() {
  double y = sqrt(9.0); // sqrt() 함수 호출
  std::cout << y << std::endl;
  int x = 0;
#ifdef DEBUG
  fmt::print(fmt::fg(fmt::color::aqua), "{}!\n", "DEBUG is set!");
#endif
  // 🧪 Test
  std::cout << "// Reset Printing Color by adding new line" << std::endl;
  // assert macro is removed on RELEASE mode
  assert(x != 0 && "x should not be 0!");

  fmt::print(fmt::fg(fmt::color::green), "Hello, {}!\n", "Vcpkg with CMake");
  fmt::print(fmt::fg(fmt::color::red) | fmt::emphasis::bold,
             "Error: Something went wrong!\n");
  fmt::print(fmt::fg(fmt::color::blue) | fmt::emphasis::italic,
             "Info: Running in debug mode\n");
  spdlog::info("Hello, {}!", "world");
  spdlog::warn("This is a warning message.");
  spdlog::error("Error code: {}", 404);
  return 0;
}
