#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "esp.h"

static char ip_addr[16];
static char response[MAX_ESP_RX_BUFFER];
//==================uart2=========================
UART_HandleTypeDef huart2;
volatile unsigned char rx2Flag = 0;
volatile char rx2Data[50];
uint8_t cdata;

//==================uart6=========================
extern volatile unsigned char rx2Flag;
extern volatile char rx2Data[50];
extern uint8_t cdata;
//extern UART_HandleTypeDef huart2;
static uint8_t data;
//static cb_data_t cb_data;
cb_data_t cb_data;
UART_HandleTypeDef huart6;
static int esp_at_command(uint8_t *cmd, uint8_t *resp, uint16_t *length,
                          int16_t time_out) {
  *length = 0;
  memset(resp, 0x00, MAX_UART_RX_BUFFER);
  memset(&cb_data, 0x00, sizeof(cb_data_t));
  if (HAL_UART_Transmit(&huart6, cmd, strlen((char *)cmd), 100) != HAL_OK)
    return -1;

  while (time_out > 0) {
    if (cb_data.length >= MAX_UART_RX_BUFFER)
      return -2;
    else if (strstr((char *)cb_data.buf, "ERROR") != NULL)
      return -3;
    else if (strstr((char *)cb_data.buf, "OK") != NULL) {
      memcpy(resp, cb_data.buf, cb_data.length);
      *length = cb_data.length;

      break;
    }

    time_out -= 10;
    HAL_Delay(10);
  }
  HAL_Delay(500);
  return 0;
}

static int esp_reset(void) {
  uint16_t length = 0;
  if (esp_at_command((uint8_t *)"AT+RST\r\n", (uint8_t *)response, &length,
                     1000) != 0) {
    return -1;
  }
  return esp_at_command((uint8_t *)"AT\r\n", (uint8_t *)response, &length,
                        1000);
}

static int esp_get_ip_addr(uint8_t is_debug) {
  if (strlen(ip_addr) != 0) {
    if (strcmp(ip_addr, "0.0.0.0") == 0)
      return -1;
  } else {
    uint16_t length;
    if (esp_at_command((uint8_t *)"AT+CIPSTA?\r\n", (uint8_t *)response,
                       &length, 1000) != 0)
      printf("ip_state command fail\r\n");
    else {
      char *line = strtok(response, "\r\n");

      if (is_debug) {
        for (int i = 0; i < length; i++)
          printf("%c", response[i]);
      }

      while (line != NULL) {
        if (strstr(line, "ip:") != NULL) {
          char *ip;

          strtok(line, "\"");
          ip = strtok(NULL, "\"");
          if (strcmp(ip, "0.0.0.0") != 0) {
            memset(ip_addr, 0x00, sizeof(ip_addr));
            memcpy(ip_addr, ip, strlen(ip));
            return 0;
          }
        }
        line = strtok(NULL, "\r\n");
      }
    }

    return -1;
  }

  return 0;
}

static int request_ip_addr(uint8_t is_debug) {
  uint16_t length = 0;

  if (esp_at_command((uint8_t *)"AT+CIFSR\r\n", (uint8_t *)response, &length,
                     1000) != 0)
    printf("request ip_addr command fail\r\n");
  else {
    char *line = strtok(response, "\r\n");

    if (is_debug) {
      for (int i = 0; i < length; i++)
        printf("%c", response[i]);
    }

    while (line != NULL) {
      if (strstr(line, "CIFSR:STAIP") != NULL) {
        char *ip;

        strtok(line, "\"");
        ip = strtok(NULL, "\"");
        if (strcmp(ip, "0.0.0.0") != 0) {
          memset(ip_addr, 0x00, sizeof(ip_addr));
          memcpy(ip_addr, ip, strlen(ip));
          return 0;
        }
      }
      line = strtok(NULL, "\r\n");
    }
  }

  return -1;
}
int esp_client_conn() {
  char at_cmd[MAX_ESP_COMMAND_LEN] = {
      0,
  };
  uint16_t length = 0;
  sprintf(at_cmd, "AT+CIPSTART=\"TCP\",\"%s\",%d\r\n", DST_IP, DST_PORT);
  esp_at_command((uint8_t *)at_cmd, (uint8_t *)response, &length,
                 1000); //CONNECT

  esp_send_data("[" LOGID ":" PASSWD "]");
  return 0;
}

