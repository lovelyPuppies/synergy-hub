# Raspberry Pi 4B Maps

- Raspberry Pi uses 🪱 virtual addresses with the 0xFE prefix for hardware register access.

## Default Pin map

### Notes

- ⚪: Available (Not Configured)
- 🟢: Assigned with Configuration
- 🎛️: Assigned with Configuration but Not phsyically connected

### GPIO Pinout Table

| GPIO Pins             | GPIO Pins Status | GPIO Pins Status | GPIO Pins            |
| --------------------- | ---------------- | ---------------- | -------------------- |
| 01-3.3V               | ⚪               | ⚪               | 02-5V                |
| 03-GPIO02 (SDA1)      | ⚪               | ⚪               | 04-5V                |
| 05-GPIO03 (SCL1)      | ⚪               | ⚪               | 06-GND               |
| 07-GPIO04             | ⚪               | ⚪               | 08-GPIO14 (TXD)      |
| 09-GND                | ⚪               | ⚪               | 10-GPIO15 (RXD)      |
| 11-GPIO17 (PWM0)      | ⚪               | ⚪               | 12-GPIO18 (PCM_CLK)  |
| 13-GPIO27 (PWM1)      | ⚪               | ⚪               | 14-GND               |
| 15-GPIO22             | ⚪               | ⚪               | 16-GPIO23            |
| 17-3.3V               | ⚪               | ⚪               | 18-GPIO24            |
| 19-GPIO10 (SPI0 MOSI) | ⚪               | ⚪               | 20-GND               |
| 21-GPIO09 (SPI0 MISO) | ⚪               | ⚪               | 22-GPIO25            |
| 23-GPIO11 (SPI0 SCLK) | ⚪               | ⚪               | 24-GPIO08 (CE0)      |
| 25-GND                | ⚪               | ⚪               | 26-GPIO07 (CE1)      |
| 27-GPIO00 (I2C0 SDA)  | ⚪               | ⚪               | 28-GPIO01 (I2C0 SCL) |
| 29-GPIO05             | ⚪               | ⚪               | 30-GND               |
| 31-GPIO06             | ⚪               | ⚪               | 32-GPIO12            |
| 33-GPIO13             | ⚪               | ⚪               | 34-GND               |
| 35-GPIO19             | ⚪               | ⚪               | 36-GPIO16            |
| 37-GPIO26             | ⚪               | ⚪               | 38-GPIO20            |
| 39-GND                | ⚪               | ⚪               | 40-GPIO21            |

---

## General Purpose I/O (GPIO)

