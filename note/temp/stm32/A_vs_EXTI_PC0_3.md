# Analysis of Changes: A Code vs. EXTI_PC0_3

## 1. Header Inclusion

- **A Code:**
  ```c
  /* USER CODE BEGIN Includes */
  /* USER CODE END Includes */
  ```

- **EXTI_PC0_3 Code:**
  ```c
  /* USER CODE BEGIN Includes */
  #include <stdio.h>
  /* USER CODE END Includes */
  ```
  - Added `#include <stdio.h>` for using the `printf` function with UART.

---

## 2. Global Variables

- **A Code:**
  - No global variables.

- **EXTI_PC0_3 Code:**
  ```c
  volatile int keyNo;
  ```
  - Introduced `keyNo` to store the button event triggered by external interrupts.

---

## 3. GPIO Initialization

### Added Pin Configurations

- **A Code:**
  - Configures only GPIOC_13 (B1_Pin, button) for input:
    ```c
    GPIO_InitStruct.Pin = B1_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(B1_GPIO_Port, &GPIO_InitStruct);
    ```

- **EXTI_PC0_3 Code:**
  - Configures multiple pins for external interrupts:
    ```c
    GPIO_InitStruct.Pin = BTN0_Pin | BTN1_Pin | BTN2_Pin | BTN3_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

    GPIO_InitStruct.Pin = BTN4_Pin | BTN5_Pin | BTN6_Pin | BTN7_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
    ```

### EXTI and NVIC Configuration

- **A Code:**
  - No EXTI or NVIC configuration.

- **EXTI_PC0_3 Code:**
  ```c
  HAL_NVIC_SetPriority(EXTI0_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI0_IRQn);
  HAL_NVIC_SetPriority(EXTI1_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI1_IRQn);
  HAL_NVIC_SetPriority(EXTI2_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI2_IRQn);
  HAL_NVIC_SetPriority(EXTI3_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI3_IRQn);
  HAL_NVIC_SetPriority(EXTI4_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI4_IRQn);
  HAL_NVIC_SetPriority(EXTI9_5_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI9_5_IRQn);
  ```

---

## 4. Main Loop

- **A Code:**
  - Simple LED toggling:
    ```c
    HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_5);
    HAL_Delay(100);
    ```

- **EXTI_PC0_3 Code:**
  - Outputs `keyNo` value via UART if set:
    ```c
    if (keyNo != 0) {
        printf("keyNo : %d\r\n", keyNo);
        keyNo = 0;
    }
    ```

---

## 5. Callback Functions

- **A Code:**
  - No callback functions.

- **EXTI_PC0_3 Code:**
  ```c
  void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) {
      switch (GPIO_Pin) {
          case BTN0_Pin: keyNo = 1; break;
          case BTN1_Pin: keyNo = 2; break;
          case BTN2_Pin: keyNo = 3; break;
          case BTN3_Pin: keyNo = 4; break;
          case BTN4_Pin: keyNo = 5; break;
          case BTN5_Pin: keyNo = 6; break;
          case BTN6_Pin: keyNo = 7; break;
          case BTN7_Pin: keyNo = 8; break;
      }
  }
  ```

---

## 6. UART Configuration and Output Redirection

- **A Code:**
  - Basic UART initialization without `printf` integration.

- **EXTI_PC0_3 Code:**
  - Added UART output redirection for `printf`:
    ```c
    #ifdef __GNUC__
    #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
    #else
    #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
    #endif

    PUTCHAR_PROTOTYPE {
        HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, 0xFFFF);
        return ch;
    }
    ```

---

## 7. System Clock Configuration

- **A Code:**
  - Uses the internal high-speed oscillator (HSI):
    ```c
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    ```

- **EXTI_PC0_3 Code:**
  - Uses the external high-speed oscillator (HSE):
    ```c
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    ```

---

## 8. Debug Messages

- **EXTI_PC0_3 Code Only:**
  ```c
  printf("start main() - exti_pc0_3\r\n");
  ```

---

## Summary of Changes

1. Header file addition (`stdio.h`).
2. Global variable addition (`keyNo`).
3. GPIO initialization updated with new pins and modes.
4. NVIC configuration for external interrupts.
5. Main loop logic altered for event-driven behavior.
6. Callback function for EXTI added.
7. UART redirection added for `printf`.
8. Clock source switched from HSI to HSE.
9. Debug messages introduced.
