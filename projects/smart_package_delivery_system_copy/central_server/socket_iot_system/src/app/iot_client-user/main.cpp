// #include "iot_client_cpp.h"
// #include <vector>
// #include <string>

// int main() {
//     iot_client();

//     std::vector<std::string> vec;
//     vec.push_back("test_package");

//     iot_client_print_vector(vec);
// }

#include <boost/asio.hpp>
#include <boost/bind/bind.hpp>
#include <iostream>
#include <string>

using boost::asio::ip::tcp;

class AsyncClient {
public:
  AsyncClient(boost::asio::io_context &io_context, const std::string &host,
              const std::string &port, const std::string &client_name)
      : socket_(io_context), resolver_(io_context), client_name_(client_name) {

    tcp::resolver::results_type endpoints = resolver_.resolve(host, port);
    boost::asio::async_connect(socket_, endpoints,
                               boost::bind(&AsyncClient::handle_connect, this,
                                           boost::asio::placeholders::error));
  }

  void send_message(const std::string &dest_name, const std::string &message) {
    std::string full_message = client_name_ + ":" + dest_name + ":" + message;
    boost::asio::async_write(socket_, boost::asio::buffer(full_message),
                             boost::bind(&AsyncClient::handle_write, this,
                                         boost::asio::placeholders::error));
  }

private:
  void handle_connect(const boost::system::error_code &error) {
    if (!error) {
      std::cout << "서버에 연결됨!\n";

      // 클라이언트 이름 전송 (첫 메시지는 클라이언트의 이름)
      boost::asio::async_write(socket_, boost::asio::buffer(client_name_),
                               boost::bind(&AsyncClient::handle_write, this,
                                           boost::asio::placeholders::error));
    } else {
      std::cerr << "연결 실패: " << error.message() << std::endl;
    }
  }

  void handle_write(const boost::system::error_code &error) {
    if (error) {
      std::cerr << "쓰기 실패: " << error.message() << std::endl;
    }
  }

  tcp::socket socket_;
  tcp::resolver resolver_;
  std::string client_name_;
};

int main() {
  try {
    boost::asio::io_context io_context;

    std::string client_name;
    std::cout << "클라이언트 이름 입력: ";
    std::cin >> client_name;

    AsyncClient client(io_context, "127.0.0.1", "1234", client_name);

    std::thread io_thread([&io_context]() { io_context.run(); });

    while (true) {
      std::string dest, msg;
      std::cout << "수신자 이름 입력: ";
      std::cin >> dest;
      std::cout << "메시지 입력: ";
      std::cin.ignore();
      std::getline(std::cin, msg);

      client.send_message(dest, msg);
    }

    io_thread.join();
  } catch (std::exception &e) {
    std::cerr << "예외 발생: " << e.what() << std::endl;
  }

  return 0;
}
