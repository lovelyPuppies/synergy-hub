// /*
//  WiFiEsp test: ClientTest
// http://www.kccistc.net/
// 작성일 : 2019.12.17
// 작성자 : IoT 임베디드 KSH
// */
// #define DEBUG
// //#define DEBUG_WIFI
// #define AP_SSID "embA"
// #define AP_PASS "embA1234"
// #define SERVER_NAME "10.10.14.19"
// #define SERVER_PORT 5000
// #define LOGID "KSH_ARD"
// #define PASSWD "PASSWD"

// #define WIFITX 7 //7:TX -->ESP8266 RX
// #define WIFIRX 6 //6:RX-->ESP8266 TX
// #define LED_TEST_PIN 12
// #define LED_BUILTIN_PIN 13

// #define CMD_SIZE 50
// #define ARR_CNT 5
// #define MOTOR_PIN 9 // 모터 핀을 9번으로 설정

// #include "SoftwareSerial.h"
// #include "WiFiEsp.h"
// #include <TimerOne.h>

// char sendBuf[CMD_SIZE];
// bool timerIsrFlag = false;

// unsigned int secCount;
// int sensorTime;

// SoftwareSerial wifiSerial(WIFIRX, WIFITX);
// WiFiEspClient client;

// int server_Connect() {
// #ifdef DEBUG_WIFI
//   Serial.println("Starting connection to server...");
// #endif

//   if (client.connect(SERVER_NAME, SERVER_PORT)) {
// #ifdef DEBUG_WIFI
//     Serial.println("Connected to server");
// #endif
//     client.print("[" LOGID ":" PASSWD "]");
//   } else {
// #ifdef DEBUG_WIFI
//     Serial.println("server connection failure");
// #endif
//   }
// }

// void socketEvent() {
//   int i = 0;
//   char *pToken;
//   char *pArray[ARR_CNT] = {0};
//   char recvBuf[CMD_SIZE] = {0};
//   int len;

//   len = client.readBytesUntil('\n', recvBuf, CMD_SIZE);
//   //  recvBuf[len] = '\0';
//   client.flush();
// #ifdef DEBUG
//   Serial.print("recv : ");
//   Serial.print(recvBuf);
// #endif
//   pToken = strtok(recvBuf, "[@]");
//   while (pToken != NULL) {
//     pArray[i] = pToken;
//     if (++i >= ARR_CNT)
//       break;
//     pToken = strtok(NULL, "[@]");
//   }
//   if (!strncmp(pArray[1], " New", 4)) // New Connected
//   {
//     Serial.write('\n');
//     return;
//   } else if (!strncmp(pArray[1], " Alr", 4)) //Already logged
//   {
//     Serial.write('\n');
//     client.stop();
//     server_Connect();
//     return;
//   } else if (!strcmp(pArray[1], "LED")) {
//     if (!strcmp(pArray[2], "ON")) {
//       digitalWrite(LED_BUILTIN_PIN, HIGH);
//     } else if (!strcmp(pArray[2], "OFF")) {
//       digitalWrite(LED_BUILTIN_PIN, LOW);
//     }
//     sprintf(sendBuf, "[%s]%s@%s\n", pArray[0], pArray[1], pArray[2]);
//   } else if (!strcmp(pArray[1], "LAMP")) {
//     if (!strcmp(pArray[2], "ON")) {
//       digitalWrite(LED_TEST_PIN, HIGH);
//     } else if (!strcmp(pArray[2], "OFF")) {
//       digitalWrite(LED_TEST_PIN, LOW);
//     }
//     sprintf(sendBuf, "[%s]%s@%s\n", pArray[0], pArray[1], pArray[2]);
//   } else if (!strcmp(pArray[1], "MOTOR")) {
//     // MOTOR 관련 명령 처리
//     if (!strcmp(pArray[2], "START")) {
//       analogWrite(MOTOR_PIN, 255); // 모터를 최고 속도로 시작
//     } else if (!strcmp(pArray[2], "STOP")) {
//       analogWrite(MOTOR_PIN, 0); // 모터 정지
//     } else if (!strcmp(pArray[2], "SPEED")) {
//       // pArray[3]에 전달된 값을 속도로 설정 (0~100을 0~255로 변환)
//       int speedPercent = atoi(pArray[3]);
//       if (speedPercent >= 0 && speedPercent <= 100) {
//         int pwm = map(speedPercent, 0, 100, 0, 255); // 0~100을 0~255로 변환
//         analogWrite(MOTOR_PIN, pwm);
//       } else {
//         sprintf(sendBuf, "[%s]%s@INVALID_SPEED\n", pArray[0], pArray[1]);
//         return;
//       }
//     }
//     sprintf(sendBuf, "[%s]%s@%s\n", pArray[0], pArray[1], pArray[2]);
//   } else if (!strcmp(pArray[1], "GETSTATE")) {
//     if (!strcmp(pArray[2], "DEV")) {
//       sprintf(sendBuf, "[%s]DEV@%s@%s\n", pArray[0],
//               digitalRead(LED_BUILTIN_PIN) ? "ON" : "OFF",
//               digitalRead(LED_TEST_PIN) ? "ON" : "OFF");
//     }
//   }
//   client.write(sendBuf, strlen(sendBuf));
//   client.flush();

