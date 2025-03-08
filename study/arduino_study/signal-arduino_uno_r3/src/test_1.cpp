// #include <Arduino.h>
// #include <SoftwareSerial.h>
// /*
// --------------------------------------------------
// 아두이노 우노 핀    ESP8266 Serial WIFI 모듈  핀
//   3.3V              VCC, CH_ PD
//  D0(TX)             RX (레벨쉬프트 사용)
//  D1(RX)             TX
//  GND                GND
// ------------------------------------------------
// 시리얼 모니터 115200bps 설정, Both NL & CR 설정 후 아래 명령 실행
// 115200 ; >>  AT+RST                       //restart
// AT+UART_DEF=38400,8,1,0,0

// 시리얼 모니터 38400 설정 변경후

// ssid embB
// embB1234

// AT+RST              //응답 확인

// --------------------------------------------------
// 아두이노 우노 핀    ESP8266 Serial WIFI 모듈  핀
//   3.3V              VCC, CH_PD
//  D7(TX)             RX (레벨쉬프트 사용)
//  D6(RX)             TX
//  GND                GND
// ------------------------------------------------
// //시리얼 모니터 19200 설정, Both NL & CR 설정 후 아래 명령 실행
// AT+RST    ==>  응답확인 : 핀 연결 및 모듈 테스트
// AT+UART_DEF=38400,8,1,0,0

// >>>>>>> AT+UART_DEF?

// */

// SoftwareSerial wifi(6, 7) ;  // RX, TX
// void setup() {
//   // put your setup code here, to run once:
//   wifi.begin(38400) ;
//   Serial.begin(38400) ;
// //  Serial.println("AT CMD TEST 2");
// }

// void loop() {
//   // put your main code here, to run repeatedly:
//   if (Serial.available()) wifi.write(Serial.read()) ;
//   if (wifi.available()) Serial.write(wifi.read()) ;
// }

// /*
//   DigitalReadSerial

//   Reads a digital input on pin 2, prints the result to the Serial Monitor

//   This example code is in the public domain.

//   https://www.arduino.cc/en/Tutorial/BuiltInExamples/DigitalReadSerial
// */

// // int led = 9;
// // int brightness = 0;
// // char keyStr[10];

// // void setup()
// // {
// //     Serial.begin(9600);
// //     pinMode(led, OUTPUT);
// // }

// // void loop()
// // {
// //   int sensorValue = analogRead(A0);   // 가변저항을 아날로그 A5에 연결하고 이를 'val'에 저장합니다
// //   int sensorValuePre = 0;

// //   if ((sensorValue - sensorValuePre) > 1 || (sensorValue - sensorValuePre) < -1 ){

// //   }
// //   int pwm = map(sensorValue, 0, 1023, 0, 255);
// //   Serial.println(sensorValue);
// //   Serial.println(5/1024.0 * sensorValue, 3); // 🚣 브레드보드가 반반 나눠져 있다. 1024단계. 5V. 시리얼 모니터로 가변저항 값을 출력합니다
// //   analogWrite(led, pwm);
// //   Serial.println(pwm);
// //   Serial.println(5/256.0 * pwm, 3);
// //   sensorValuePre = sensorValuePre;

// //   if(Serial.available()){
// //     int keyStrLen = Serial.readBytes(keyStr, sizeof(keyStr));
// //     keyStr[keyStrLen-1] = '\0';
// //     // atoi(keyStr);
// //     // Serial.println(keyStrLen);
// //     Serial.println(keyStr);
// //     int pwm = atoi(keyStr);
// //     analogWrite(led, pwm);
// //     Serial.println(5/256);
// //   }
// //     // analogWrite(led, 255);
// //     // analogWrite(led, brightness);

// //     // brightness = brightness + fadeAmount;
// //     // sprintf(str,"b : %d , ",brightness);
// //     // Serial.print(str);
// //     // Serial.print("v : ");
// //     // Serial.println(5/256.0*brightness,3);
// //     // if (brightness <= 0 || brightness >= 255)
// //     // {
// //     //     fadeAmount = -fadeAmount;
// //     // }
// //     // delay(30);
// // }

// // //  Serial.println(5/1024.0 * sensorValue, 3); // 🚣 브레드보드가 반반 나눠져 있다. 1024단계. 5V. 시리얼 모니터로 가변저항 값을 출력합니다

// // // // ============================== LED
// // // // digital pin 2 has a pushbutton attached to it. Give it a name:
// // // int pushButton = 2;
// // // int ledPin = 13;
// // // char ledState = 0;
// // // int buttonStatePre = 0;
// // // int buttonCount = 0;

// // // // the setup routine runs once when you press reset:
// // // void setup() {
// // //   // initialize serial communication at 9600 bits per second:
// // //   Serial.begin(9600);
// // //   // make the pushbutton's pin an input:
// // //   pinMode(pushButton, INPUT);
// // //   pinMode(ledPin, OUTPUT);
// // //   digitalWrite(ledPin, LOW);
// // // }

// // // // the loop routine runs over and over again forever:
// // // void loop() {
// // //   // read the input pin:
// // //   int buttonState = digitalRead(pushButton);

// // //   // Check if the button state has changed
// // //   if (buttonState != buttonStatePre) {
// // //     if (buttonState) { // Button is pressed
// // //       buttonCount++;
// // //       ledState = !ledState; // Toggle the LED state
// // //       Serial.print("buttonCount : ");
// // //       Serial.println(buttonCount);
// // //       digitalWrite(ledPin, ledState); // Set LED based on toggled state
// // //     }
// // //     buttonStatePre = buttonState; // Update previous state
// // //   }

// // //   // Check if there is data available from Serial input
// // //   if (Serial.available()) {
// // //     ledState = Serial.read(); // Read the incoming byte

// // //     // Check if ledState is '0' or '1' and act accordingly
// // //     if (ledState == '0' || ledState == '1') {
// // //       if (ledState == '1') {
// // //         digitalWrite(ledPin, HIGH); // Turn LED on
// // //       } else if (ledState == '0') {
// // //         digitalWrite(ledPin, LOW);  // Turn LED off
// // //       }
// // //       Serial.print("ledState : ");
// // //       Serial.println(ledState);
// // //     }
// // //   }
// // // }

// // // // ❓ https://github.com/platformio/platformio-vscode-ide/issues/118
