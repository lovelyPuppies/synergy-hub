#include "keyled.h"


KeyLed::KeyLed(QWidget *parent) :
    QWidget(parent)
{
    pFile = new QFile("/dev/ledkey_dev");
    if(!pFile->open(QFile::ReadWrite | QFile::Unbuffered))
    {
        QMessageBox::information(this,"open","open fail : /dev/ledkey_dev");
    }
    keyledFd = pFile->handle();
    pKeyLedNotifier = new QSocketNotifier(keyledFd,QSocketNotifier::Read,this);
    connect(pKeyLedNotifier,SIGNAL(activated(int)),this,SLOT(readKeyData(int)));
    writeLedData(0);
}
void KeyLed::readKeyData(int)
{
    char no = 0;
    int ret = pFile->read(&no,sizeof(no));
    if(ret > 0)
        emit updateKeydataSig(int(no));
}

void KeyLed::writeLedData(int no)
{
    char led = (char)no;
    pFile->write(&led, sizeof(led));
}

KeyLed::~KeyLed()
{

}