// #ifdef DEBUG
//   Serial.print(", send : ");
//   Serial.print(sendBuf);
// #endif
// }
// void timerIsr() {
//   //  digitalWrite(LED_BUILTIN_PIN,!digitalRead(LED_BUILTIN_PIN));
//   timerIsrFlag = true;
//   secCount++;
// }

// void wifi_Init() {
//   do {
//     WiFi.init(&wifiSerial);
//     if (WiFi.status() == WL_NO_SHIELD) {
// #ifdef DEBUG_WIFI
//       Serial.println("WiFi shield not present");
// #endif
//     } else
//       break;
//   } while (1);

// #ifdef DEBUG_WIFI
//   Serial.print("Attempting to connect to WPA SSID: ");
//   Serial.println(AP_SSID);
// #endif
//   while (WiFi.begin(AP_SSID, AP_PASS) != WL_CONNECTED) {
// #ifdef DEBUG_WIFI
//     Serial.print("Attempting to connect to WPA SSID: ");
//     Serial.println(AP_SSID);
// #endif
//   }
// #ifdef DEBUG_WIFI
//   Serial.println("You're connected to the network");
//   printWifiStatus();
// #endif
// }

// void printWifiStatus() {
//   // print the SSID of the network you're attached to
//   Serial.print("SSID: ");
//   Serial.println(WiFi.SSID());

//   // print your WiFi shield's IP address
//   IPAddress ip = WiFi.localIP();
//   Serial.print("IP Address: ");
//   Serial.println(ip);

//   // print the received signal strength
//   long rssi = WiFi.RSSI();
//   Serial.print("Signal strength (RSSI):");
//   Serial.print(rssi);
//   Serial.println(" dBm");
// }

// void wifi_Setup() {
//   wifiSerial.begin(38400);
//   wifi_Init();
//   server_Connect();
// }

// void setup() {
//   // put your setup code here, to run once:
//   pinMode(LED_TEST_PIN, OUTPUT);    //D12
//   pinMode(LED_BUILTIN_PIN, OUTPUT); //D13
//   Serial.begin(115200);             //DEBUG
//   wifi_Setup();
//   Timer1.initialize(1000000);
//   Timer1.attachInterrupt(timerIsr); // timerIsr to run every 1 seconds
// }

// void loop() {
//   // put your main code here, to run repeatedly:
//   if (client.available()) {
//     socketEvent();
//   }
//   if (timerIsrFlag) {
//     timerIsrFlag = false;
//     if (!(secCount % 5)) {
//       if (!client.connected()) {
//         server_Connect();
//       }
//     }
//   }
// }
