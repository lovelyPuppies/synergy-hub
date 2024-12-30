#include "tab1devcontrol.h"
#include "ui_widget.h"

Tab1DevControl::Tab1DevControl(QWidget *parent)
    : QWidget(parent), ui(new Ui::Widget) {
  ui->setupUi(this);
  pKeyLed = new KeyLed(this);

  connect(ui->pDialLed, SIGNAL(valueChanged(int)), pKeyLed,
          SLOT(writeLedData(int)));
}

Tab1DevControl::~Tab1DevControl() { delete ui; }
