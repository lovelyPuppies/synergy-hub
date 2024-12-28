// #include "WiFiEsp.h"

// // Emulate Serial1 on pins 6/7 if not present
// #ifndef HAVE_HWSERIAL1
// #include "SoftwareSerial.h"
// #endif
// #define AP_SSID "embB"
// #define AP_PASS "embB123B"
// #define SERVER_NAME "10.10.14.59"
// #define SERVER_PORT 5000
// #define LOGID "KSH_ARD"
// #define PASSWD "PASSWD"
// #define WIFITX 7
// #define WIFIRX 6

// SoftwareSerial Serial1(WIFITX, WIFIRX); // RX, TX

// char ssid[] = "embB";            // your network SSID (name) 🚣 수정됨
// char pass[] = "embB1234";        // your network password 🚣 수정됨
// int status = WL_IDLE_STATUS;     // the Wifi radio's status

// char server[] = "arduino.cc";

// // Initialize the Ethernet client object
// WiFiEspClient client;

// void printWifiStatus()
// {
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
// void setup()
// {
//   // initialize serial for debugging
//   Serial.begin(115200);
//   // initialize serial for ESP module 🚣 수정됨
//   Serial1.begin(38400);
//   // initialize ESP module
//   WiFi.init(&Serial1);

//   // check for the presence of the shield
//   if (WiFi.status() == WL_NO_SHIELD) {
//     Serial.println("WiFi shield not present");
//     // don't continue
//     while (true);
//   }

//   // attempt to connect to WiFi network
//   while ( status != WL_CONNECTED) {
//     Serial.print("Attempting to connect to WPA SSID: ");
//     Serial.println(ssid);
//     // Connect to WPA/WPA2 network
//     status = WiFi.begin(ssid, pass);
//   }

//   // you're connected now, so print out the data
//   Serial.println("You're connected to the network");

//   printWifiStatus();

//   Serial.println();
//   Serial.println("Starting connection to server...");
//   // if you get a connection, report back via serial
//   if (client.connect(server, 80)) {
//     Serial.println("Connected to server");
//     // Make a HTTP request
//     client.println("GET /asciilogo.txt HTTP/1.1");
//     client.println("Host: arduino.cc");
//     client.println("Connection: close");
//     client.println();
//   }
// }

// void loop()
// {
//   // if there are incoming bytes available
//   // from the server, read them and print them
//   while (client.available()) {
//     char c = client.read();
//     Serial.write(c);
//   }

//   // if the server's disconnected, stop the client
//   if (!client.connected()) {
//     Serial.println();
//     Serial.println("Disconnecting from server...");
//     client.stop();

//     // do nothing forevermore
//     while (true);
//   }
// }
