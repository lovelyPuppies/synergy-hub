#ifndef __CUSTOM_WIDGET__
  #define __CUSTOM_Wz IDGET__

  #include <qwidget.h>

class CustomWidget : public QWidget {
  Q_OBJECT
public:
  CustomWidget(QWidget *parent = nullptr);

signals:
  void widgetClicked();

public slots:
  void processClick();
};

#endif // __CUSTOM_WIDGET__
