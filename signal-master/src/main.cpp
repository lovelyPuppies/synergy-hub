/*
https://docs.arduino.cc/hardware/uno-rev3/
⚓ PinOuts ; https://docs.arduino.cc/resources/pinouts/A000066-full-pinout.pdf
https://docs.arduino.cc/resources/datasheets/A000066-datasheet.pdf
📝 TODO: Hard real-time, modularaization
*/

#include <avr/io.h>
#include <util/delay.h>

// Define clock frequency for delay functions
#define F_CPU 16000000UL

// Define UART settings
#define BAUD 9600
#define MYUBRR F_CPU / 16 / BAUD - 1

// Define registers and bits for readability
#define DATA_DIRECTION_REGISTER_B DDRB
#define PORT_B PORTB
#define LED_PIN PB5

#define USART_BAUD_HIGH UBRR0H
#define USART_BAUD_LOW UBRR0L
#define USART_CONTROL_STATUS_B UCSR0B
#define USART_CONTROL_STATUS_C UCSR0C
#define USART_DATA_REGISTER UDR0
#define USART_TRANSMIT_ENABLE TXEN0
#define USART_RECEIVE_ENABLE RXEN0
#define USART_DATA_READY UDRE0
#define USART_RECEIVE_COMPLETE RXC0
#define USART_CHAR_SIZE UCSZ00

// LED Controller Class
class LEDController
{
public:
  LEDController(uint8_t pin) : ledPin(pin)
  {
    // Set the pin as output
    DATA_DIRECTION_REGISTER_B |= (1 << ledPin);
  }

  void turnOn()
  {
    // Turn the LED ON
    PORT_B |= (1 << ledPin);
  }

  void turnOff()
  {
    // Turn the LED OFF
    PORT_B &= ~(1 << ledPin);
  }

  void toggleWithDelay()
  {
    turnOn();
    delay();
    turnOff();
    delay();
  }

private:
  uint8_t ledPin;

  void delay()
  {
    _delay_ms(500); // Delay for 500ms
  }
};

// USART Initialization
void USART_init(unsigned int ubrr)
{
  // Set baud rate
  USART_BAUD_HIGH = (unsigned char)(ubrr >> 8);
  USART_BAUD_LOW = (unsigned char)ubrr;

  // Enable transmitter and receiver
  USART_CONTROL_STATUS_B = (1 << USART_RECEIVE_ENABLE) | (1 << USART_TRANSMIT_ENABLE);

  // Set frame format: 8 data bits, 1 stop bit
  USART_CONTROL_STATUS_C = (1 << UCSZ01) | (1 << USART_CHAR_SIZE);
}

// Transmit a byte over USART
void USART_transmit(unsigned char data)
{
  // Wait for the transmit buffer to be empty
  while (!(UCSR0A & (1 << USART_DATA_READY)))
    ;

  // Put data into buffer, sends the data
  USART_DATA_REGISTER = data;
}

// Receive a byte over USART (non-blocking)
unsigned char USART_receive(void)
{
  // Check if data is available
  if (UCSR0A & (1 << USART_RECEIVE_COMPLETE))
  {
    // Get and return received data from buffer
    return USART_DATA_REGISTER;
  }
  else
  {
    // No data available, return 0
    return 0;
  }
}

// Send a string over USART
void USART_send_string(const char *str)
{
  while (*str)
  {
    USART_transmit(*str++);
  }
}

int main()
{
  // Create an LED controller object for the LED_PIN
  LEDController led(LED_PIN);

  // Initialize USART with the baud rate
  USART_init(MYUBRR);

  while (true)
  {
    // Toggle the LED with a delay
    led.toggleWithDelay();

    // Send a test string over USART
    USART_send_string("Hello from ATmega328P!\r\n");

    // Receive data from Bluetooth (if available)
    unsigned char received_data = USART_receive();
    if (received_data)
    {
      // Echo back the received data
      USART_transmit(received_data);
    }
  }

  return 0;
}