int drv_esp_init(void) {
  huart6.Instance = USART6;
  huart6.Init.BaudRate = 38400;
  huart6.Init.WordLength = UART_WORDLENGTH_8B;
  huart6.Init.StopBits = UART_STOPBITS_1;
  huart6.Init.Parity = UART_PARITY_NONE;
  huart6.Init.Mode = UART_MODE_TX_RX;
  huart6.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart6.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart6) != HAL_OK)
    return -1;

  memset(ip_addr, 0x00, sizeof(ip_addr));
  HAL_UART_Receive_IT(&huart6, &data, 1);

  return esp_reset();
}
void reset_func() {
  printf("esp reset... ");
  if (esp_reset() == 0)
    printf("OK\r\n");
  else
    printf("fail\r\n");
}

void version_func() {
  uint16_t length = 0;
  printf("esp firmware version\r\n");
  if (esp_at_command((uint8_t *)"AT+GMR\r\n", (uint8_t *)response, &length,
                     1000) != 0)
    printf("ap scan command fail\r\n");
  else {
    for (int i = 0; i < length; i++)
      printf("%c", response[i]);
  }
}

void ap_conn_func(char *ssid, char *passwd) {
  uint16_t length = 0;
  char at_cmd[MAX_ESP_COMMAND_LEN] = {
      0,
  };
  if (ssid == NULL || passwd == NULL) {
    printf("invalid command : ap_conn <ssid> <passwd>\r\n");
    return;
  }
  memset(at_cmd, 0x00, sizeof(at_cmd));
  if (esp_at_command((uint8_t *)"AT+CWMODE=1\r\n", (uint8_t *)response, &length,
                     1000) != 0)
    printf("Station mode fail\r\n");
  else {
    for (int i = 0; i < length; i++)
      printf("%c", response[i]);
  }
  memset(at_cmd, 0x00, sizeof(at_cmd));
  sprintf(at_cmd, "AT+CWJAP=\"%s\",\"%s\"\r\n", ssid, passwd);
  if (esp_at_command((uint8_t *)at_cmd, (uint8_t *)response, &length, 6000) !=
      0)
    printf("ap scan command fail : %s\r\n", at_cmd);
  else {
    for (int i = 0; i < length; i++)
      printf("%c", response[i]);
  }
}

