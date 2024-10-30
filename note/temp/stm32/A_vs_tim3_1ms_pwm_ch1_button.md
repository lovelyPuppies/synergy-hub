# Analysis of Changes: A Code vs. tim3_1ms_pwm_ch1_button

This document provides an in-depth analysis of the differences between the `A` code and the `tim3_1ms_pwm_ch1_button` code. It explains the key changes, their implications, and detailed explanations of how these differences impact the functionality.

---

## 1. Summary of Differences

### **1.1 Basic Functionality**

- **A Code**:
  - Toggles an LED (connected to GPIOA, PIN 5) every 100ms using a simple delay loop (`HAL_Delay`).
  - Minimal configuration with no peripherals except for GPIO and UART.

- **`tim3_1ms_pwm_ch1_button`**:
  - Uses TIM3 for generating PWM signals on TIM3 Channel 1.
  - Introduces button inputs to modify the PWM duty cycle dynamically.
  - Outputs debugging information via UART using `printf`.
  - Employs advanced timer features such as interrupts for precise timing and event-driven GPIO control.

---

### **1.2 Added Features**

| Feature                        | A Code                  | tim3_1ms_pwm_ch1_button       |
|--------------------------------|-------------------------|--------------------------------|
| **GPIO**                       | Simple LED Toggle       | Buttons + LED Toggle          |
| **Timer Usage**                | None                    | TIM3 with PWM and interrupts  |
| **PWM Output**                 | No                      | Yes                           |
| **Button Inputs**              | No                      | Handles 4 buttons             |
| **UART Debugging**             | None                    | Outputs dynamic status         |

---

## 2. Key Technical Differences

### **2.1 TIM3 Configuration**

- **TIM3 Usage**:
  - In the new code, TIM3 is configured for PWM generation and periodic interrupts (1ms).
  - TIM3 is set with the following parameters:
    - **Prescaler**: `84-1` (generates a 1MHz timer clock).
    - **Period**: `1000-1` (results in a PWM frequency of 1kHz).

- **PWM Duty Cycle Control**:
  - Duty cycle is dynamically controlled using a variable `pluse`, which ranges from 0 to 1000.
  - The `Compare` value determines the duty cycle using the formula:
    ```text
    Duty Cycle (%) = (Compare / Period) × 100
    ```

---

### **2.2 Button Input Handling**

- **Buttons Configuration**:
  - 4 buttons are added, each triggering an interrupt upon being pressed.
  - GPIO pins `PC0`, `PC1`, `PC2`, `PC3` are configured for EXTI interrupts.

- **Functionality of Each Button**:
  | Button | GPIO Pin | Action                                             |
  |--------|----------|----------------------------------------------------|
  | BTN1   | PC0      | Decrease duty cycle by 10% (pluse -= 100)          |
  | BTN2   | PC1      | Increase duty cycle by 10% (pluse += 100)          |
  | BTN3   | PC2      | Store current duty cycle and set it to 0 (OFF)     |
  | BTN4   | PC3      | Restore the previously saved duty cycle (pluseOld) |

---

### **2.3 Timing Enhancements**

- **1ms Interrupt**:
  - TIM3 generates an interrupt every 1ms. This is used for:
    - Updating a millisecond counter (`tim3Cnt`).
    - Toggling LEDs every second (`tim3Flag1Sec`).

---

### **2.4 UART Integration**

- **UART for Debugging**:
  - UART2 is initialized to provide debugging information.
  - The `printf` function is redirected to use UART for transmitting messages like:
    ```c
    printf("keyNo : %u, pluse : %d\\r\\n", keyNo, pluse);
    ```

---

## 3. Detailed Explanation of PWM and Timer Configuration

### **3.1 PWM and Duty Cycle**

The `tim3_1ms_pwm_ch1_button` code uses TIM3 for PWM signal generation on TIM3 Channel 1. Key parameters:

- **Prescaler**:
  - Set to `84-1`, reducing the 84MHz APB1 clock to 1MHz.
  - This means the timer increments every 1µs.

- **Period**:
  - Set to `1000-1` (999), so the timer completes one cycle in 1000µs (1ms).
  - PWM frequency = 1kHz.

- **Compare Value (`pluse`)**:
  - Determines the ON time of the PWM signal.
  - Ranges from 0 (0% duty cycle) to 1000 (100% duty cycle).

---

### **3.2 Timer Interrupts**

- **1ms Timer Interrupt**:
  - The TIM3 interrupt service routine (`HAL_TIM_PeriodElapsedCallback`) is called every 1ms.
  - It updates a counter (`tim3Cnt`) and sets a flag (`tim3Flag1Sec`) every 1000ms.

---

## 4. Full Workflow of `tim3_1ms_pwm_ch1_button`

1. **System Initialization**:
   - HAL library is initialized.
   - TIM3 and UART2 are configured.
   - GPIO pins for buttons and LED are set.

2. **PWM and Interrupts**:
   - TIM3 starts generating PWM signals on Channel 1.
   - Periodic 1ms interrupts update the internal timer counters.

3. **Button Handling**:
   - When a button is pressed, an EXTI interrupt is triggered.
   - The button action (e.g., increase/decrease duty cycle) is processed.

4. **UART Debugging**:
   - Current status of the PWM signal and button states are output via UART.

---

## 5. Why is the Duty Cycle Maximum 1000?

- The maximum duty cycle (`pluse = 1000`) corresponds to the TIM3 Period setting (`1000-1`).
- Since the timer counts from 0 to 999, this allows a full ON state (100% duty cycle) when the Compare value equals the Period value.

---

## 6. Complete Explanation of TIM3 Settings from ioc File

The following TIM3 settings were extracted from the `.ioc` file:

- **Prescaler**: `84-1` (Timer clock = 1MHz).
- **Period**: `1000-1` (PWM frequency = 1kHz).
- **Pulse**: Initial Compare value = `0` (0% duty cycle).
- **Mode**: PWM Generation (Channel 1).

---

## 7. Conclusion

The `tim3_1ms_pwm_ch1_button` code demonstrates advanced usage of STM32 peripherals, including:
- PWM generation using TIM3.
- Interrupt-driven button handling.
- UART debugging for real-time monitoring.

Compared to the simple LED toggle functionality in the `A` code, this enhanced code provides a robust and interactive embedded system for real-world applications.
