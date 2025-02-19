#include <fmt/color.h>
#include <fmt/core.h>

int main() {
  fmt::print(fmt::fg(fmt::color::green), "Hello, {}!\n", "Vcpkg with CMake");
  fmt::print(fmt::fg(fmt::color::red) | fmt::emphasis::bold,
             "Error: Something went wrong!\n");
  fmt::print(fmt::fg(fmt::color::blue) | fmt::emphasis::italic,
             "Info: Running in debug mode\n");
  return 0;
}