void ip_state_func() {
  uint16_t length = 0;
  if (esp_at_command((uint8_t *)"AT+CWJAP?\r\n", (uint8_t *)response, &length,
                     1000) != 0)
    printf("ap connected info command fail\r\n");
  else {
    for (int i = 0; i < length; i++)
      printf("%c", response[i]);
  }
  printf("\r\n");

  if (esp_get_ip_addr(1) == 0)
    printf("ip_addr = [%s]\r\n", ip_addr);
}
int drv_esp_test_command(void) {
  char command[MAX_UART_COMMAND_LEN];
  uint16_t length = 0;

  while (1) {
    drv_uart_tx_buffer((uint8_t *)"esp>", 4);

    memset(command, 0x00, sizeof(command));
    if (drv_uart_rx_buffer((uint8_t *)command, MAX_UART_COMMAND_LEN) == 0)
      continue;

    if (strcmp(command, "help") == 0) {
      printf(
          "============================================================\r\n");
      printf("* help                    : help\r\n");
      printf("* quit                    : esp test exit\r\n");
      printf("* reset                   : esp restart\r\n");
      printf("* version                 : esp firmware version\r\n");
      printf("* ap_scan                 : scan ap list\r\n");
      printf("* ap_conn <ssid> <passwd> : connect ap & obtain ip addr\r\n");
      printf("* ap_disconnect           : disconnect ap\r\n");
      printf("* ip_state                : display ip addr\r\n");
      printf("* request_ip              : obtain ip address\r\n");
      printf("* AT+<XXXX>               : AT COMMAND\r\n");
      printf("*\r\n");
      printf("* More <AT COMMAND> information is available on the following "
             "website\r\n");
      printf("*  - "
             "https://docs.espressif.com/projects/esp-at/en/latest/"
             "AT_Command_Set\r\n");
      printf(
          "============================================================\r\n");
    } else if (strcmp(command, "quit") == 0) {
      printf("esp test exit\r\n");
      break;
    } else if (strcmp(command, "reset") == 0) {
      reset_func();
    } else if (strcmp(command, "version") == 0) {
      version_func();
    } else if (strcmp(command, "ap_scan") == 0) {
      printf("ap scan...\r\n");
      if (esp_at_command((uint8_t *)"AT+CWLAP\r\n", (uint8_t *)response,
                         &length, 5000) != 0)
        printf("ap scan command fail\r\n");
      else {
        for (int i = 0; i < length; i++)
          printf("%c", response[i]);
      }
    } else if (strncmp(command, "ap_conn", strlen("ap_conn")) == 0) {
      ap_conn_func(SSID, PASSWD);
    } else if (strcmp(command, "ap_disconnect") == 0) {
      if (esp_at_command((uint8_t *)"AT+CWQAP\r\n", (uint8_t *)response,
                         &length, 1000) != 0)
        printf("ap connected info command fail\r\n");
      else {
        for (int i = 0; i < length; i++)
          printf("%c", response[i]);

        memset(ip_addr, 0x00, sizeof(ip_addr));
      }
    } else if (strcmp(command, "ip_state") == 0) {
      ip_state_func();
    } else if (strcmp(command, "request_ip") == 0) {
      request_ip_addr(1);
    } else if (strncmp(command, "AT+", 3) == 0) {
      uint8_t at_cmd[MAX_UART_COMMAND_LEN + 3];

      memset(at_cmd, 0x00, sizeof(at_cmd));
      sprintf((char *)at_cmd, "%s\r\n", command);
      if (esp_at_command(at_cmd, (uint8_t *)response, &length, 1000) != 0)
        printf("AT+ command fail\r\n");
      else {
        for (int i = 0; i < length; i++)
          printf("%c", response[i]);
      }
    } else {
      printf("unkwon command\r\n");
    }
  }

  return 0;
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {

  if (huart->Instance == USART6) {
    if (cb_data.length < MAX_ESP_RX_BUFFER) {
      cb_data.buf[cb_data.length++] = data;
    }

    HAL_UART_Receive_IT(huart, &data, 1);
  }
  if (huart->Instance == USART2) {
    static int i = 0;
    rx2Data[i] = cdata;
    if (rx2Data[i] == '\r') {
      rx2Data[i] = '\0';
      rx2Flag = 1;
      i = 0;
    } else {
      i++;
    }
    HAL_UART_Receive_IT(huart, &cdata, 1);
  }
}

void AiotClient_Init() {
  reset_func();
  //      version_func();
  ap_conn_func(SSID, PASS);
  //      start_esp_server();
  //      ip_state_func();
  request_ip_addr(1);
  esp_client_conn();
  //      ip_state_func();
}

void esp_send_data(char *data) {
  char at_cmd[MAX_ESP_COMMAND_LEN] = {
      0,
  };
  uint16_t length = 0;
  sprintf(at_cmd, "AT+CIPSEND=%d\r\n", strlen(data));
  if (esp_at_command((uint8_t *)at_cmd, (uint8_t *)response, &length, 1000) ==
      0) {
    esp_at_command((uint8_t *)data, (uint8_t *)response, &length, 1000);
  }
}

//==================uart2=========================
int drv_uart_init(void) {
  huart2.Instance = USART2;
  huart2.Init.BaudRate = 115200;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart2) != HAL_OK)
    return -1;

  HAL_UART_Receive_IT(&huart2, &cdata, 1);
  return 0;
}

