#include "iot_server.h"
#include <vector>
#include <string>

int main() {
    iot_server();

    std::vector<std::string> vec;
    vec.push_back("test_package");

    iot_server_print_vector(vec);
}
