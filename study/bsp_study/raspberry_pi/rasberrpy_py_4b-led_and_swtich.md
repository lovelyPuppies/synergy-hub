# Raspberry Pi 4B Pin map

📅 Written at 2024-12-04 11:33:28

## Notes

- ⚪: Available (Not Configured)
- 🟢: Assigned with Configuration
- 🎛️: Assigned with Configuration but Not phsyically connected

## Using Devices

- [NEWTC 🔪 LED Output Board 🔪 AM-TL8](https://www.d-evicemart.co.kr/goods/view?no=6772)
  - [Manual](https://www.newtc.co.kr/dpshop/bbs/download.php?bo_table=m45&wr_id=41&no=0&sca=&sfl=wr_subject||wr_content&stx=AM-TL8&sop=and)
    - 5V
- [NEWTC 🔪 Switch Input Board 🔪 AM-TS8](https://www.devicemart.co.kr/goods/view?no=11701)
  - [Manual](https://www.newtc.co.kr/dpshop/bbs/download.php?bo_table=m45&wr_id=90&no=0&sfl=&stx=&sst=wr_hit&sod=asc&sop=and&page=4)
    - 5V
- **1** \* GPIO 40Pin 20cm Rainbow Ribbon Cable
- **1** \* Assembled T Type RPi GPIO adapter with neoprene foam protect, Sorted label printed 40 pins for easy prototyping

## GPIO Pinout Table

| GPIO Pins             | GPIO Pins Status | GPIO Pins Status | GPIO Pins            |
| --------------------- | ---------------- | ---------------- | -------------------- |
| 01-3.3V               | ⚪               | 🟢               | 02-5V                |
| 03-GPIO02 (SDA1)      | ⚪               | ⚪               | 04-5V                |
| 05-GPIO03 (SCL1)      | ⚪               | 🟢               | 06-GND               |
| 07-GPIO04             | ⚪               | 🟢 (USB to TTL)  | 08-GPIO14 (TXD)      |
| 09-GND                | ⚪               | 🟢 (USB to TTL)  | 10-GPIO15 (RXD)      |
| 11-GPIO17 (PWM0)      | 🟢 (Button 2)    | 🟢 (Button 3)    | 12-GPIO18 (PCM_CLK)  |
| 13-GPIO27 (PWM1)      | ⚪               | ⚪               | 14-GND               |
| 15-GPIO22             | 🟢 (Button 7)    | 🟢 (Button 8)    | 16-GPIO23            |
| 17-3.3V               | ⚪               | ⚪               | 18-GPIO24            |
| 19-GPIO10 (SPI0 MOSI) | 🟢 (LED 5)       | ⚪               | 20-GND               |
| 21-GPIO09 (SPI0 MISO) | 🟢 (LED 4)       | ⚪               | 22-GPIO25            |
| 23-GPIO11 (SPI0 SCLK) | 🟢 (LED 6)       | 🟢 (LED 3)       | 24-GPIO08 (CE0)      |
| 25-GND                | ⚪               | 🟢 (LED 2)       | 26-GPIO07 (CE1)      |
| 27-GPIO00 (I2C0 SDA)  | ⚪               | ⚪               | 28-GPIO01 (I2C0 SCL) |
| 29-GPIO05             | ⚪               | ⚪               | 30-GND               |
| 31-GPIO06             | 🟢 (LED 1)       | 🟢 (LED 7)       | 32-GPIO12            |
| 33-GPIO13             | 🟢 (LED 8)       | ⚪               | 34-GND               |
| 35-GPIO19             | 🟢 (Button 4)    | 🟢 (Button 1)    | 36-GPIO16            |
| 37-GPIO26             | ⚪               | 🟢 (Button 5)    | 38-GPIO20            |
| 39-GND                | ⚪               | 🟢 (Button 6)    | 40-GPIO21            |