int drv_uart_tx_buffer(uint8_t *buf, uint16_t size) {
  if (HAL_UART_Transmit(&huart2, buf, size, 100) != HAL_OK)
    return -1;

  return 0;
}
int __io_putchar(int ch) {
  if (HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, 10) == HAL_OK)
    return ch;
  return -1;
}
/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "esp.h"
#include <stdio.h>
#include <string.h>
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#ifdef __GNUC__
/* With GCC, small printf (option LD Linker->Libraries->Small printf
   set to 'Yes') calls __io_putchar() */
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif /* __GNUC__ */
#define ARR_CNT 5
#define CMD_SIZE 50

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
ADC_HandleTypeDef hadc1;
DMA_HandleTypeDef hdma_adc1;

TIM_HandleTypeDef htim3;

/* USER CODE BEGIN PV */
uint8_t rx2char;
extern cb_data_t cb_data;
extern volatile unsigned char rx2Flag;
extern volatile char rx2Data[50];
volatile int tim3Flag1Sec;
volatile unsigned int tim3Sec;
volatile unsigned int tim3Cnt;
__IO uint16_t ADCxConvertValue[2] = {0};
__IO int adcFlag = 0;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void MX_TIM3_Init(void);
static void MX_ADC1_Init(void);
/* USER CODE BEGIN PFP */
char strBuff[MAX_ESP_COMMAND_LEN];
void MX_GPIO_LED_ON(int flag);
void MX_GPIO_LED_OFF(int flag);
void esp_event(char *);
/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void) {

  /* USER CODE BEGIN 1 */
  int ret = 0;
  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_TIM3_Init();
  MX_ADC1_Init();
  /* USER CODE BEGIN 2 */
  ret |= drv_uart_init();
  ret |= drv_esp_init();
  if (ret != 0)
    Error_Handler();
  printf("Start main() - wifi\r\n");
  AiotClient_Init();

  if (HAL_TIM_Base_Start_IT(&htim3) != HAL_OK) {
    Error_Handler();
  }

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1) {
    if (strstr((char *)cb_data.buf, "+IPD") &&
        cb_data.buf[cb_data.length - 1] == '\n') {
      //?��?��?���???  \r\n+IPD,15:[KSH_LIN]HELLO\n
      strcpy(strBuff, strchr((char *)cb_data.buf, '['));
      memset(cb_data.buf, 0x0, sizeof(cb_data.buf));
      cb_data.length = 0;
      esp_event(strBuff);
    }
    if (rx2Flag) {
      printf("recv2 : %s\r\n", rx2Data);
      rx2Flag = 0;
    }
    if (tim3Flag1Sec) //1초마다 실행
    {
      tim3Flag1Sec = 0;
      //                HAL_GPIO_TogglePin(LD2_GPIO_Port,LD2_Pin);
      //                printf("tim3Sec : %d\r\n",tim3Sec);

      if (!(tim3Sec % 5)) //5초 마다 실행
      {
        if (HAL_ADC_Start_DMA(&hadc1, (uint32_t *)ADCxConvertValue, 2) !=
            HAL_OK) {
          Error_Handler();
        }
      }
      if (adcFlag) {
        adcFlag = 0;
        printf("tim3Sec=%d,VAR=%4d, CDS=%4d\r\n", tim3Sec, ADCxConvertValue[0],
               ADCxConvertValue[1]);
      }
    }
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void) {
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 8;
  RCC_OscInitStruct.PLL.PLLN = 336;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
  RCC_OscInitStruct.PLL.PLLQ = 4;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK) {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK |
                                RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK) {
    Error_Handler();
  }
}