from [BCM 2711 ARM Peripherals 🔪 Chapter 5. General Purpose I/O (GPIO)](https://datasheets.raspberrypi.com/bcm2711/bcm2711-peripherals.pdf)

### Default GPFSEL Registers

#### GPFSEL0

🌐 Virtual Address: 0xFE200000

```
# GPIO 00 ~ 09 (10)

🖧 GPIO     |(not used) |  GPIO 09     |  GPIO 08    |  GPIO 07    |  GPIO 06    |  GPIO 05   |  GPIO 04   |  GPIO 03    |  GPIO 02    |  GPIO 01    |  GPIO 00    |
🔢 BitNum   | 32  31    | 30  29  28   | 27  26  25  | 24  23  22  | 21  20  19  | 18  17  16 | 15  14  13 | 12  11  10  | 09  08  07  | 06  05  04  | 03  02  01  |
⚪ BitSet   |  0  0        0   0 | 0      0   0   0  |  0   0   0     0 | 0   0     0   0 | 0    0   0   0 |  0   0   0     0 | 0   0     0   0 | 0     0   0   0  |
⚫ Hex (0x) |          0         |         0         |         0        |        0        |        0       |        0         |        0        |         0        |
```

#### GPFSEL1

🌐 Virtual Address: 0xFE200004

```
# GPIO 10 ~ 19 (10)

🖧 GPIO     |(not used) |  GPIO 19    |  GPIO 18    |  GPIO 17    |  GPIO 16    |  GPIO 15    |  GPIO 14    |  GPIO 13    |  GPIO 12    |  GPIO 11    |  GPIO 10    |
🔢 BitNum   | 32  31    | 30  29  28   | 27  26  25  | 24  23  22  | 21  20  19  | 18  17  16 | 15  14  13 | 12  11  10  | 09  08  07  | 06  05  04  | 03  02  01  |
⚪ BitSet   |  0  0        0   0 | 0      0   0   0  |  0   0   0     0 | 0   0     0   0 | 0    0   0   0 |  0   0   0     0 | 0   0     0   0 | 0     0   0   0  |
⚫ Hex (0x) |          0         |         0         |         0        |        0        |        0       |        0         |        0        |         0        |
```

#### GPFSEL2

🌐 Virtual Address: 0xFE200008

```
# GPIO 20 ~ 29 (10)

🖧 GPIO     |(not used) |  GPIO 29    |  GPIO 28    |  GPIO 27    |  GPIO 26    |  GPIO 25    |  GPIO 24    |  GPIO 23    |  GPIO 22    |  GPIO 21    |  GPIO 20   |
🔢 BitNum   | 32  31    | 30  29  28   | 27  26  25  | 24  23  22  | 21  20  19  | 18  17  16 | 15  14  13 | 12  11  10  | 09  08  07  | 06  05  04  | 03  02  01  |
⚪ BitSet   |  0  0        0   0 | 0      0   0   0  |  0   0   0     0 | 0   0     0   0 | 0    0   0   0 |  0   0   0     0 | 0   0     0   0 | 0     0   0   0  |
⚫ Hex (0x) |          0         |         0         |         0        |        0        |        0       |        0         |        0        |         0        |
```

#### GPFSEL3

🌐 Virtual Address: 0xFE20000c

```
# GPIO 30 ~ 39 (10)

🖧 GPIO     |(not used) |  GPIO 39    |  GPIO 38    |  GPIO 37    |  GPIO 36    |  GPIO 35    |  GPIO 34    |  GPIO 33    |  GPIO 32    |  GPIO 31    |  GPIO 30   |
🔢 BitNum   | 32  31    | 30  29  28   | 27  26  25  | 24  23  22  | 21  20  19  | 18  17  16 | 15  14  13 | 12  11  10  | 09  08  07  | 06  05  04  | 03  02  01  |
⚪ BitSet   |  0  0        0   0 | 0      0   0   0  |  0   0   0     0 | 0   0     0   0 | 0    0   0   0 |  0   0   0     0 | 0   0     0   0 | 0     0   0   0  |
⚫ Hex (0x) |          0         |         0         |         0        |        0        |        0       |        0         |        0        |         0        |
```

#### GPFSEL4

🌐 Virtual Address: 0xFE200010

```
# GPIO 40 ~ 49 (10)

🖧 GPIO     |(not used) |  GPIO 49    |  GPIO 48    |  GPIO 47    |  GPIO 46    |  GPIO 45    |  GPIO 44    |  GPIO 43    |  GPIO 42    |  GPIO 41    |  GPIO 40   |
🔢 BitNum   | 32  31    | 30  29  28   | 27  26  25  | 24  23  22  | 21  20  19  | 18  17  16 | 15  14  13 | 12  11  10  | 09  08  07  | 06  05  04  | 03  02  01  |
⚪ BitSet   |  0  0        0   0 | 0      0   0   0  |  0   0   0     0 | 0   0     0   0 | 0    0   0   0 |  0   0   0     0 | 0   0     0   0 | 0     0   0   0  |
⚫ Hex (0x) |          0         |         0         |         0        |        0        |        0       |        0         |        0        |         0        |
```

#### GPFSEL5

🌐 Virtual Address: 0xFE20014

```
# GPIO 50 ~ 57 (8)

...

```

### GPSET Registers

#### GPSET0 Register

🌐 Virtual Address: 0xFE20001C

GPIO 0 ~ 31 (32)

...

### GPCLR Registers

🌐 Virtual Address: 0xFE200028

#### GPCLR0 Register

GPIO 0 ~ 31 (32)

...

### GPLEV Registers

🌐 Virtual Address: 0xFE200034

#### GPLEV0 Register

GPIO 0 ~ 31 (32)

...
