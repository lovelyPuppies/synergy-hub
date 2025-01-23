#ifndef KEYLED_HPP
#define KEYLED_HPP

#include <QFile>
#include <QMessageBox>
#include <QSocketNotifier>
#include <QWidget>
#include <memory> // Added for std::unique_ptr to manage resources automatically

class KeyLed : public QWidget {
  Q_OBJECT

public:
  explicit KeyLed(QWidget *parent = nullptr);
  ~KeyLed()
      override; // Added `override` to ensure this destructor correctly overrides the base class destructor

private:
  // Changed from raw pointer to std::unique_ptr for automatic resource management
  std::unique_ptr<QFile> pFile;

  int keyledFd;

  // Changed from raw pointer to std::unique_ptr to avoid manual deletion
  std::unique_ptr<QSocketNotifier> pKeyLedNotifier;

private slots:
  // Slot to read key data from the device
  void readKeyData(int);
  // Slot to write LED data to the device
  void writeLedData(int);

signals:
  void updateKeydataSig(int); // Signal emitted when key data is updated
};

#endif // KEYLED_HPP
