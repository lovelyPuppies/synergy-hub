// clang++-17 -std=c++20 -o cpp.out cpp.cpp
/*
nc localhost 1234
*/
#include "iot_server.hpp"
#include "protobuf_c/smart_pkg_delivery.pb.h"
#include "protobuf_cpp/smart_pkg_delivery.pb.h"
#include <boost/asio.hpp>
#include <iostream>
#include <memory>
#include <thread>

namespace iot {
using boost::asio::ip::tcp;

// 🎱 Session class: Handles individual client communication.
//    A Session object is created when a client connects to the server
class Session : public std::enable_shared_from_this<Session> {
public:
  explicit Session(tcp::socket socket) : socket_(std::move(socket)) {}

  // 🎱 Entrypoint
  void start() { doRead(); }

private:
  tcp::socket socket_;
  char buffer_[1024];

  void doRead() {
    // ❔💡 Ensuring Object Lifetime in Asynchronous Execution
    //    `async_read_some()` is an asynchronous function, meaning it returns immediately.
    //    However, before the asynchronous operation completes, the `Session` object might be destroyed.
    //    By using `self(shared_from_this())`, we create a `shared_ptr` that keeps the object alive.
    //      This `shared_ptr` is then captured in the callback, ensuring the object is not destroyed before the asynchronous operation completes.
    auto self(shared_from_this());
    // 🧩 [Proactor Pattern] 3. Asynchronous Operation (Operation-specific actor)
    socket_.async_read_some(
        boost::asio::buffer(buffer_),
        // 🧩 [Proactor Pattern] 5. Completion Handler (Operation-specific actor)
        [this, self](boost::system::error_code ec, std::size_t length) {
          //
          if (!ec) {
            std::string received_data(buffer_, length);
            std::string response_data = processProtobufMessage(received_data);
            doWrite(length);
          }
        });
  }

