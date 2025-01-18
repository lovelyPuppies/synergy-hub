## Project Introduction

This project demonstrates the implementation of a kernel timer module on Linux for edge devices. It integrates hardware-based interrupts, user-space applications, and kernel space logic for managing timers and GPIO operations.

### Features

(e.g. 선풍기의 경우의 구조를 참고할것. format> "- <title>: <summary>)

- 전원 제어: 선풍기 전원을 켜거나 끌 수 있음.
- 팬 속도 조절: 저속, 중속, 고속으로 팬 속도를 변경 가능.
- 모드 전환: 수동 모드와 자동 모드 간 전환 가능.
- 타이머 설정: 3, 5, 7분 타이머 설정으로 자동 종료.
- 상태 표시: LCD 및 FND로 현재 모드, 속도, 타이머 상태 표시.

# LED Timer and Button Interaction

### 동작 흐름

#### 1. 초기 LED 반전 시작

- 애플리케이션 실행 시:
  - LED 값과 타이머 주기를 설정 (`ioctl(TIMER_VALUE)`).
  - `ioctl(TIMER_START)`를 호출하여 LED가 일정 시간마다(설정된 타이머 주기) 반전됩니다.
- LED는 타이머 주기에 따라 **ON/OFF**가 반복됩니다.

#### 2. 버튼 동작에 따른 LED/타이머 제어

- **버튼 1**:
  - 타이머를 정지(`ioctl(TIMER_STOP)`). LED는 현재 상태에서 멈춤.
- **버튼 2**:
  - 타이머 주기를 새로 입력받아 설정.
    - 입력 후 **`ioctl(TIMER_VALUE)`**와 함께 타이머 재시작(`TIMER_START`) -> LED 반전 속도가 변경.
- **버튼 3**:
  - 새 LED 값을 입력받아 설정.
    - 입력 값에 따라 특정 LED 패턴으로 변경.
- **버튼 4**:
  - 타이머를 다시 시작(`ioctl(TIMER_START`).
- **버튼 8**:
  - 타이머 정지 후 애플리케이션 종료.

#### 3. 애플리케이션 종료

- 사용자가 **'Q' 또는 'q'**를 입력하거나 버튼 8을 누르면:
  - LED 동작 중지(`TIMER_STOP`).
  - 애플리케이션 종료.

### 🎯 Project Purposes

- Implement a kernel timer with start, stop, and configuration functionalities.
- Develop a user-space application to interact with the kernel module via ioctl calls.
- Showcase GPIO-based LED control and button inputs using kernel drivers.

### 📌 Key Learnings and Improvements

- Integration of poll and blocking I/O for efficient device interaction.
- Improved driver reliability through robust error handling.
- Enhanced user experience with dynamic input validation.

/\*
Edge 디바이스 리눅스 BSP

문항) 입출력 다중화(Poll)와 블록킹 I/O 를 구현한 디바이스 드라이버

- 구현 조건

1. ✔️ Device driver uses

- ✔️ Poll (I/O 다중화)
- ✔️ Blocking I/O
  처리할 데이터가 없을 시 프로세스를 대기 상태(Sleep on) 으로 전환하고, key
  인터럽트 발생 시 wake up 하여 준비/실행 상태로 전환하여 처리한다.
  `  wake_up_interruptible(&waitQueueRead); // in keyIsr()
  wait_event_interruptible(waitQueueRead, pKeyData->keyNum // in ledkey_read()`

2. ✔️ App have arguments: Led value, Timer time

- ✔️ Exception process: print
  Usage : kernel_timer_app [led_vall(0x00~0xff)] [time_val(1/100)]
- ✔️ Input Arguments
  ```
  led_no = (char)strtoul(argv[1], NULL, 16);
  timer_val = atoi(argv[2]);
  ```

3. ✔️ use ioctl()
   typedef struct {
   unsigned long timer_val;
   } **attribute**((packed)) ledKey_data;

// Start kernel timer
#define TIMER_START \_IO(IOCTLTEST_MAGIC, 11)
// Stop kernel timer
#define TIMER_STOP \_IO(IOCTLTEST_MAGIC, 12)
// Set cycle of LED On/Off
#define TIMER_VALUE \_IOW(IOCTLTEST_MAGIC, 13, ledKey_data)

4. ✔️ file operations: read() key, write() led
5. ✔️ Operations based on read key

- key1: ioctl(TIMER_STOP)
- key2: input timer value
  key2를 입력 시 키보드로 커널 타이머 시간을 100분의 1초 단위로 입력 받아
  (TIMER_VALUE)
- key3: input led value from stdin (0x00~0xff)
  write the led value
- key4: ioctl(TIMER_STOP)
- key8: ioctl(TIMER_STOP) with Application close

      and write변경된 값으로 on/off, 및 'Q' 또는 'q' 입력 시 타이머는 멈추고

  응용프로세스를 종료.

6. Timer Start 하면 실행되도록. insmod할 때 말고.

\*/
