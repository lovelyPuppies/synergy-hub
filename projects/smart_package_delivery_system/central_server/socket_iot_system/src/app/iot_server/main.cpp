#include "iot_server.hpp"
#include <vector>
// TODO: Database ; https://mariadb.com/docs/server/connect/programming-languages/cpp/dml/
#include <mariadb/conncpp.hpp>

int main() {
  iot::start_iot_server();

  std::vector<std::string> vec = {"test_package", "iot_server"};
  iot::print_vector(vec);

  return 0;
}

// int main() {
//   try {
//     boost::asio::io_context io_context;
//     Server server(io_context, 1234);
//     io_context.run();
//   } catch (std::exception &e) {
//     std::cerr << "Exception: " << e.what() << "\n";
//   }
//   return 0;
// }