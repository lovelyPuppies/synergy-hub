# Understanding Key Concepts: APB1, APB2, CCR, ARR, and PWM Period

This document explains the acronyms and the functionality of APB1, APB2, CCR, ARR, and the concept of PWM period with respect to the STM32 Nucleo F411RE board.

---

## 1. Acronyms

### **APB1 and APB2**
- **APB** stands for **Advanced Peripheral Bus**.
- STM32 microcontrollers divide peripherals into two buses:
  - **APB1**: Lower-speed peripherals like TIM3, UART2, and I2C.
  - **APB2**: High-speed peripherals like GPIO, SPI1, ADC, and TIM1.

### **CCR**
- **CCR** stands for **Capture/Compare Register**.
- It is used to store a value that:
  - In **PWM mode**, determines the duty cycle.
  - In **input capture** or **output compare modes**, defines a specific timer value for capturing or comparing events.

### **ARR**
- **ARR** stands for **Auto-Reload Register**.
- It determines the timer’s maximum count value before it resets to 0 and starts counting again.
- The timer counts from 0 to `ARR`. Once it reaches `ARR`, the **overflow** occurs, and the counter resets.

---

## 2. PWM and Period: How It Works

The **Period** in PWM refers to the total time of one complete cycle of the PWM signal (ON + OFF).

### **1. Timer and Period Relationship**
- The timer **counts from 0 to ARR**.
- Once the counter reaches ARR, the timer resets to 0 and starts a new cycle.

### **2. PWM Signal Output**
- The **CCR** value determines the duration the signal is HIGH (ON).
- When the timer value matches the CCR, the signal toggles from HIGH to LOW.

### **3. Visual Representation**
```
Timer Counting:  0 ----> CCR ----> ARR ----> 0 ----> CCR ----> ARR
                 |    ON     |    OFF   |    ON     |    OFF   |
```

### **4. What Happens at the Period?**
- The timer **resets when it reaches ARR**.
- This reset defines one full **PWM period**.
- The frequency of the PWM signal is inversely proportional to the Period:
  ```text
  PWM Frequency = Timer Clock / (ARR + 1)
  ```

---

## 3. Summary of the Key Relationship: CCR ÷ ARR

The duty cycle of the PWM is calculated using:
```text
Duty Cycle (%) = (CCR / ARR) × 100
```
- **CCR** defines how long the signal is HIGH within one period.
- **ARR** defines the total count range of the timer (hence the full PWM cycle).

---

## 4. Example: PWM on STM32 (Nucleo F411RE)

### **Timer Configuration**
- Timer clock (after prescaler): 1 MHz.
- ARR = 1000 (corresponds to 1 ms period → 1 kHz PWM frequency).
- CCR = 500 (50% duty cycle).

### **What Happens During the Timer Cycle?**
1. Timer counts from 0 to ARR (1000):
   - At `CCR = 500`, the signal goes LOW (ends the ON state).
   - At `ARR = 1000`, the signal resets, starting a new cycle.
2. The PWM signal alternates between HIGH for 500 counts and LOW for 500 counts.

---

## 5. Clarification of Your Question

### **Does the timer count to `Period` and then output a signal once?**
No. The **PWM signal** is continuously generated as follows:
- During each timer cycle (from 0 to ARR):
  - The signal is HIGH from 0 to CCR.
  - The signal is LOW from CCR to ARR.
- This repeats continuously, creating the PWM waveform.

In short, **the timer doesn't output a single signal at the Period**. Instead:
- It outputs a toggling signal (HIGH/LOW) controlled by the CCR and ARR values.

---

## 6. Final Notes
- The timer provides fine-grained control over both the frequency (via ARR) and the duty cycle (via CCR).
- For the Nucleo F411RE, the APB1 clock, prescaler, ARR, and CCR together determine how the PWM signal behaves.

Let me know if you need further clarification or examples!
