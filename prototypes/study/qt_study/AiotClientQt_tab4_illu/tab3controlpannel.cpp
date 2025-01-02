#include "tab3controlpannel.h"
#include "ui_tab3controlpannel.h"

Tab3ControlPannel::Tab3ControlPannel(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Tab3ControlPannel)
{
    ui->setupUi(this);
    paletteColorOn.setColor(ui->pPBLamp->backgroundRole(),QColor(255,0,0));
    paletteColorOff.setColor(ui->pPBLamp->backgroundRole(),QColor(0,0,255));
    ui->pPBLamp->setPalette(paletteColorOff);
    ui->pPBPlug->setPalette(paletteColorOff);
}

Tab3ControlPannel::~Tab3ControlPannel()
{
    delete ui;
}

void Tab3ControlPannel::on_pPBLamp_clicked(bool checked)
{
    if(checked)
    {
        emit socketSendDataSig("[HM_CON]LAMPON");
    }
    else
    {
        emit socketSendDataSig("[HM_CON]LAMPOFF");
    }
}

void Tab3ControlPannel::on_pPBPlug_clicked(bool checked)
{
    if(checked)
    {
        emit socketSendDataSig("[HM_CON]GASON");
    }
    else
    {
        emit socketSendDataSig("[HM_CON]GASOFF");
    }
}

void Tab3ControlPannel::tab3RecvDataSlot(QString recvData)
{
    QStringList qList = recvData.split("@");    //@KSH_QT@LAMPON
    if(qList[2] == "LAMPON")
    {
        ui->pPBLamp->setIcon(QIcon(":/images/Image/light_on.png"));
        ui->pPBLamp->setPalette(paletteColorOn);

    }
    else if(qList[2] == "LAMPOFF")
    {
        ui->pPBLamp->setIcon(QIcon(":/images/Image/light_off.png"));
        ui->pPBLamp->setPalette(paletteColorOff);
    }
    else if(qList[2] == "GASON")
    {
        ui->pPBPlug->setIcon(QIcon(":/images/Image/plug_on.png"));
        ui->pPBPlug->setPalette(paletteColorOn);
    }
    else if(qList[2] == "GASOFF")
    {
        ui->pPBPlug->setIcon(QIcon(":/images/Image/plug_off.png"));
        ui->pPBPlug->setPalette(paletteColorOff);
    }
}
