/*
🧪 Test
  cd /home/wbfw109/repos/synergy-hub/study/cpp_study/p_doxygen_test
  doxygen -g
  doxygen Doxyfile

  file://wsl.localhost/Ubuntu/home/wbfw109/repos/synergy-hub/study/cpp_study/p_doxygen_test/docs/html/index.html
*/

/**
 * @file main.cpp
 * @brief Entry point for the example project.
 */

#include "math_operations.hpp"
#include <iostream>

/**
 * @brief Main function of the project.
 * @return Exit code.
 */
int main() {
  int a = 5, b = 3;

  std::cout << "Adding " << a << " and " << b << ": " << add(a, b) << std::endl;
  std::cout << "Subtracting " << b << " from " << a << ": " << subtract(a, b)
            << std::endl;

  return 0;
}
