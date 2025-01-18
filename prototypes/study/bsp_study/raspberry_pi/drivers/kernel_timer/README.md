# Fan Project

📅 Written at 2025-01-03 09:44:20

- [Fan Project](#fan-project)
  - [Project Introduction](#project-introduction)
    - [Features](#features)
    - [🎯 Purposes](#-purposes)
    - [🎥 Kernel Timer Demo](#-kernel-timer-demo)
  - [🌐 Project Overview](#-project-overview)
    - [FSM (Finite State Machine)](#fsm-finite-state-machine)
      - [🕹️ Inputs](#️-inputs)
      - [📊 Diagram](#-diagram)
    - [🛠️ Tools](#️-tools)
      - [🧑‍💻 Software](#-software)
        - [Setup](#setup)
      - [🖥️ Hardware](#️-hardware)
        - [GPIO Pinout Table](#gpio-pinout-table)
    - [📁 Directory Structure](#-directory-structure)
  - [Retrospective](#retrospective)
    - [📌 Key Learnings and Improvements](#-key-learnings-and-improvements)

## Project Introduction

### Features

- 전원 제어: 선풍기 전원을 켜거나 끌 수 있음.
- 팬 속도 조절: 저속, 중속, 고속으로 팬 속도를 변경 가능.
- 모드 전환: 수동 모드와 자동 모드 간 전환 가능.
- 타이머 설정: 3, 5, 7분 타이머 설정으로 자동 종료.
- 상태 표시: LCD 및 FND로 현재 모드, 속도, 타이머 상태 표시.

### 🎯 Purposes

- **C 언어 코드 모듈화 및 구조화**

  - 명확한 디렉터리 구조 설계 (`app` -> `peripheral` (device) -> `driver`)
  - 구조체와 함수 포인터를 활용하여 객체지향적 설계 구현
  - 코드 일관성을 위한 명명 규칙(Naming Convention) 설정
  - 재사용성을 고려한 Utility 라이브러리 제작

- **디자인 패턴 학습 및 활용**

  - 🪱 Model-View-Presenter (MVP) + Service 패턴을 적용하여 시스템의 모듈화와 유지보수성을 강화
  - 구조적 설계를 통해 코드 재사용성 및 확장성 증대

- **외부 장치 제어 기술 숙련**

  - LCD, Buzzer, FND, Motor 등 다양한 장치를 제어하며 하드웨어와 소프트웨어 통합 기술 향상
  - UART 통신 프로토콜 이해 및 구현을 통한 장치 간 데이터 교환 학습
  - FND 디스플레이를 통해 출력 데이터를 시각적으로 표현하는 기술 학습

- **데이터 구조와 알고리즘 학습**

  - UART 수신 데이터 처리에서 🪱 원형 큐(Circular Queue)를 활용하여 **메모리 효율성**, **데이터 흐름 관리** 향상 및 **데이터 손실 방지**

- **데이터시트 분석 능력 향상**
  - 데이터시트를 기반으로 장치 특성을 파악하고 이를 구현에 반영하는 기술 강화

&nbsp;

---

### 🎥 Kernel Timer Demo

- [**Watch on Google Drive**](https://drive.google.com/file/d/1WEi8hI9JJjn31yUDXZswBzpSHwIObNlA/view)

&nbsp;

---

## 🌐 Project Overview

### FSM (Finite State Machine)

📝 **참고**: 명시적인 전환이 정의되지 않는 한 상태는 변경되지 않음.

#### 🕹️ Inputs

- Button: B1, B2, B3, B4

| **버튼**  | **기능**                                     |
| --------- | -------------------------------------------- |
| **B1**    | 타이머 중지 (TIMER_STOP)                     |
| **B2**    | 타이머 값 입력 대기 (stdin으로 값 입력 가능) |
| **B3**    | LED 값 입력 대기 (stdin으로 값 입력 가능)    |
| **B4**    | 타이머 시작 (TIMER_START)                    |
| **B8**    | App 종료 (TIMER_STOP 호출 후 종료)           |
| **stdin** | 사용자 입력 (q: 시스템 종료, 값 입력)        |

---

#### 📊 Diagram

```mermaid
stateDiagram-v2
    [*] --> AppOff

    %% App Off/On
    AppOff --> AppOn: B1
    AppOff --> AppOn: Execute App
    AppOn --> AppOff: B8
    AppOn --> AppOff: [stdin == 'q']

    %% AppOn
    state AppOn {
        [*] --> TimerRunning

        %% Timer Running/Stopped
        TimerStopped --> TimerRunning: B4
        TimerRunning --> TimerStopped: B1 | B2 | B3

        %% CheckStdinRequired and conditions
        state CheckInput <<choice>>
        TimerStopped --> CheckInput
        TimerRunning --> CheckInput

        %% Condition branches with comments
        CheckInput --> AwaitTimerInput: if LastInput == B2
        CheckInput --> AwaitLEDInput: if LastInput == B3
        CheckInput --> StayInCurrentState: else

        %% Await states for stdin
        AwaitTimerInput --> TimerRunning: [stdin] Set Timer period
        AwaitLEDInput --> TimerRunning: [stdin] Set LED Value

        %% Default fallback
        StayInCurrentState --> TimerRunning
        StayInCurrentState --> TimerStopped
    }
```

### 🛠️ Tools

#### 🧑‍💻 Software

- **IDE**: Visual Studio Code (VS Code)
- **Programming Language**: C
- Compiler: **clang**
- NFS Server (Host), NFS Client (Raspberry Pi)

##### Setup

- Ensure the kernel architecture is ARM 64-bit.

  ```bash
  #!/usr/bin/fish
  ## Kernel architecture
  uname -m
  # >> arm64

  ## Userland architecture
  # dpkg-architecture --query DEB_HOST_ARCH
  #   >> arm64
  ```

- Setup Automation script

  ```bash
    #!/usr/bin/env fish

    ##### 👆 User-specific settings

    function prettify_indent_via_pipe
      awk '
        NR == 2 { indent = match($0, /[^ ]/) - 1 }
        NR > 1 { sub("^ {" indent "}", "") }
        NR == 1 { next }
        { gsub(/[[:blank:]]*$/, ""); print }
      '
    end

    # Set Path of Raspberry Pi kernel source
    mkdir -p $HOME/repos/kernels
    cd $HOME/repos/kernels

    # ⭕ we recommend passing a number 1.5x your number of processors. 🔗 https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build
    set jobs_core_n (math (nproc)" * 1.5")

    # Set variables for Deploy (Host is NFS server, RasBerry pi is NFS Client)
    set nfs_host_pi_kernel "/nfs/kernels/raspberry_pi"
    mkdir -p $nfs_host_pi_kernel
    set nfs_client_pi_kernel "/mnt/host/kernels/raspberry_pi"





    ##### 👆 In Host and `$HOME/repos/kernels` directory (🖥️ in the case of Raspberry Pi 4, 64-bit)

    ### Download kernel source
    git clone --depth=1 --single-branch https://github.com/raspberrypi/linux raspberry_pi
    cd raspberry_pi


    ### Install the build dependencies
    sudo apt install -y bc bison flex libssl-dev make
    # Install the build dependencies for Cross-compiling the kernel
    sudo apt install -y libc6-dev libncurses5-dev
    # Install the 64-bit toolchain for Cross-compiling the kernel
    sudo apt install -y crossbuild-essential-arm64



    ### Build configuration
    set -gx KERNEL kernel8
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig

    ##🏷️ Customize the kernel version using LOCALVERSION

    set config_file ".config"
    set unique_comment '## ⚙️ Customize the kernel version (Override)'

    if not grep -Fxq "$unique_comment" "$config_file"
        echo "
        $unique_comment"'
        CONFIG_LOCALVERSION="-v8-synergy_hub"
        ' | prettify_indent_via_pipe | tee -a "$config_file" >/dev/null
        echo -e "\n" >> "$config_file"
    end



    ### Build
    # 📝 In this project the device tree is not modified so only Image and modules need to be built
    make -j{$jobs_core_n} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules
    # make -j{$jobs_core_n} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs

    ## If boot media is mounted
    # sudo env PATH=$PATH make -j{$jobs_core_n} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=mnt/root modules_install





    ##### 👆 Deploy Image

    cp arch/arm64/boot/Image /nfs/$KERNEL.img
  ```

&nbsp;

---

#### 🖥️ Hardware

- **Raspberry Pi 4B**

- [**RPi GPIO Breakout Expansion Board** + **Ribbon Cable** + **Assembled T Type GPIO Adapter FC40 40pin Flat Ribbon Cable** (for Raspberry Pi B+ Kit)](https://www.amazon.com/dp/B08D3S6FGH?ref_=cm_sw_r_cp_ud_dp_J1TGSNSHCBW76PJJ9VF3&newOGT=1)

- [NEWTC 🔪 LEDs 🔪 **AM-TL8**](https://www.devicemart.co.kr/goods/view?no=6772)

  - [Manual](https://www.newtc.co.kr/dpshop/bbs/board.php?bo_table=m45&wr_id=41&sfl=&stx=&sst=wr_hit&sod=desc&sop=and&page=8)
    - 5V

- [NEWTC 🔪 Buttons 🔪 **AM-TS8**](https://www.devicemart.co.kr/goods/view?no=11701)
  - [Manual](https://newtc.co.kr/dpshop/bbs/board.php?bo_table=m41&wr_id=48&page=11)
    - 5V

&nbsp;

##### GPIO Pinout Table

- ⚪: Available (Not Configured)
- 🟢: Assigned with Configuration
- 🎛️: Assigned with Configuration but Not physically connected

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

&nbsp;

---

### 📁 Directory Structure

├── 📂 **app**  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [Makcefile](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/app/Makefile)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 **src**  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 **include**  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [kernel_timer_app.c](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/app/src/kernel_timer_app.c)  
├── 📂 **build**  
├── 📂 **include**  
│&nbsp;&nbsp;&nbsp;&nbsp;└── [ioctl_test.h](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/include/ioctl_test.h)  
├── [kernel_timer_app copy.c](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/kernel_timer_app%20copy.c)  
├── [Makefile](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/Makefile)  
├── 📂 **module**  
│&nbsp;&nbsp;&nbsp;&nbsp;├── [Makefile](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/module/Makefile)  
│&nbsp;&nbsp;&nbsp;&nbsp;└── 📂 **src**  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── 📂 **include**  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── [kernel_timer_dev.c](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/module/src/kernel_timer_dev.c)  
├── [pipeline.fish](prototypes/study/bsp_study/raspberry_pi/drivers/kernel_timer/pipeline.fish)  
└── 📂 **test**

&nbsp;

---

## Retrospective

### 📌 Key Learnings and Improvements

1. **하드웨어 문서화**

   ➡️ 하드웨어 모델에 대한 포괄적인 문서 작성, **데이터시트 링크 포함**, 팀의 접근성과 이해를 향상시키는 작업.

   - 하드웨어 모델과 그 사양이 잘 문서화되어 있는지 확인하는 작업.

2. **디렉터리 명명 규칙**

   ➡️ 향후 프로젝트에서 일관적이고 표준화된 용어 사용으로 명확성을 개선하는 작업.

   - 이 프로젝트에서 "peripheral"이라는 디렉터리 이름이 사용되었으나, 임베디드 시스템에서 종종 하드웨어 레지스터를 의미하기 때문에 혼란을 초래함.
   - 향후 프로젝트에서는 ❗ **"device"**와 같은 더 표준적이고 널리 사용되는 용어를 채택해야 함.
     - 예시 (Wiktionary 참조):
       - [Device](https://en.wiktionary.org/wiki/device): 주변 장치; 하드웨어 항목.
       - [Peripheral Device](https://en.wiktionary.org/wiki/peripheral_device#English): 컴퓨터에서 사용하는 외부 전자 장치.

3. **C에서의 OOP 개념을 위한 명명 규칙**

   ➡️ 임베디드 시스템에서 산업 표준 명명 규칙을 조사하여 모범 사례를 확보하는 작업.

   - C에서 OOP 원칙을 따르려는 시도는 특히 구조체의 캡슐화 부족으로 인해 어려움이 있었음.
   - 🚣 모듈 이름(PascalCase)을 함수 이름(camelCase)에 접두어로 붙여 OOP 구조를 모방하는 명명 규칙 채택.
   - 예시:
     ```c
     static void _Fnd_setFndNum(fnd_t* fnd, uint16_t value) {
         fnd->value = value;
     }
     ```

4. **FSM 설계 과제**

   ➡️ 기능을 유지하면서 FSM 설계를 더욱 간단하게 만들 대안을 탐색하는 작업.

   - 초기 FSM 설계는 지나치게 복잡하고 관리하기 어려웠음(참조: [이전 FSM 다이어그램](resource/previous_FSM.png)).
   - 설계를 재평가한 후, 더 **직관적이고 단순한 구조**가 가능함이 드러남.
   - **교훈**: 구현 전에 더 많은 시간을 들여 신중하게 설계하는 작업. 개선되고 간결한 FSM은 🔗 "\[FSM \(Finite State Machine\)\]"에서 참조 가능.

5. **인터럽트 처리와 디스플레이 효율 개선**

   - FND 디스플레이 효율성과 관련하여 원자성 문제 및 불필요한 계산과 같은 이슈가 발생함.
   - 💡 **인터럽트 내부에서의 계산 최소화** 및 복잡한 계산이 필요한 경우 간격을 늘려 다른 시간에 민감한 작업과의 간섭을 방지하는 작업.

---
