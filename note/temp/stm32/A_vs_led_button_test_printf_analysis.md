# Analysis of Changes: A Code vs. led_button_test_printf Code

## Overview

This document outlines the detailed differences between the **A Code** and the **led_button_test_printf** code. The changes primarily include UART debugging enhancements, additional GPIO functionalities, system clock configurations, and considerations for pull-up and pull-down circuit configurations.

---

## 1. Key Changes Summary

- **UART Debugging (`printf`)**: The `led_button_test_printf` code incorporates `printf` functionality for debugging via UART.
- **New Button and LED Control Logic**: Additional buttons and LEDs (TEST_BTN and TEST_LED) are introduced and controlled.
- **System Clock Source Modification**: The system clock source changes from HSI to HSE in the `led_button_test_printf` code.
- **Main Loop Logic Update**: Transition from a basic LED toggle loop to button-based state reading and LED control with UART output.
- **Pull-up and Pull-down Circuit Considerations**: Logic for buttons considers their connection to pull-up or pull-down circuits.

---

## 2. Detailed Changes

### 2.1 `printf` and UART Redirection
- **A Code**: No `printf` functionality.
- **led_button_test_printf Code**:
  - `printf` is redirected to UART using the following implementation:
    ```c
    #ifdef __GNUC__
    #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
    #else
    #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
    #endif /* __GNUC__ */

    PUTCHAR_PROTOTYPE
    {
      HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, 0xFFFF);
      return ch;
    }
    ```

### 2.2 GPIO Pin Initialization and Expansion
- **A Code**:
  - Initializes GPIO for LD2 (LED) and B1 (button) only.
- **led_button_test_printf Code**:
  - Adds TEST_BTN (button) and TEST_LED (LED):
    ```c
    /* Configure GPIO pin : TEST_BTN_Pin */
    GPIO_InitStruct.Pin = TEST_BTN_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(TEST_BTN_GPIO_Port, &GPIO_InitStruct);

    /* Configure GPIO pin : TEST_LED_Pin */
    GPIO_InitStruct.Pin = TEST_LED_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(TEST_LED_GPIO_Port, &GPIO_InitStruct);
    ```

### 2.3 Main Loop Logic Update
- **A Code**:
  - A simple loop toggles the LD2 LED every 100 ms.
    ```c
    HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_5);
    HAL_Delay(100);
    ```
- **led_button_test_printf Code**:
  - Reads the states of B1 and TEST_BTN buttons, controls corresponding LEDs (LD2 and TEST_LED), and outputs button states via UART:
    ```c
    int B1_State = !HAL_GPIO_ReadPin(B1_GPIO_Port, B1_Pin);
    printf("B1_State : %d\n\r", B1_State);
    HAL_GPIO_WritePin(LD2_GPIO_Port, LD2_Pin, B1_State);

    int BTN_State = HAL_GPIO_ReadPin(TEST_BTN_GPIO_Port, TEST_BTN_Pin);
    printf("BTN_State : %d\n\r", BTN_State);
    HAL_GPIO_WritePin(TEST_LED_GPIO_Port, TEST_LED_Pin, BTN_State);

    HAL_Delay(500);
    ```

### 2.4 System Clock Configuration
- **A Code**:
  - Uses the internal high-speed clock (HSI).
    ```c
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
    ```
- **led_button_test_printf Code**:
  - Switches to the external high-speed clock (HSE).
    ```c
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLM = 8;
    ```

### 2.5 Pull-up and Pull-down Circuit Considerations
- **Explanation for `!` in B1_State**:
  - The `B1` button is likely connected to a **pull-up circuit**, where the default (non-pressed) state is `HIGH (1)`. 
  - When the button is pressed, the state changes to `LOW (0)`.
  - To make the logic intuitive (pressed = `1`, not pressed = `0`), the `!` operator is used to invert the state.
    ```c
    int B1_State = !HAL_GPIO_ReadPin(B1_GPIO_Port, B1_Pin);
    ```

- **Explanation for `BTN_State`**:
  - The `TEST_BTN` button is likely connected to a **pull-down circuit**, where the default (non-pressed) state is `LOW (0)`.
  - When the button is pressed, the state changes to `HIGH (1)`.
  - Since the logic matches the circuit directly, no `!` operator is needed.
    ```c
    int BTN_State = HAL_GPIO_ReadPin(TEST_BTN_GPIO_Port, TEST_BTN_Pin);
    ```

---

## 3. Functional Differences
| **Aspect**         | **A Code**                  | **led_button_test_printf Code**         |
|---------------------|-----------------------------|------------------------------------------|
| **UART Debugging**  | Not present                | `printf` with UART2                     |
| **LED Control**     | LD2 toggles periodically   | Based on B1 and TEST_BTN states         |
| **Button Handling** | Not present                | Reads B1 and TEST_BTN states            |
| **System Clock**    | Internal HSI clock         | External HSE clock                      |
| **GPIO Pins Used**  | LD2, B1                    | LD2, B1, TEST_BTN, TEST_LED             |
| **Pull-up/Down Test** | Not applicable            | Handles pull-up and pull-down circuits  |

---

## 4. Notes on Implementation
- **External Clock (HSE)**: Ensure proper hardware configuration when switching to HSE.
- **GPIO Connectivity**: Verify the connection of new buttons and LEDs (TEST_BTN and TEST_LED) to avoid incorrect operation.
- **UART Debugging**: The `printf` functionality relies on UART being connected to a host machine for debugging.

---

