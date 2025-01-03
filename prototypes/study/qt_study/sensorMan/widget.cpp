#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) : QWidget(parent), ui(new Ui::Widget) {
  ui->setupUi(this);

  // QPushButton 클릭 시 람다를 호출
  // connect(ui->pBQuit, &QPushButton::clicked, this,
  //         []() { qDebug() << "Button clicked with lambda!"; });
}

Widget::~Widget() { delete ui; }
