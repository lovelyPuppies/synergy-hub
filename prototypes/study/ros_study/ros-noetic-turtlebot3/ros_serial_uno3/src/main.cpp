#include <Arduino.h>

#include <ros.h>
#include <std_msgs/Int16.h>
ros::NodeHandle nh;
void messageCb(const std_msgs::Int16 &toggle_msg) {
  int ledVal = toggle_msg.data;
  if (ledVal)
    digitalWrite(LED_BUILTIN,
                 HIGH); // turn the LED on (HIGH is the voltage level)
  else                  // wait for a second
    digitalWrite(LED_BUILTIN,
                 LOW); // turn the  LED off by making the voltage LOW
  delay(1000);         // wait for a second
}
ros::Subscriber<std_msgs::Int16> sub("toggle_led", &messageCb);
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  nh.initNode();
  // nh.getHardware()->setBaud(57600);
  nh.subscribe(sub);
}

void loop() {
  nh.spinOnce();
  delay(1);
}

// // put function declarations here:
// int myFunction(int, int);

// void setup() {
//   // put your setup code here, to run once:
//   int result = myFunction(2, 3);
// }

// void loop() {
//   // put your main code here, to run repeatedly:
// }

// // put function definitions here:
// int myFunction(int x, int y) { return x + y; }

/*
  ; https://wiki.ros.org/rosserial

*/
