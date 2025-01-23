#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindow) {
  ui->setupUi(this);

  // ⚙️ Lambda-based signal-slot connection in Modern C++"
  connect(ui->pushButton, &QPushButton::clicked, this, [this]() {
    qDebug() << "Button clicked!";
    ui->label->setText("Button was clicked!");
  });
}

MainWindow::~MainWindow() { delete ui; }
