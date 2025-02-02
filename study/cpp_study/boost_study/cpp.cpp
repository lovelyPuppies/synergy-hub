#include <boost/asio.hpp>
#include <iostream>

using boost::asio::ip::tcp;

int main() {
  try {
    // io_context 객체 생성: 비동기 I/O 작업을 관리합니다.
    boost::asio::io_context io_context;

    // 서버의 TCP 소켓을 수신 대기 상태로 설정합니다.
    tcp::acceptor acceptor(io_context, tcp::endpoint(tcp::v4(), 12345));

    std::cout << "서버가 포트 12345에서 실행 중입니다..." << std::endl;

    while (true) {
      // 클라이언트의 연결을 수락합니다.
      tcp::socket socket(io_context);
      acceptor.accept(socket);

      // 클라이언트에게 보낼 메시지를 작성합니다.
      std::string message = "Hello from server!\n";

      // 메시지를 클라이언트로 전송합니다.
      boost::system::error_code ignored_error;
      boost::asio::write(socket, boost::asio::buffer(message), ignored_error);
    }
  } catch (std::exception &e) {
    std::cerr << "오류: " << e.what() << std::endl;
  }

  return 0;
}
