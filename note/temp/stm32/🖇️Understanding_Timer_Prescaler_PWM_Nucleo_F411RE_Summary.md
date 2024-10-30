# Understanding Timer, Prescaler, and PWM in STM32 (Nucleo F411RE)

This document provides an in-depth explanation of timers, prescalers, and PWM configuration specifically for the STM32 Nucleo F411RE. It covers the technical details and practical calculations to help you understand their operation.

---

## 1. Timers in STM32
Timers are versatile hardware peripherals that can:
- Measure time intervals.
- Generate PWM signals.
- Count external events.
- Create precise time delays.

---

## 2. Prescaler and Its Role

The **prescaler** divides the timer's input clock frequency, effectively slowing down the counting speed.

### **How the Prescaler Works**
1. **Input Clock Frequency**:
   For the Nucleo F411RE, the timer clock source for TIM3 is derived from the **APB1 timer clock**, which is **84 MHz**:
   ```plaintext
   RCC.APB1TimFreq_Value = 84 MHz
   ```

2. **Prescaler Calculation**:
   - The prescaler divides the input clock by `(Prescaler + 1)`.
   - From the `.ioc` file:
     ```plaintext
     TIM3.Prescaler = 84 - 1
     ```
     This results in:
     ```plaintext
     Timer Clock = 84 MHz ÷ 84 = 1 MHz
     ```
   - Now, the timer increments its counter every **1 µs**.

---

## 3. PWM Period and Timer Auto-Reload Register (ARR)

The **PWM period** is controlled by the **Auto-Reload Register (ARR)**, which determines the maximum count value before the timer resets to 0.

### **Period and PWM Frequency**
1. **ARR Setting**:
   - From the `.ioc` file:
     ```plaintext
     TIM3.Period = 1000 - 1
     ```
   - This sets the ARR to `999`, meaning the timer counts from `0` to `999` in one cycle.

2. **PWM Frequency**:
   - The timer period is calculated as:
     ```plaintext
     Period (seconds) = (ARR + 1) ÷ Timer Clock
     ```
     Substituting values:
     ```plaintext
     Period = (999 + 1) ÷ 1 MHz = 1000 µs = 1 ms
     ```
   - Therefore, the PWM frequency is:
     ```plaintext
     PWM Frequency = 1 ÷ Period
                   = 1 ÷ 1 ms
                   = 1 kHz
     ```

---

## 4. PWM Duty Cycle and Compare Register (CCR)

The **duty cycle** is controlled by the timer's **Compare Register (CCR)**. It specifies how long the output signal stays HIGH during each cycle.

### **Duty Cycle Formula**
```plaintext
Duty Cycle (%) = (CCR ÷ ARR) × 100
```

### **Example**
- If `ARR = 999` and:
  - `CCR = 1000`: Duty cycle = `100%` (always HIGH).
  - `CCR = 500`: Duty cycle = `50%` (HIGH for half the period).
  - `CCR = 0`: Duty cycle = `0%` (always LOW).

---

