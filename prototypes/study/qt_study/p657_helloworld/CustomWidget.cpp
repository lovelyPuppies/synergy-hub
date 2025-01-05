#include <QApplication>
//
#include "CustomWidget.h"
#include <QPushButton>

CustomWidget::CustomWidget(QWidget *parent) : QWidget(parent) {
  QPushButton *button = new QPushButton("Quit", this);
  button->resize(120, 35);

  this->resize(120, 35);
  // 🚣ZIt is fine remove "this->" because "move" is a member of QWidget.
  move(300, 300);

  connect(button, &QPushButton::clicked, this, &CustomWidget::processClick);
}

void CustomWidget::processClick() { close(); }