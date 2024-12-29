/**
 * @file main.cpp
 * @brief Entry point for the example project.
 */

#include "math_operations.h"
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