/**
  * @brief ADC1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_ADC1_Init(void) {

  /* USER CODE BEGIN ADC1_Init 0 */

  /* USER CODE END ADC1_Init 0 */

  ADC_ChannelConfTypeDef sConfig = {0};

  /* USER CODE BEGIN ADC1_Init 1 */

  /* USER CODE END ADC1_Init 1 */

  /** Configure the global features of the ADC (Clock, Resolution, Data Alignment and number of conversion)
  */
  hadc1.Instance = ADC1;
  hadc1.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV6;
  hadc1.Init.Resolution = ADC_RESOLUTION_12B;
  hadc1.Init.ScanConvMode = ENABLE;
  hadc1.Init.ContinuousConvMode = DISABLE;
  hadc1.Init.DiscontinuousConvMode = DISABLE;
  hadc1.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
  hadc1.Init.ExternalTrigConv = ADC_SOFTWARE_START;
  hadc1.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  hadc1.Init.NbrOfConversion = 2;
  hadc1.Init.DMAContinuousRequests = ENABLE;
  hadc1.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
  if (HAL_ADC_Init(&hadc1) != HAL_OK) {
    Error_Handler();
  }

  /** Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time.
  */
  sConfig.Channel = ADC_CHANNEL_0;
  sConfig.Rank = 1;
  sConfig.SamplingTime = ADC_SAMPLETIME_28CYCLES;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK) {
    Error_Handler();
  }

  /** Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time.
  */
  sConfig.Channel = ADC_CHANNEL_1;
  sConfig.Rank = 2;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK) {
    Error_Handler();
  }
  /* USER CODE BEGIN ADC1_Init 2 */

  /* USER CODE END ADC1_Init 2 */
}

/**
  * @brief TIM3 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM3_Init(void) {

  /* USER CODE BEGIN TIM3_Init 0 */

  /* USER CODE END TIM3_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM3_Init 1 */

  /* USER CODE END TIM3_Init 1 */
  htim3.Instance = TIM3;
  htim3.Init.Prescaler = 84 - 1;
  htim3.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim3.Init.Period = 1000 - 1;
  htim3.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim3.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_ENABLE;
  if (HAL_TIM_Base_Init(&htim3) != HAL_OK) {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim3, &sClockSourceConfig) != HAL_OK) {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim3, &sMasterConfig) != HAL_OK) {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM3_Init 2 */

  /* USER CODE END TIM3_Init 2 */
}

/**
  * Enable DMA controller clock
  */
static void MX_DMA_Init(void) {

  /* DMA controller clock enable */
  __HAL_RCC_DMA2_CLK_ENABLE();

  /* DMA interrupt init */
  /* DMA2_Stream0_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream0_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream0_IRQn);
}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void) {
  GPIO_InitTypeDef GPIO_InitStruct = {0};
  /* USER CODE BEGIN MX_GPIO_Init_1 */
  /* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(LD2_GPIO_Port, LD2_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : B1_Pin */
  GPIO_InitStruct.Pin = B1_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(B1_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : LD2_Pin */
  GPIO_InitStruct.Pin = LD2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(LD2_GPIO_Port, &GPIO_InitStruct);

  /* USER CODE BEGIN MX_GPIO_Init_2 */
  /* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */
void MX_GPIO_LED_ON(int pin) {
  HAL_GPIO_WritePin(LD2_GPIO_Port, pin, GPIO_PIN_SET);
}
void MX_GPIO_LED_OFF(int pin) {
  HAL_GPIO_WritePin(LD2_GPIO_Port, pin, GPIO_PIN_RESET);
}
void esp_event(char *recvBuf) {
  int i = 0;
  char *pToken;
  char *pArray[ARR_CNT] = {0};
  char sendBuf[MAX_UART_COMMAND_LEN] = {0};

  strBuff[strlen(recvBuf) - 1] = '\0'; //'\n' cut
  printf("\r\nDebug recv : %s\r\n", recvBuf);

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
    sprintf(sendBuf, "[%s]%s@%s\n", pArray[0], pArray[1], pArray[2]);
  } else if (!strncmp(pArray[1], " New conn", 8)) {
    //         printf("Debug : %s, %s\r\n",pArray[0],pArray[1]);
    return;
  } else if (!strncmp(pArray[1], " Already log", 8)) {
    //          printf("Debug : %s, %s\r\n",pArray[0],pArray[1]);
    esp_client_conn();
    return;
  } else
    return;

  esp_send_data(sendBuf);
  printf("Debug send : %s\r\n", sendBuf);
}
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim) //1ms 마다 호출
{

  tim3Cnt++;
  if (tim3Cnt == 1000) //1ms * 1000 = 1Sec
  {
    tim3Flag1Sec = 1;
    tim3Sec++;
    tim3Cnt = 0;
  }
}
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef *AdcHandle) { adcFlag = 1; }
/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void) {
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1) {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line) {
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