  std::string processProtobufMessage(const std::string &data) {
    smart_pkg_delivery::WrapperMsg wrapper_msg;

    if (!wrapper_msg.ParseFromString(data)) {
      std::cerr << "Protobuf 메시지 디코딩 실패!" << std::endl;
      return "ERROR: INVALID PROTOBUF MESSAGE";
    }

    // `oneof` 필드 판별
    switch (wrapper_msg.msg_type_case()) {
    case smart_pkg_delivery::WrapperMsg::kRequest: {
      const auto &request = wrapper_msg.request();
      std::cout << "📌 Request 수신!" << std::endl;
      std::cout << "  - Source: " << request.src_name()
                << " (ID: " << request.src_id() << ")" << std::endl;
      std::cout << "  - Destination: " << request.dest_name()
                << " (ID: " << request.dest_id() << ")" << std::endl;

      switch (request.request_type_case()) {
      case smart_pkg_delivery::Request::kGetPkgInfosRequest:
        std::cout << "  - Type: GetPkgInfosRequest" << std::endl;
        break;
      case smart_pkg_delivery::Request::kSetElevatorStatusRequest:
        std::cout << "  - Type: SetElevatorStatusRequest" << std::endl;
        break;
      case smart_pkg_delivery::Request::kMoveDeliveryRobotRequest:
        std::cout << "  - Type: MoveDeliveryRobotRequest" << std::endl;
        break;
      case smart_pkg_delivery::Request::REQUEST_TYPE_NOT_SET:
        std::cerr << "⚠️ Request 타입이 설정되지 않음!" << std::endl;
        return "ERROR: INVALID REQUEST TYPE";
      }
      break;
    }
    case smart_pkg_delivery::WrapperMsg::kResponse: {
      const auto &response = wrapper_msg.response();
      std::cout << "📩 Response 수신!" << std::endl;
      std::cout << "  - Source: " << response.src_name()
                << " (ID: " << response.src_id() << ")" << std::endl;
      std::cout << "  - Destination: " << response.dest_name()
                << " (ID: " << response.dest_id() << ")" << std::endl;

      // ✅ AckStatus에 따라 출력
      std::cout << "  - Ack Status: ";
      switch (response.ack_status().code()) {
      case smart_pkg_delivery::AckStatus::ACK_RECEIVED:
        std::cout << "ACK_INVALID";
        break;
      case smart_pkg_delivery::AckStatus::ACK_INVALID:
        std::cout << "ACK_RECEIVED";
        break;
      default:
        std::cout << "UNKNOWN_ACK_STATUS";
        break;
      }
      std::cout << std::endl;

      // ✅ ExecutionStatus에 따라 출력
      std::cout << "  - Execution Status: ";
      switch (response.execution_status().code()) {
      case smart_pkg_delivery::ExecutionStatus::SUCCESS:
        std::cout << "EXEC_PENDING";
        break;
      case smart_pkg_delivery::ExecutionStatus::FAILED:
        std::cout << "EXEC_COMPLETED";
        break;
      default:
        std::cout << "UNKNOWN_EXECUTION_STATUS";
        break;
      }
      std::cout << std::endl;

      break;
    }

    case smart_pkg_delivery::WrapperMsg::kNodeEvent: {
      const auto &event = wrapper_msg.node_event();
      std::cout << "⏬ NodeEvent 수신!" << std::endl;
      std::cout << "  - Source: " << event.src_name()
                << " (ID: " << event.src_id() << ")" << std::endl;
      std::cout << "  - Destination: " << event.dest_name()
                << " (ID: " << event.dest_id() << ")" << std::endl;

      switch (event.event_type_case()) {
      case smart_pkg_delivery::NodeEvent::kPkgArrivalEvent:
        std::cout << "  - Type: PkgArrivalEvent" << std::endl;
        break;
      case smart_pkg_delivery::NodeEvent::kElevatorStatusEvent:
        std::cout << "  - Type: ElevatorStatusEvent" << std::endl;
        break;
      case smart_pkg_delivery::NodeEvent::kDeliveryStatusEvent:
        std::cout << "  - Type: DeliveryStatusEvent" << std::endl;
        break;
      case smart_pkg_delivery::NodeEvent::EVENT_TYPE_NOT_SET:
        std::cerr << "⚠️ Event 타입이 설정되지 않음!" << std::endl;
        return "ERROR: INVALID EVENT TYPE";
      }
      break;
    }

    case smart_pkg_delivery::WrapperMsg::MSG_TYPE_NOT_SET:
      std::cerr << "⚠️ WrapperMsg의 msg_type이 설정되지 않음!" << std::endl;
      return "ERROR: INVALID WRAPPER MESSAGE TYPE";

    default:
      std::cerr << "⚠️ Error: 알 수 없는 메시지 타입!" << std::endl;
      return "ERROR: UNKNOWN MESSAGE TYPE";
    }
    // 그대로 다시 전송 (에코)
    std::string encoded_message;
    // if (!message.SerializeToString(&encoded_message)) {
    //   std::cerr << "Protobuf 메시지 직렬화 실패!" << std::endl;
    //   return "ERROR: SERIALIZATION FAILED";
    // }

    return encoded_message;
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

// 🎱 Server class: Accepts client connections and creates a new Session to handle communication with each client.
Server::Server(boost::asio::io_context &io_context, short port)
    : acceptor_(io_context, tcp::endpoint(tcp::v4(), port)) {
  // 🧩 [Proactor Pattern] 1. Proactive Initiator (Operation-specific actor)
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

// 🎱
void start_iot_server() {
  try {
    // 🧩 [Proactor Pattern] 2. Asynchronous Operation Processor (Standardized actor)
    boost::asio::io_context io_context;
    Server server(io_context, 1234);

    // std::cout << "Hello!!!!!!!!!!\n";

    unsigned int thread_count = std::thread::hardware_concurrency();
    thread_count = (thread_count > 1) ? (thread_count / 2) : 1;

    std::vector<std::thread> threads;
    for (unsigned int i = 0; i < thread_count; ++i) {
      threads.emplace_back([&io_context]() {
        // 🧩 [Proactor Pattern] 4. Completion Dispatcher (Standardized actor)
        io_context.run();
      });
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

/*
처음 접속할 때 자기 신원 고정.
DB 수정

* 시나리오 구체화: Draft 📅 2025-01-24 00:03:23
  📝 Note
    - 각 노드는 상대 노드로부터 명령을 수신받았을 때, "성공적"으로 수신 받았음을 사대 노드에게 알려야 한다. (ACK) 그 이후에 다음 절차를 진행해야 함.
    - 중앙 서버는 ROS 서버와 일반 소켓 서버를 의미한다.
      - 터틀봇과 통신하는 서버는 ROS Master 서버이다. (Action 방식)
      - ROS Master 서버는 라즈베리파이의 소켓 서버에 의한 제어를 받는다.


  <시나리오>
    1. 택배 보관
      - [택배기사] 무인보관함에 택배 보관
      - [무인보관함] 서버에 택배 도착 알림 (OCR)      // 서버는 이 값을 DB 에 저장.

    2. 택배 전달
      - [사용자] 서버에게 사용자에게로 택배 배송 명령 전달
        - [서버] 무인보관함에 배달 로봇에 택배 적재 명령    // 어느 배달 로봇에게 명령을 주는지는 서버에서 관리. ❓ 만약 택배로봇이 2대 이상이라면, 택배로봇 자동정렬 기능이 들어가야 할수도
          - [무인보관함] 배달 로봇 위에 택배 적재
          - [배달 로봇] 🚥 서버에게 택배 정상적으로 적재됨 전달. 이벤트 기반.    // 센서로 적재 감지 (e.g. 적외선 센서)

        - [서버] 배달 로봇에게 택배 배송 지시             // 어느 주소의 엘레베이터로 이동할 것인지 함께 전달
          - [배달 로봇] 엘레베이터 앞으로 이동 후, 🚥 서버에 자신의 도착 상태 전달.


        - [서버] 엘레베이터에게 1층 도착 명령             // 예외 처리. 배달지가 1층인 경우. 엘레베이터 노드와의 통신은 필요 없다. 다른 알고리즘 필요.
          - [엘레베이터] 1층으로 이동 및 문 개방 명령 수신, 🚥 서버에 자신의 도착 상태 및 문 개폐 여부 전달.    // 엘레베이터 노드는 각 명령을 차례대로 받고, "이동" 이 완전히 끝난 다음에 "개방" 을 해야 한다.

        - 🅰️ [서버] 엘레베이터와 배달 로봇 간의 동기화.
          - [엘레베이터] 배달 로봇이 엘레베이터에 들어갈 때까지 ⏲️ 서버로부터 문 개방 명령을 주기적으로 받음
          - [배달 로봇] 서버로부터 엘레베이터 안으로 이동 명령을 받고 이동. 🚥 이동 후 서버에 배달 로봇 도착 상태 전달.
          - [엘레베이터] 서버로부터 폐문 명령을 받음.       // 다른 사람들이 함께 탈 수 있기 때문에 폐문 명령은 한 번만 내려야 한다.
            이후 🚥 문이 닫히면, 서버에 자신의 상태 전달. 동시에 해당 층수로 이동.
            이후 🚥 해당 층수에 도착하고 문이 열리면, 서버에 자신의 현재 층수와 문 개폐 상태 전달.  // "도착" 상태 변경이 먼저이므로 도착 상태, 층수 상태 순서로 보내야 한다. 그리고 이 경우는, 서버로부터 개방 명령을 받아서 열리는 것이 아니여야 한다.
          - [엘레베이터] 배달 로봇이 택배 주소 앞으로 가서 배달이 끝나고, 다시 엘레베이터 위로 들어갈 때까지 ⏲️ 서버로부터 문 개방 명령을 주기적으로 받음
          - [배달 로봇] 서버로부터 택배 주소 앞으로 이동 명령을 받고 이동.
            이후 🚥 사진을 찍어서 서버에 전달 후, 서버로부터 엘레베이터로 이동 명령을 받음.
          - [엘레베이터] 서버로부터 폐문 명령을 받음.

    3. 배달 로봇 복귀
      - ... 반대로 과정 진행

    TODO: 
      NanoPB 통신 테스트
      ROS Master 와 소켓 서버간 통신 (IPC) 테스트.
      구현


  * DB 사양 및 통신규격 정의: Draft 2
    * Requirements
      - 대부분의 모든 통신은 중앙 서버인 이 라즈베리파이 서버를 거치도록 한다.
      - Database 에는 "한글" (유니코드) 문자를 저장할 수 있어야 한다.
      - 각 노드로부터 메시지를 받고 데이터와 함께 상태를 받아야 하며, 처리결과에 대한 상태를 함께 전달해주어야 한다.
      - 고급 임베디드 장치인 라즈베리파이, 아두이노 뿐 아니라, 자원이 제한적인 STM32 에서도 성능 문제 없이 작동해야 한다.
      - ROS 1 noetic 환경에서도 호환성을 보장해야 한다.

    * Components
      - 💾 Database: MariaDB
        📝
          - "🧪": 테스트 중 생략 가능한 컬럼

      - Socket Server
      - ROS Master Node 📰 (Doing...) 

    * Message Format
      {
        "source": "client_name",
        "destination": "target_name",
        "command": "command_name",
        "payload": {
          "key1": "value1",
          "key2": "value2"
        },
        "status": "hub/1.0 0 OK",   // Format: protocol, " ", status code, " ", "message"
        "message": "",
        "links": [
          { "rel": "self", "href": "/api/current_state" },
          { "rel": "update", "href": "/api/update_state" }
        ]
      }

      command := ["get", "set", "create", "read" "update", "delete", ...]
        📝 CRUD (create, read, update, delete) 는 DB 에 대한 Query. 그 외에는 메모리에서만 유지되는 정보에 대한 쿼리.

    *🧪 Optimization
      - Maximum Message Size is 1460 bytes
        Ethernet Frame Total Size = 1518 bytes
          - Ethernet MTU (1500 bytes)
          + Ethernet Header (14 bytes)
          + FCS (Footer) (4 bytes)              // Frame Check Sequence
          --------------------------------------
          Total = 1518 bytes (Maximum Ethernet Frame Size)

        TCP MSS (Maximum Segment Size) = 1460 bytes
          - Ethernet MTU (1500 bytes)
          - IP Header (20 bytes)
          - TCP Header (20 bytes)
          --------------------------------------
          TCP MSS = 1460 bytes (Maximum Application Data Size)
      - 🛍️ e.g. 289 bytes for the message format (including whitespaces)

    1. 📰
      syntax = "proto3"; // Protobuf 버전 3 사용

      // 메시지 정의
      message Message {
        string source = 1;                // 메시지를 보낸 노드
        string destination = 2;           // 메시지를 받을 노드
        string command = 3;               // 수행할 명령
        Payload payload = 4;              // 명령에 필요한 데이터
        repeated Link links = 5;          // 선택적: 다음 가능한 작업 정보
      }

      // Payload 메시지 정의
      message Payload {
        string key1 = 1;                  // 첫 번째 데이터 키
        string key2 = 2;                  // 두 번째 데이터 키
      }

      // Link 메시지 정의
      message Link {
        string rel = 1;                   // 링크의 관계 (예: self, update 등)
        string href = 2;                  // 링크 URL
      }

Database
❓ Q&A
  소켓 통신으로 연결된 클라이언트의 장치 OS 이름을 알 수 있는가?
    X. 고수준 통신의 웹 서버/클라이언트 구조의 경우 HTTP 헤더부터 알 수 있지만 저수준의 소켓 통신에서는 알 수 없다.
Network socket


지금 자율주행 택배 시스템을 만들고 있는데, 라즈베리파이 서버에서 원거리에 있는 ROS 터틀봇 (OpenCR), 엘레베이터 (STM32), 택배보관함(STM or rasberry), 머신러닝 처리용 PC까지 모두 하나의 네트워크로 묶어야 해. 대부분 라즈베리파이 서버를 통과할 예정이야. 라즈베리파이 서버가 ROst master server 와, 소켓 서버가 둘 다 돌아가야 해.



*/