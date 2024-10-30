# STM32F411RE CN7 and CN10 Pinout with Peripheral Configuration

- [STM32F411RE CN7 and CN10 Pinout with Peripheral Configuration](#stm32f411re-cn7-and-cn10-pinout-with-peripheral-configuration)
  - [NUCLEO-F411RE Default Pin map](#nucleo-f411re-default-pin-map)
    - [Notes](#notes)
    - [CN7 Pinout Table](#cn7-pinout-table)
    - [CN10 Pinout Table](#cn10-pinout-table)
      - [1. STM32F411RE Datasheet](#1-stm32f411re-datasheet)
  - [Details of Peripheral Configuration](#details-of-peripheral-configuration)
    - [TIM Peripheral Configuration](#tim-peripheral-configuration)
      - [2.1 TIM1 - Ultrasonic Sensor (HC-SR04)](#21-tim1---ultrasonic-sensor-hc-sr04)
      - [2.2 TIM4 - Motor (EZ Motor R300)](#22-tim4---motor-ez-motor-r300)
      - [2.3 TIM3 - Servo Motor (SG-90)](#23-tim3---servo-motor-sg-90)
    - [USART Peripheral Configuration](#usart-peripheral-configuration)
      - [2.4 USART1 - WiFi Module (ESP-01S ESP8266)](#24-usart1---wifi-module-esp-01s-esp8266)
      - [2.5 USART2 - Debugging (printf)](#25-usart2---debugging-printf)
      - [2.6 USART6 - Bluetooth Module (HC-06)](#26-usart6---bluetooth-module-hc-06)
    - [I2C Peripheral Configuration](#i2c-peripheral-configuration)
      - [2.7 I2C1 - LCD 1602 (HD44780 Compatible)](#27-i2c1---lcd-1602-hd44780-compatible)
    - [3. Additional Resources](#3-additional-resources)

---

## NUCLEO-F411RE Default Pin map

from [Hardware layout and configuration 🔪 Table 29. ST morpho connector on NUCLEO-F401RE, NUCLEO-F411RE, NUCLEO-F446RE](https://www.st.com/resource/en/user_manual/dm00105823-stm32-nucleo-64-boards-mb1136-stmicroelectronics.pdf)

### Notes

- ⚪: Available (Not Configured)
- 🟢: Assigned with Configuration
- 🎛️: Assigned with Configuration but Not phsyically connected

### CN7 Pinout Table

| CN7 odd pins |          CN7 odd pins | CN7 even pins Status | CN7 even pins |
| ------------ | --------------------: | -------------------- | ------------- |
| 01-PC10      | GPIO (Trigger Pin) 🟢 | ⚪                   | 02-PC11       |
| 03-PC12      |                    ⚪ | ⚪                   | 04-PD2        |
| 05-VDD       |                    ⚪ | ⚪                   | 06-E5V        |
| 07-BOOT0     |                    ⚪ | ⚪                   | 08-GND        |
| 09--         |                    ⚪ | ⚪                   | 10--          |
| 11-IOREF     |                    ⚪ | ⚪                   | 12-IOREF      |
| 13-PA13      |                    ⚪ | ⚪                   | 14-RESET      |
| 15-PA14      |                    ⚪ | ⚪                   | 16-+3.3V      |
| 17-PA15      |          USART1_TX 🟢 | ⚪                   | 18-+5V        |
| 19-GND       |                    ⚪ | ⚪                   | 20-GND        |
| 21-PB7       |           TIM4_CH2 🟢 | ⚪                   | 22-GND        |
| 23-PC13      |                    ⚪ | ⚪                   | 24-VIN        |
| 25-PC14      |                    ⚪ | ⚪                   | 26--          |
| 27-PC15      |                    ⚪ | ⚪                   | 28-PA0        |
| 29-PH0       |                    ⚪ | ⚪                   | 30-PA1        |
| 31-PH1       |                    ⚪ | ⚪                   | 32-PA4        |
| 33-VBAT      |                    ⚪ | ⚪                   | 34-PB0        |
| 35-PC2       |                    ⚪ | 🟢 I2C1_SDA          | 36-PC1 or PB9 |
| 37-PC3       |                    ⚪ | 🟢 I2C1_SCL          | 38-PC0 or PB8 |

### CN10 Pinout Table

| CN10 odd pins |                CN10 odd pins | CN10 even pins Status | CN10 even pins |
| ------------- | ---------------------------: | --------------------- | -------------- |
| 01-PC9        |                           ⚪ | ⚪                    | 02-PC8         |
| 03-PB8        |                           ⚪ | 🟢 USART6_TX          | 04-PC6         |
| 05-PB9        |                           ⚪ | ⚪                    | 06-PC5         |
| 07-AVDD       |                           ⚪ | ⚪                    | 08-U5V         |
| 09-GND        |                           ⚪ | ⚪                    | 10--           |
| 11-PA5        |                           ⚪ | ⚪                    | 12-PA12        |
| 13-PA6        |                           ⚪ | ⚪                    | 14-PA11        |
| 15-PA7        |                           ⚪ | ⚪                    | 16-PB12        |
| 17-PB6        |                           ⚪ | ⚪                    | 18--           |
| 19-PC7        |                 USART6_RX 🟢 | ⚪                    | 20-GND         |
| 21-PA9        | TIM1_CH2 (Timing capture) 🎛️ | ⚪                    | 22-PB2         |
| 23-PA8        |       TIM1_CH1 (Echo Pin) 🟢 | ⚪                    | 24-PB1         |
| 25-PB10       |                           ⚪ | ⚪                    | 26-PB15        |
| 27-PB4        |                           ⚪ | ⚪                    | 28-PB14        |
| 29-PB5        |                  TIM3_CH2 🟢 | ⚪                    | 30-PB13        |
| 31-PB3        |                           ⚪ | ⚪                    | 32-AGND        |
| 33-PA10       |                 USART1_RX 🟢 | ⚪                    | 34-PC4         |
| 35-PA2        |                 USART2_TX 🎛️ | ⚪                    | 36--           |
| 37-PA3        |                 USART2_RX 🎛️ | ⚪                    | 38--           |

---

#### 1. STM32F411RE Datasheet

For detailed information on the STM32F411RE microcontroller, refer to the official datasheet:

- **STM32F411RE Datasheet**: [STM32F411xC/E Datasheet](https://www.st.com/resource/en/datasheet/stm32f411re.pdf)

---

## Details of Peripheral Configuration

### TIM Peripheral Configuration

#### 2.1 TIM1 - Ultrasonic Sensor (HC-SR04)

- **Channel 1** (Input Capture Mode):
  - 🟢 **PA8**: TIM1_CH1 (Echo Pin)
- **Channel 2** (Input Capture Mode):
  - 🎛️ **PA9**: TIM1_CH2 (Used for timing capture)
- **Trigger Pin**:
  - 🟢 **PC10**: GPIO (Trigger Pin)
- **Purpose**: Measures the time between rising and falling edges of the Echo signal using Input Capture mode on TIM1_CH1.
- **Datasheet**: [HC-SR04 Datasheet](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf)

#### 2.2 TIM4 - Motor (EZ Motor R300)

- **Channel 2**
- **Purpose**: Motor control
- **Assigned Pin**:
  - 🟢 **PB7**: TIM4_CH2
- **Datasheet**: [EZ Motor R300 Module](https://www.devicemart.co.kr/goods/view?no=1385023)

#### 2.3 TIM3 - Servo Motor (SG-90)

- **Channel 2**
- **Purpose**: Servo motor control
- **Assigned Pin**:
  - 🟢 **PB5**: TIM3_CH2
- **Datasheet**: [SG-90 Datasheet](https://www.friendlywire.com/projects/ne555-servo-safe/SG90-datasheet.pdf)

### USART Peripheral Configuration

#### 2.4 USART1 - WiFi Module (ESP-01S ESP8266)

- **Mode**: Asynchronous
- **Purpose**: WiFi communication
- **Assigned Pins**:
  - 🟢 **PA15**: USART1_TX
  - 🟢 **PA10**: USART1_RX
- **Voltage**: 3.3V
- **Datasheet**: [ESP-01S Datasheet](https://www.microchip.ua/wireless/esp01.pdf)
- **AT Command**: [ESP-8266 AT Command](https://room-15.github.io/blog/2015/03/26/esp8266-at-command-reference/)

#### 2.5 USART2 - Debugging (printf)

- **Mode**: Asynchronous
- **Purpose**: Debug output
- **Assigned Pins**:
  - 🎛️ **PA2**: USART2_TX
  - 🎛️ **PA3**: USART2_RX

#### 2.6 USART6 - Bluetooth Module (HC-06)

- **Mode**: Asynchronous
- **Purpose**: Bluetooth communication
- **Assigned Pins**:
  - 🟢 **PC6**: USART6_TX
  - 🟢 **PC7**: USART6_RX
- **Voltage**: 3.6V ~ 6V
- **Baud Rate**: 9600 bps
- **Datasheet**: [HC-06 Datasheet](https://rajguruelectronics.com/Product/707/HC-06%20core%20bluetooth%20module.pdf)
- Chipset: [CSR BC417 (CSR: Cambridge Silicon Radio) ](https://cdn.sparkfun.com/datasheets/Wireless/Bluetooth/CSR-BC417-datasheet.pdf)

### I2C Peripheral Configuration

#### 2.7 I2C1 - LCD 1602 (HD44780 Compatible)

- **Purpose**: Display output
- **Assigned Pins**:
  - 🟢 **PB8**: I2C1_SCL
  - 🟢 **PB9**: I2C1_SDA
- **Notes**: Compatible with HD44780 controller.
- **Datasheet**: [HD44780U

### 3. Additional Resources

- **User Manual**: [UM1724: STM32 Nucleo-64 boards (MB1136)](https://www.st.com/resource/en/user_manual/um1724-stm32-nucleo64-boards-mb1136-stmicroelectronics.pdf)
- **Pinout Legend**:
  - Full pinmap: [ST-Nucleo-F411RE](https://os.mbed.com/platforms/ST-Nucleo-F411RE/)
  - Simple pinmap:  
    ![Nucleo-F411RE Pinout](https://dcc-ex.com/_images/nucleo-f411re-pinout.png)
