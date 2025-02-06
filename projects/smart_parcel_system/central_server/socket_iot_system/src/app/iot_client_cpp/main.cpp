#include "iot_client_cpp.h"
#include <vector>
#include <string>

int main() {
    iot_client();

    std::vector<std::string> vec;
    vec.push_back("test_package");

    iot_client_print_vector(vec);
}
