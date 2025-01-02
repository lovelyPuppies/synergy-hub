#ifndef TAB2SOCKETCLIENT_H
#define TAB2SOCKETCLIENT_H

#include <QWidget>
#include <QTime>
#include "socketclient.h"

namespace Ui {
class Tab2SocketClient;
}

class Tab2SocketClient : public QWidget
{
    Q_OBJECT
private:
    Ui::Tab2SocketClient *ui;
    SocketClient *pSocketClient;

public:
    explicit Tab2SocketClient(QWidget *parent = nullptr);
    ~Tab2SocketClient();

signals:
    void ledWriteSig(int);
    void setDialValueSig(int);

private slots:
    void on_pPBserverConnect_clicked(bool checked);
    void socketRecvUpdateSlot(QString);
    void on_pPBsendButton_clicked();
    void slotSocketSendDataDial(int);
};

#endif // TAB2SOCKETCLIENT_H
