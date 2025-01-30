// TCMalloc Test: clang++ -o cpp cpp.cpp -ltcmalloc_minimal && ./cpp && ldd ./cpp | grep tcmalloc
#include <iostream>

class Test {
public:
  int value;
  Test(int v) : value(v) {
    std::cout << "Test 객체 생성: " << value << std::endl;
  }
  ~Test() { std::cout << "Test 객체 소멸: " << value << std::endl; }
};

int main() {
  std::cout << "TCMalloc 테스트: new/delete 사용" << std::endl;

  // new를 사용하여 객체 할당
  Test *obj = new Test(42);

  // 객체 출력
  std::cout << "Test 객체 값: " << obj->value << std::endl;

  // 객체 해제
  delete obj;

  return 0;
}
