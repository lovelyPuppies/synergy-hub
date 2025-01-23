#include <QApplication>
//
#include "CustomWidget.h"
#include <QLabel>
#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[]) {
  QApplication app(argc, argv);

  // QLabel *hello = new QLabel("<font color=blue>Hello <i>World!</i></font>", 0);
  // hello->resize(180, 135);
  // hello->move(300, 300);

  // hello->show();

  CustomWidget *widget = new CustomWidget(0);

  widget->show();

  return app.exec();
}