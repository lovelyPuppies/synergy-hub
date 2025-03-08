/*
특정 GPIO 컨트롤러(/dev/gpiochipX)를 열어 핸들을 반환합니다.
struct gpiod_chip *gpiod_chip_open(const char *path);
특정 GPIO 라인(핀)에 대한 디스크립터를 가져옵니다.
struct gpiod_line *gpiod_chip_get_line(struct gpiod_chip *chip, unsigned int offset);


GPIO 라인을 출력 모드로 설정하고 초기 값을 지정합니다.
int gpiod_line_request_output(struct gpiod_line *line, const char *consumer, int default_val);

출력 모드로 설정된 GPIO 라인의 값을 설정합니다.
int gpiod_line_set_value(struct gpiod_line *line, int value);



열린 GPIO 컨트롤러 핸들을 닫고 리소스를 해제합니다.
void gpiod_chip_close(struct gpiod_chip *chip);

사용 중인 GPIO 라인 디스크립터를 해제합니다.
void gpiod_line_release(struct gpiod_line *line);




https://blog.naver.com/sheld2/222073308099
Raspberry PI 에서 GPIO 를 제어하는 방법에는 여러가지가 있다. Sysfs 를 사용하는 옛날 방식도 있는 것 같은데, 현재 Linux kernel document 에서는 libgpiod 의 사용을 권장하고 있다.


libgpiod 를 사용해서 GPIO 를 제어하려면 우선 해당 library 를 설치해야한다.

$ sudo apt-get install -y libgpiod-dev
Source code 에는 다음과 같이 header file을 include 해야한다.

#include <gpiod.h>
그리고 gcc compile 시 -lgpiod 옵션을 추가해줘야한다.

g++ -Wall -Wextra -pthread -lrt -std=c++17 -ggdb -lgpiod -Iinclude -Llib src/*.cpp -o ./bin/bin
기본적인 사용법을 정리하면 아래와 같다.

​

한가지 pigpio 와의 차이점을 비교하면, pigpio 는 임의의 GPIO line 을 output 으로 설정한 뒤 on 으로 하고 program 을 종료시키면 계속 on 으로 남아있고, off 로 설정하고 종료하면 off 로 남아있는다. 이에반해, libgpiod 에서 동일한 logic 으로 on 을 시키고 program 을 종료하면 상태가 바뀐다. 즉, GPIO line 의 상태는 program 이 동작하고 있다는 전제하에 유지되는 것으로 이해해야한다. 이것을 몰라서 pigpio 를 썼을 때 동작이 안되는 줄 알고 꽤 해멨다. 
*/

#include "Common.h"
#include "GPIOTest.h"

#include <pigpio.h>
#include <sys/time.h>
#include <sys/times.h>
#include <unistd.h>

CGpioLGpiod::CGpioLGpiod() {
  m_pChip = NULL;
  m_pChip = gpiod_chip_open("/dev/gpiochip0");
}

CGpioLGpiod::~CGpioLGpiod() {
  if (m_pChip)
    gpiod_chip_close(m_pChip);
}

void CGpioLGpiod::TestGpio1() { TestLGpio(2, eMODE_OUTPUT, 1); }

void CGpioLGpiod::TestGpio2() { TestLGpio(2, eMODE_OUTPUT, 0); }

void CGpioLGpiod::TestLGpio(int aLine, int aMode, int aValue) {
  if (!m_pChip) {
    printf_error("no chip");
    return;
  }

  int ret = 0;

  int line = aLine;
  int mode = aMode;
  int value = aValue;

  struct gpiod_line *pLine = gpiod_chip_get_line(m_pChip, line);

  if (mode == eMODE_OUTPUT) {
    ret =
        gpiod_line_request_output(pLine, "null", GPIOD_LINE_ACTIVE_STATE_HIGH);
    if (ret) {
      printf_error("request output failed");
      goto _EXIT;
    }

    ret = gpiod_line_set_value(pLine, value);
    if (ret) {
      printf_error("set value failed");
      goto _EXIT;
    }

    /* Comment
	 * I don't know why, but there seems to be current leakage even when I don't turn it on in libgpiod mode.
	 * It's different from when I used pigpio.
	 * I can test with these code.
		printf("wait..\n");
		sleep(1);
		*/
  } else if (mode == eMODE_INPUT) {
    ; // TBD
  } else {
    printf_error("unknown mode");
    goto _EXIT;
  }

_EXIT:
  gpiod_line_release(pLine);
  return;
}
#include <gpiod.h>

class CGpioInterface {
public:
  CGpioInterface() {};
  virtual ~CGpioInterface() {};
  enum { eMODE_OUTPUT = 0, eMODE_INPUT = 1 };

  enum { eVALUE_HIGH = 1, eVALUE_LOW = 0 };

  virtual void TestGpio1() = 0;
  virtual void TestGpio2() = 0;
};

class CGpioLGpiod : public CGpioInterface {
public:
  CGpioLGpiod();
  ~CGpioLGpiod();

protected:
  struct gpiod_chip *m_pChip;

public:
  void TestGpio1();
  void TestGpio2();
  void TestLGpio(int aLine, int aMode, int aValue);
};