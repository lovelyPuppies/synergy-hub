#include "tab2socketclient.h"
#include "ui_tab2socketclient.h"

Tab2SocketClient::Tab2SocketClient(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Tab2SocketClient)
{
    ui->setupUi(this);
    ui->pPBsendButton->setEnabled(false);
    pKeyboard = new Keyboard();
    pSocketClient = new SocketClient(this);
    connect(ui->pLErecvId,SIGNAL(selectionChanged()),this, SLOT(keyboardSlot()));
    connect(ui->pLEsendData,SIGNAL(selectionChanged()),this, SLOT(keyboardSlot()));
    connect(pSocketClient,SIGNAL(sigSocketRecv(QString)), this, SLOT(socketRecvUpdateSlot(QString)));
}

Tab2SocketClient::~Tab2SocketClient()
{
    delete ui;
}

void Tab2SocketClient::on_pPBserverConnect_clicked(bool checked)
{
    bool bOk;
    if(checked)
    {
        pSocketClient->slotConnectToServer(bOk);
        if(bOk)
        {
            ui->pPBserverConnect->setText("서버 해제");
            ui->pPBsendButton->setEnabled(true);
        }
    }
    else
    {
        pSocketClient->slotClosedByServer();
        ui->pPBserverConnect->setText("서버 연결");
        ui->pPBsendButton->setEnabled(false);
    }
}

void Tab2SocketClient::socketRecvUpdateSlot(QString strRecvData)
{
    QTime time = QTime::currentTime();
    QString strTime = time.toString();
    strRecvData.chop(1);    //'\n' 제거
    strTime = strTime + " " + strRecvData;
    ui->pTErecvData->append(strTime);

    strRecvData.replace("[","@");
    strRecvData.replace("]","@");    // [KSH_QT]LED@0xff  ==> @KSH_QT@LED@0xff
    QStringList qList = strRecvData .split("@");
    if(qList[2].indexOf("LED") == 0)
    {
        bool bOk;
        int ledNo = qList[3].toInt(&bOk,16);
        if(bOk)
            emit ledWriteSig(ledNo);
    }
    else if((qList[2].indexOf("LAMP") == 0) || (qList[2].indexOf("GAS") == 0))
    {
         emit tab3RecvDataSig(strRecvData);
    }
    else if(qList[2].indexOf("SENSOR") == 0)
    {
         emit tab4RecvDataSig(strRecvData);
    }
}

void Tab2SocketClient::on_pPBsendButton_clicked()
{
    QString strRecvId = ui->pLErecvId->text();
    QString strSendData = ui->pLEsendData->text();
    if(!strSendData.isEmpty())
    {
        if(strRecvId.isEmpty())
            strSendData = "[ALLMSG]"+strSendData;
        else
            strSendData = "["+strRecvId+"]"+strSendData;
        pSocketClient->slotSocketSendData(strSendData);
        ui->pLEsendData->clear();
    }
}

void Tab2SocketClient::keyboardSlot()
{
    QLineEdit *pQLineEdit = (QLineEdit *)sender();
    pKeyboard->setLineEdit(pQLineEdit);
    pKeyboard->show();
}

SocketClient * Tab2SocketClient::getpSocketClient()
{
    return pSocketClient;
}
