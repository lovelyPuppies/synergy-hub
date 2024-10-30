
# Code Analysis: Changes from `A` to `nucleo_f411re_uart2_printf_uart6_wifi_tm3_adc2ch`

## Summary of Changes

### 1. Major Differences

#### UART2 Enhancements:
- Added support for `printf` using UART2 for debugging and data output.
- Integrated standard output with UART using the `__io_putchar` function.

#### Integration of UART6 and Wi-Fi Module:
- Introduced `esp.h` library for communication with the ESP module.
- Added Wi-Fi control and data transmission/reception logic.

#### ADC with DMA:
- Configured ADC1 with DMA to periodically read two ADC channels.
- Data collection triggered using a timer interrupt (TIM3).

#### TIM3 Timer Integration:
- Implemented time-based operations using TIM3 interrupts (1-second and 5-second intervals).
- Added logic for periodic LED toggling and ADC reading.

#### Expanded GPIO Control:
- Added user-defined functions (`MX_GPIO_LED_ON` and `MX_GPIO_LED_OFF`) for LED control.
- Enabled remote control of LEDs via Wi-Fi commands.

---

### 2. Code Comparison

#### **A Code Loop**
```c
while (1) {
  HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_5);
  HAL_Delay(100); // Toggle LED at 100ms intervals
}
```

#### **`nucleo_f411re_uart2_printf_uart6_wifi_tm3_adc2ch` Loop**
```c
while (1) {
  if (strstr((char *)cb_data.buf, "+IPD") && cb_data.buf[cb_data.length - 1] == '
') {
    strcpy(strBuff, strBuff((char *)cb_data.buf, '['));
    memset(cb_data.buf, 0x0, sizeof(cb_data.buf));
    cb_data.length = 0;
    esp_event(strBuff);
  }
  if (rx2Flag) {
    printf("recv2 : %s
", rx2Data);
    rx2Flag = 0;
  }
  if (tim3Flag1Sec) {
    tim3Flag1Sec = 0;
    if (!(tim3Sec % 5)) {
      HAL_ADC_Start_DMA(&hadc1, (uint32_t *)ADCxConvertValue, 2);
    }
    if (adcFlag) {
      adcFlag = 0;
      printf("tim3Sec=%d, VAR=%4d, CDS=%4d
", tim3Sec, ADCxConvertValue[0], ADCxConvertValue[1]);
    }
  }
}
```

#### **Timer and ADC Interrupts**
```c
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim) {
  tim3Cnt++;
  if (tim3Cnt == 1000) { // 1ms * 1000 = 1 second
    tim3Flag1Sec = 1;
    tim3Sec++;
    tim3Cnt = 0;
  }
}

void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef *AdcHandle) {
  adcFlag = 1;
}
```

---

### 3. Key Added Features

#### (1) Wi-Fi Communication and ESP Event Handling
The `esp_event` function processes incoming Wi-Fi data and performs actions like LED control or data transmission.

```c
void esp_event(char *recvBuf) {
  int i = 0;
  char *pToken;
  char *pArray[ARR_CNT] = {0};
  char sendBuf[MAX_UART_COMMAND_LEN] = {0};

  pToken = strtok(recvBuf, "[@]");
  while (pToken != NULL) {
    pArray[i] = pToken;
    if (++i >= ARR_CNT)
      break;
    pToken = strtok(NULL, "[@]");
  }

  if (!strcmp(pArray[1], "LED")) {
    if (!strcmp(pArray[2], "ON")) {
      MX_GPIO_LED_ON(LD2_Pin);
    } else if (!strcmp(pArray[2], "OFF")) {
      MX_GPIO_LED_OFF(LD2_Pin);
    }
    sprintf(sendBuf, "[%s]%s@%s
", pArray[0], pArray[1], pArray[2]);
    esp_send_data(sendBuf);
  }
}
```

#### (2) ADC Configuration and Data Handling
ADC1 is configured to read two channels, with results handled via DMA.

```c
static void MX_ADC1_Init(void) {
  hadc1.Instance = ADC1;
  hadc1.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV6;
  hadc1.Init.Resolution = ADC_RESOLUTION_12B;
  hadc1.Init.ScanConvMode = ENABLE;
  hadc1.Init.ContinuousConvMode = DISABLE;
  hadc1.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
  hadc1.Init.ExternalTrigConv = ADC_SOFTWARE_START;
  hadc1.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  hadc1.Init.NbrOfConversion = 2;
  hadc1.Init.DMAContinuousRequests = ENABLE;
  hadc1.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
  HAL_ADC_Init(&hadc1);
}
```

#### (3) UART `printf` Support
Enhanced UART functionality to support `printf` for debugging.

```c
#ifdef __GNUC__
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif /* __GNUC__ */

PUTCHAR_PROTOTYPE {
  HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, HAL_MAX_DELAY);
  return ch;
}
```

---

### 4. Conclusion

| Feature                       | A Code | `nucleo_f411re_uart2_printf_uart6_wifi_tm3_adc2ch` |
|-------------------------------|--------|----------------------------------------------------|
| GPIO LED Control              | Basic  | Enhanced with remote control via Wi-Fi            |
| UART Support                  | Yes    | Extended with `printf` integration                |
| Timer (TIM3)                  | No     | 1-second and 5-second interval tasks              |
| ADC and DMA                   | No     | Added for real-time data collection               |
| Wi-Fi Communication           | No     | Integrated for remote control and data exchange   |

The new code greatly enhances functionality, providing support for real-time operations, data monitoring, and remote control via Wi-Fi. These additions make it suitable for more complex embedded applications.
