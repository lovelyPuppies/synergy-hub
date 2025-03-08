#pragma once // Include guard

// 🪱 asio: Asynchronous Input/Output
#include <boost/asio.hpp>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

namespace iot {

class Session;
class Server {
public:
  Server(boost::asio::io_context &io_context, short port);
  ~Server() = default;

  // ⚙️
  void registerClient(const std::string &name,
                      std::shared_ptr<Session> session);
  void sendMessageToClient(const std::string &dest_name,
                           const std::string &message) const;

private:
  void doAccept();
  boost::asio::ip::tcp::acceptor acceptor_;

  // ⚙️
  std::unordered_map<std::string, std::shared_ptr<Session>> clients_;
  std::mutex clients_mutex_;
};

// 🎱 Utilities
void start_iot_server();
void print_vector(const std::vector<std::string> &strings);

} // namespace iot
