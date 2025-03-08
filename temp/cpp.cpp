// TCMalloc Test: clang++ -o cpp cpp.cpp -ltcmalloc_minimal && ./cpp && ldd ./cpp | grep tcmalloc
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

int get_seconds(const string &min_sec) {
  int minutes, seconds;
  sscanf(min_sec.c_str(), "%d:%d", &minutes, &seconds);
  return minutes * 60 + seconds;
}

string format_time(int total_seconds) {
  auto result = std::div(total_seconds, 60);
  stringstream ss;
  ss << setfill('0') << setw(2) << result.quot << ":" << setw(2) << result.rem;
  return ss.str();
}
string solution(string video_len, string pos, string op_start, string op_end,
                vector<string> commands) {
  int video_len_int = get_seconds(video_len);
  int op_start_int = get_seconds(op_start);
  int op_end_int = get_seconds(op_end);
  int pos_int = get_seconds(pos);

  auto move_to_opend = [&](int sec) -> int {
    if (op_start_int <= sec && sec <= op_end_int) {
      return op_end_int;
    }
    return sec;
  };

  pos_int = move_to_opend(pos_int);

  for (const auto &command : commands) {
    if (command == "next") {
      pos_int += 10;
      if (pos_int > video_len_int - 10) {
        pos_int = video_len_int;
      }
    } else if (command == "prev") {
      pos_int -= 10;
      if (pos_int < 10) {
        pos_int = 0;
      }
    }
    pos_int = move_to_opend(pos_int);
  }

  return format_time(pos_int);
}

// class Test {
// public:
//   int value;
//   Test(int v) : value(v) {
//     std::cout << "Test 객체 생성: " << value << std::endl;
//   }
//   ~Test() { std::cout << "Test 객체 소멸: " << value << std::endl; }
// };

// int main() {
//   std::cout << "TCMalloc 테스트: new/delete 사용" << std::endl;

//   // new를 사용하여 객체 할당
//   Test *obj = new Test(42);

//   // 객체 출력
//   std::cout << "Test 객체 값: " << obj->value << std::endl;

//   // 객체 해제
//   delete obj;

//   return 0;
// }
