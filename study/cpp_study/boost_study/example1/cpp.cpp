// clang++ -std=c++23 -o cpp.out cpp.cpp
/*
nc localhost 1234

*/

#include <boost/asio.hpp>
#include <iostream>
#include <memory>
#include <thread>

using boost::asio::ip::tcp;

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
            // std::cout << "[echo] Read request processed by thread: "
            //           << std::this_thread::get_id() << std::endl;
            doWrite(length);
          }
        });
  }

  void doWrite(std::size_t length) {
    auto self(shared_from_this());
    boost::asio::async_write(
        socket_, boost::asio::buffer(buffer_, length),
        [this, self](boost::system::error_code ec, std::size_t /*length*/) {
          if (!ec) {
            // std::cout << "[echo] Write response processed by thread: "
            //           << std::this_thread::get_id() << std::endl;
            doRead();
          }
        });
  }
};

class Server {
public:
  Server(boost::asio::io_context &io_context, short port)
      : acceptor_(io_context, tcp::endpoint(tcp::v4(), port)) {
    doAccept();
  }

private:
  tcp::acceptor acceptor_;

  void doAccept() {
    acceptor_.async_accept(
        [this](boost::system::error_code ec, tcp::socket socket) {
          if (!ec) {
            std::make_shared<Session>(std::move(socket))->start();
          }
          doAccept();
        });
  }
};

int main() {
  try {
    boost::asio::io_context io_context;
    Server server(io_context, 1234);

    // Get hardware's available thread count
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