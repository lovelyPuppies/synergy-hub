#include "keyled.hpp"

// 🚀 Using std::make_unique for safer memory management.
// This ensures that pFile's memory is automatically managed and released when the object goes out of scope.
// Prevents memory leaks and simplifies ownership handling.
KeyLed::KeyLed(QWidget *parent)
    : QWidget(parent), pFile(std::make_unique<QFile>("/dev/ledkey_dev")) {

  // 🚀 Improved error message for better clarity during debugging.
  if (!pFile->open(QFile::ReadWrite | QFile::Unbuffered)) {
    QMessageBox::information(this, "Open Error",
                             "Failed to open /dev/ledkey_dev");
    return; // 🚀 Added return to prevent further execution if file open fails.
  }

  // No change: QFile::handle() remains the same, retrieves the file descriptor for further operations.
  keyledFd = pFile->handle();

  // 🚀 Using std::make_unique for QSocketNotifier to ensure automatic memory management.
  pKeyLedNotifier =
      std::make_unique<QSocketNotifier>(keyledFd, QSocketNotifier::Read, this);

  // 🚀 Modern Qt signal-slot syntax:
  // - Ensures type safety by checking signal and slot compatibility at compile time.
  // - Avoids runtime errors caused by mismatched signal-slot types.
  connect(pKeyLedNotifier.get(), &QSocketNotifier::activated, this,
          &KeyLed::readKeyData);
}

void KeyLed::readKeyData(int) {
  char no = 0;

  // No change: Reading key data from the device remains straightforward.
  int ret = pFile->read(&no, sizeof(no));
  if (ret > 0)
    // 🚀 Explicit casting for type clarity and safety.
    emit updateKeydataSig(static_cast<int>(no));
}

void KeyLed::writeLedData(int no) {
  // 🚀 Explicit casting for type clarity and safety, ensuring compatibility with device requirements.
  char led = static_cast<char>(no);

  // No change: Writing LED data to the device.
  pFile->write(&led, sizeof(led));
}

// 🚀 Destructor uses = default as std::unique_ptr automatically manages and cleans up resources.
KeyLed::~KeyLed() = default;
