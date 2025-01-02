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

    connect(pTab2SocketClient,SIGNAL(ledWriteSig(int)), pTab1DevControl->getpKeyLed(),SLOT(writeLedData(int)));
    connect(pTab1DevControl,SIGNAL(timeoutDialSignal(int)), pTab2SocketClient,SLOT(slotSocketSendDataDial(int)));
    connect(pTab2SocketClient,SIGNAL(setDialValueSig(int)), pTab1DevControl->getpQDial(),SLOT(setValue(int)));

    ui->pTabWidget->setCurrentIndex(1);
}

MainWidget::~MainWidget()
{
    delete ui;
}



