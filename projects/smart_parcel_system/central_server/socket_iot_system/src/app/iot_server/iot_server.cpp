// clang++ -std=c++23 -o cpp.out cpp.cpp
/*
nc localhost 1234

*/
#include "iot_server.hpp"
#include <boost/asio.hpp>
#include <iostream>
#include <memory>
#include <thread>

namespace iot {
using boost::asio::ip::tcp;

// 🚀 Session 클래스 (내부 클래스)
class Session : public std::enable_shared_from_this<Session> {
public:
  explicit Session(tcp::socket socket) : socket_(std::move(socket)) {}

  void start() { doRead(); }

private:
  tcp::socket socket_;
  char buffer_[1024];

  void doRead() {
    auto self(shared_from_this());
    socket_.async_read_some(
        boost::asio::buffer(buffer_),
        [this, self](boost::system::error_code ec, std::size_t length) {
          if (!ec) {
            doWrite(length);
          }
        });
  }

  void doWrite(std::size_t length) {
    auto self(shared_from_this());
    boost::asio::async_write(
        socket_, boost::asio::buffer(buffer_, length),
        [this, self](boost::system::error_code ec, std::size_t) {
          if (!ec) {
            doRead();
          }
        });
  }
};

// 🚀 Server 클래스 구현 (정의는 .cpp에서!)
Server::Server(boost::asio::io_context &io_context, short port)
    : acceptor_(io_context, tcp::endpoint(tcp::v4(), port)) {
  doAccept();
}

void Server::doAccept() {
  acceptor_.async_accept(
      [this](boost::system::error_code ec, tcp::socket socket) {
        if (!ec) {
          std::make_shared<Session>(std::move(socket))->start();
        }
        doAccept();
      });
}

// 🚀 IoT 서버 실행 함수
void start_iot_server() {
  try {
    boost::asio::io_context io_context;
    Server server(io_context, 1234);

    unsigned int thread_count = std::thread::hardware_concurrency();
    thread_count = (thread_count > 1) ? (thread_count / 2) : 1;

    std::vector<std::thread> threads;
    for (unsigned int i = 0; i < thread_count; ++i) {
      threads.emplace_back([&io_context]() { io_context.run(); });
    }

    for (auto &t : threads) {
      t.join();
    }
  } catch (std::exception &e) {
    std::cerr << "Exception: " << e.what() << "\n";
  }
}

// 🚀 벡터 출력 함수
void print_vector(const std::vector<std::string> &strings) {
  for (const auto &str : strings) {
    std::cout << str << std::endl;
  }
}

} // namespace iot
