#pragma once // Include guard

// 🪱 asio: Asynchronous Input/Output
#include <boost/asio.hpp>
#include <string>
#include <vector>

namespace iot {

class Server {
public:
  Server(boost::asio::io_context &io_context, short port);
  ~Server() = default;

private:
  void doAccept();
  boost::asio::ip::tcp::acceptor acceptor_;
};

// 🚀 유틸리티 함수 선언
void start_iot_server();
void print_vector(const std::vector<std::string> &strings);

} // namespace iot
