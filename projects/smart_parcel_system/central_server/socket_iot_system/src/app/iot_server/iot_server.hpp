
#pragma once // Include guard

#include <boost/asio.hpp>
#include <string>
#include <vector>

namespace iot {

// 🚀 Server 클래스 선언 (정의는 .cpp에서)
class Server {
public:
  Server(boost::asio::io_context &io_context, short port);
  ~Server() = default; // 기본 소멸자

private:
  void doAccept();
  boost::asio::ip::tcp::acceptor acceptor_;
};

// 🚀 유틸리티 함수 선언
void start_iot_server();
void print_vector(const std::vector<std::string> &strings);

} // namespace iot
