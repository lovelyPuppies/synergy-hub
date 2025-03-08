#ifndef TAB1DEVCONTROL_H
#define TAB1DEVCONTROL_H

#include <QWidget>
#include <QTimer>
#include <QDebug>
#include <QButtonGroup>
#include "keyled.h"
namespace Ui {
class Tab1DevControl;
}

class Tab1DevControl : public QWidget
{
    Q_OBJECT

public:
    explicit Tab1DevControl(QWidget *parent = nullptr);
    ~Tab1DevControl();
    KeyLed * getpKeyLed();

private slots:
    void on_pPBQuit_clicked();
    void on_pPBtimerStart_clicked(bool checked);
    void setValueDialSlot();
    void on_pCBtimerValue_currentTextChanged(const QString &arg1);
    void keyCheckBoxSlot(int);
    void keyCheckBoxKeyboardSlot(int);

private:
    Ui::Tab1DevControl *ui;
    KeyLed *pKeyLed;
    QTimer *pQTimer;
    QButtonGroup *pQButtonGroup;
    QCheckBox *pQCheckBoxArray[8];
    int arrCnt;
    int itemCnt;
    int lcdKeydata;
};

#endif // TAB1DEVCONTROL_H
