#ifndef TAB1DEVCONTROL_H
#define TAB1DEVCONTROL_H

#include "keyled.hpp"
#include <QWidget>
#include <ui_widget.h>
namespace Ui {
class Tab1DevControl;
}

class Tab1DevControl : public QWidget {
  Q_OBJECT

public:
  explicit Tab1DevControl(QWidget *parent = nullptr);
  ~Tab1DevControl();

private:
  Ui::Widget *ui;
  KeyLed *pKeyLed;
};

#endif // TAB1DEVCONTROL_H
