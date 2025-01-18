\*/

// ⚙️ For Debug
#define DEBUG

회고..

1. 현재 코드는 디스크립터 기반 GPIO API를 사용하지 않고 레거시 GPIO API(gpio_request, gpio_direction_output, gpio_free)를 사용합니다...

   libgpiod는 기존의 sysfs 방식보다... (무슨차이? 테이블로..)

   gpio_to_desc는 GPIO 번호를 받아 해당 GPIO의 **구조체 포인터(struct gpio_desc \*)**를 반환합니다. 이 함수는 GPIO가 디스크립터 기반 GPIO API를 사용하여 관리될 때 유용합니다. 그러나:

   현재 코드는 디스크립터 기반 GPIO API를 사용하지 않고 레거시 GPIO API(gpio_request, gpio_direction_output, gpio_free)를 사용합니다.
   레거시 API에서는 gpio_to_desc 호출이 필요하지 않습니다.
   gpio_to_desc(gpioLed[0])는 디스크립터를 가져오는 코드이지만, 이 반환 값이 사용되지 않습니다.
   desc가 NULL인 경우 gpioLedFree()와 gpioKeyFree()가 호출되지 않으므로, 자원 해제가 누락될 수 있습니다.

   struct gpio_desc \*desc = gpio_to_desc(gpioLed[0]);
   if (desc) {
   gpioLedFree();
   gpioKeyFree();
   }

   결론 -> 디바이스 트리를 사용하는

   pi19@pi ~ [2]> ls /dev/gpiochip\*
   /dev/gpiochip0 /dev/gpiochip1 /dev/gpiochip2 /dev/gpiochip4@

   gpioinfo /dev/gpiochip0
   gpioinfo /dev/gpiochip1

2. 디바이스 트리 오버레이(DTS Overlay)의 실무 사용
   디바이스 트리 오버레이(DTS Overlay)는 하드웨어 설정을 동적으로 변경하거나 확장할 때 사용하는 도구로, 실무에서 다음과 같은 상황에서 유용하게 사용됩니다.

   !! 제품 프로토타이핑 및 테스트
   목적: 제품 초기 개발 단계에서 하드웨어 구성을 반복적으로 변경해야 할 때, 디바이스 트리 오버레이를 사용하여 빠르게 테스트.
   이점:
   커널 전체를 재빌드할 필요 없이 간단히 오버레이를 적용

   \*\* 제품 완성품에서 디바이스 트리 오버레이를 사용하지 않는 경우
   =====  
    퍼포먼스가 중요한 경우

   고성능 및 즉각적인 부팅이 필요한 시스템에서는 기본 디바이스 트리를 사용해 최적화를 시도

   // 하지만 큰 영향이 없다고 한다? 고성능 임베디드 기기에서나 보통 사용하지, MCU 에서는 사용하지 않기 때문..

   # \*\*제품 완성품에서 디바이스 트리 오버레이를 사용하는 경우

   하드웨어가 모듈화된 경우
   제품이 모듈형 설계로 되어 있다면, 디바이스 트리 오버레이를 통해 확장 가능한 하드웨어 구성을 지원할 수 있습니다.

> > > > > > 네, 리눅스 커널은 디바이스 트리(Device Tree)와 디바이스 트리 오버레이(Device Tree Overlay)를 사용하는 것을 권장하고 있으며, 이는 특히 모듈화와 유연성을 강화하려는 목적 때문입니다.
