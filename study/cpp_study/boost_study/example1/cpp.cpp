
#include <boost/asio.hpp>
#include <iostream>
#include <memory>

using boost::asio::ip::tcp;

class Session : public std::enable_shared_from_this<Session> {
public:
    explicit Session(tcp::socket socket) : socket_(std::move(socket)) {}

    void start() {
        doRead();
    }

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
            [this, self](boost::system::error_code ec, std::size_t /*length*/) {
                if (!ec) {
                    doRead();
                }
            });
    }
};

class Server {
public:
    Server(boost::asio::io_context& io_context, short port)
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
        Server server(io_context, 8080);
        io_context.run();
    } catch (std::exception& e) {
        std::cerr << "Exception: " << e.what() << "\n";
    }
    return 0;
}
        