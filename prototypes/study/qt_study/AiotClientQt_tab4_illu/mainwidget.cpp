#include "mainwidget.h"
#include "ui_mainwidget.h"

MainWidget::MainWidget(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::MainWidget)
{
    ui->setupUi(this);
    pTab1DevControl = new Tab1DevControl(ui->pTab1);
    ui->pTab1->setLayout(pTab1DevControl->layout());

    pTab2SocketClient = new Tab2SocketClient(ui->pTab2);
    ui->pTab2->setLayout(pTab2SocketClient->layout());

    pTab3ControlPannel = new Tab3ControlPannel(ui->pTab3);
    ui->pTab3->setLayout(pTab3ControlPannel->layout());

    pTab4ChartPlot = new Tab4ChartPlot(ui->pTab4);
    ui->pTab4->setLayout(pTab4ChartPlot->layout());

    connect(pTab2SocketClient,SIGNAL(ledWriteSig(int)), pTab1DevControl->getpKeyLed(),SLOT(writeLedData(int)));
    connect(pTab3ControlPannel,SIGNAL(socketSendDataSig(QString)), pTab2SocketClient->getpSocketClient(),SLOT(slotSocketSendData(QString)));
    connect(pTab2SocketClient,SIGNAL(tab3RecvDataSig(QString)),pTab3ControlPannel,SLOT(tab3RecvDataSlot(QString)));
    connect(pTab2SocketClient,SIGNAL(tab4RecvDataSig(QString)),pTab4ChartPlot,SLOT(tab4RecvDataSlot(QString)));

    ui->pTabWidget->setCurrentIndex(3);
}

MainWidget::~MainWidget()
{
    delete ui;
}

