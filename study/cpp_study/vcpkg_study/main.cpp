#include <argon2.h>
#include <boost/asio.hpp>
#include <boost/asio/use_awaitable.hpp>
#include <boost/redis.hpp>
#include <boost/redis/src.hpp>
#include <cassert>
#include <fmt/color.h>
#include <fmt/core.h>
#include <iostream>
#include <mariadb/conncpp.hpp>
#include <math.h>
#include <spdlog/spdlog.h>

int cmake_options_set();
int mariadb_cpp_test();
int boost_redis_test();

int main() {
  // cmake_options_set();
  // mariadb_cpp_test();
  boost::redis::config redis_cfg;
  redis_cfg.addr.host = "127.0.0.1";
  redis_cfg.addr.port = "6379";

  // boost_redis_test();

  std::cout << 100 << std::endl;
  return 0;
}
auto co_main(boost::redis::config const &cfg) -> boost::asio::awaitable<void> {
  auto redis_connection = std::make_shared<boost::redis::connection>(
      co_await boost::asio::this_coro::executor);
  redis_connection->async_run(
      cfg, {}, boost::asio::consign(boost::asio::detached, redis_connection));

  // A request containing only a ping command.
  boost::redis::request request;
  request.push("PING", "Hello world");

  // Response object.
  boost::redis::response<std::string> response;

  // Executes the request.
  co_await redis_connection->async_exec(request, response,
                                        boost::asio::use_awaitable);
  redis_connection->cancel();

  std::cout << "PING: " << std::get<0>(response).value() << std::endl;
}
int boost_redis_test() { return 0; }

int mariadb_cpp_test() {
  try {
    // Instantiate Driver
    sql::Driver *driver = sql::mariadb::get_driver_instance();

    // Configure Connection
    sql::SQLString url("jdbc:mariadb://localhost:3306/smart_pkg_db");
    sql::Properties properties(
        {{"user", "wbfw109v2_dev"}, {"password", "wbfw109v2_dev"}});

    // Establish Connection
    std::unique_ptr<sql::Connection> db_connection(
        driver->connect(url, properties));
    db_connection->close();

  } catch (sql::SQLException &e) {
    std::cerr << "Error Connecting to MariaDB Platform: " << e.what()
              << std::endl;
    // Exit (Failed)
    return 1;
  }
  return 0;
}

int cmake_options_set() {
  double y = sqrt(9.0);
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
