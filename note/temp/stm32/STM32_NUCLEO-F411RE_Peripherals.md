# Explanation of Peripherals on NUCLEO-F411RE

This document explains the abbreviations for I2C, SPI, USART peripherals on the STM32F411RE and why USART3~5 are not available.

## Peripheral Abbreviations

### 1. **I2C (Inter-Integrated Circuit)**
- **I2C1, I2C2, I2C3**: These refer to the three available I2C interfaces on the STM32F411RE.
- **I2C Overview**:
  - I2C is a bi-directional serial communication protocol using two lines: SCL (clock) and SDA (data).
  - 🔧 Commonly used to communicate with peripherals like sensors, EEPROMs, and RTC modules.

### 2. **SPI (Serial Peripheral Interface)**
- **SPI1, SPI2, SPI3, SPI4, SPI5**: These represent the five SPI channels available.
- **SPI Overview**:
  - SPI operates in a master-slave configuration and uses four signals: SCK (clock), MOSI (master out slave in), MISO (master in slave out), and CS (chip select).
  - 🔧 Frequently used for high-speed data communication with devices like displays, ADCs, DACs, and SD cards.

### 3. **USART (Universal Synchronous/Asynchronous Receiver Transmitter)**
- **USART1, USART2, USART6**: These represent the available USART interfaces.
- **USART Overview**:
  - Supports both synchronous and asynchronous communication.
  - 🔧 Commonly used for communication with PCs, Bluetooth modules, and GPS modules.

---

## Why USART3~5 Are Not Available on F411RE

The STM32F411RE microcontroller does not provide USART3, USART4, and USART5 for the following reasons:

### 1. **Hardware Resource Limitations**
- The NUCLEO-F411RE uses the **LQFP64 package**, which provides only 64 pins.
- Due to limited pins, not all USART channels are made available on this package.

### 2. **Model-Specific Differences**
- Different STM32F411 variants (e.g., STM32F411RC, STM32F411RG) or larger pin-count packages like LQFP100 may include USART3~5.

### 3. **Priority Design**
- The design prioritizes commonly used interfaces, hence only USART1, USART2, and USART6 are activated on this board.

### 4. **Use of UART**
- Instead of USART3~5, the board provides **UART4** and **UART5**. These are simpler versions of USART that support only asynchronous communication.

---

## Summary of Interfaces on NUCLEO-F411RE

### Available Interfaces
- **I2C**: I2C1, I2C2, I2C3
- **SPI**: SPI1, SPI2, SPI3, SPI4, SPI5
- **USART**: USART1, USART2, USART6
- **UART**: UART4, UART5 (can be used in place of USART3~5)

---

By configuring UART4 and UART5 appropriately, asynchronous communication needs can still be met despite the absence of USART3~5. 
If you have further questions, feel free to ask!
