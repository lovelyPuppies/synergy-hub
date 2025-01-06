# Kernel Timer Mini Project

📅 Written at 2025-01-02 07:43:25

- [Kernel Timer Mini Project](#kernel-timer-mini-project)
  - [Project Introduction](#project-introduction)
    - [Features](#features)
    - [🎯 Project Purposes](#-project-purposes)
    - [🖼️ Hardware Setup](#️-hardware-setup)
    - [🎥 Kernel Timer Demo](#-kernel-timer-demo)
  - [🌐 Project Overview](#-project-overview)
    - [🛠️ Tools](#️-tools)
      - [\[🧑‍💻 Software\]](#-software)
      - [\[🖥️ Hardware\]](#️-hardware)
    - [📁 Directory Structure](#-directory-structure)
    - [📖 Design Patterns and Benefits](#-design-patterns-and-benefits)
      - [Layer Overview](#layer-overview)
      - [Applied Design Pattern](#applied-design-pattern)
      - [❗ Benefits of the Design](#-benefits-of-the-design)
    - [FSM (Finite State Machine)](#fsm-finite-state-machine)
      - [🎛️ Inputs (Button Definitions)](#️-inputs-button-definitions)
      - [📊 Diagram](#-diagram)
  - [Retrospective](#retrospective)
    - [📌 Key Learnings and Improvements](#-key-learnings-and-improvements)

## Project Introduction

This project demonstrates the implementation of a kernel timer module on Linux for edge devices. It integrates hardware-based interrupts, user-space applications, and kernel space logic for managing timers and GPIO operations.

### Features

(e.g. 선풍기의 경우)

- 전원 제어: 선풍기 전원을 켜거나 끌 수 있음.
- 팬 속도 조절: 저속, 중속, 고속으로 팬 속도를 변경 가능.
- 모드 전환: 수동 모드와 자동 모드 간 전환 가능.
- 타이머 설정: 3, 5, 7분 타이머 설정으로 자동 종료.
- 상태 표시: LCD 및 FND로 현재 모드, 속도, 타이머 상태 표시.

### 🎯 Project Purposes

- Implement a kernel timer with start, stop, and configuration functionalities.
- Develop a user-space application to interact with the kernel module via ioctl calls.
- Showcase GPIO-based LED control and button inputs using kernel drivers.

### 🖼️ Hardware Setup

- **Breadboard Setup**: (TODO: I will add this)

### 🎥 Kernel Timer Demo

- Demo video showcasing the kernel timer in action: `demo_video.mp4`.

## 🌐 Project Overview

### 🛠️ Tools

#### [🧑‍💻 Software]

- **Kernel Version**: Raspberry Pi Linux Kernel.
- **Compiler**: `clang` for user application and kernel module.
- **Tools**: `make`, `poll`, `ioctl`.

#### [🖥️ Hardware]

- Raspberry Pi 4B or compatible.
- Breadboard, LEDs, buttons, and necessary wiring.

### 📁 Directory Structure

```
project/
├── Makefile
├── kernel_timer_app.c
├── kernel_timer_dev.c
├── ioctl_test.h
└── README.md
```

### 📖 Design Patterns and Benefits

#### Layer Overview

- User application interacts with the kernel module using ioctl and standard file operations.

#### Applied Design Pattern

- **Driver Model**: Encapsulates GPIO and timer logic within the driver.
- **Ioctl Command Pattern**: Simplifies communication between user and kernel space.

#### ❗ Benefits of the Design

- Clear separation between user and kernel logic.
- Flexible timer configurations.
- Modular and reusable driver design.

### FSM (Finite State Machine)

#### 🎛️ Inputs (Button Definitions)

- Button 1: Start the timer.
- Button 2: Input timer value via stdin.
- Button 3: Input LED value via stdin.
- Button 4: Stop the timer.
- Button 8: Stop the timer and exit the application.

#### 📊 Diagram

FSM diagram illustrating button-triggered state transitions: `fsm_diagram.png`.

## Retrospective

### 📌 Key Learnings and Improvements

- Integration of poll and blocking I/O for efficient device interaction.
- Improved driver reliability through robust error handling.
- Enhanced user experience with dynamic input validation.

---
