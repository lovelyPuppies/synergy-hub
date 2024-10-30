.global _start
.section .text

_start:
    // 출력할 문자열을 정의
    MOV X0, #1              // 1은 stdout (표준 출력)
    LDR X1, =message        // X1에 출력할 문자열 주소를 로드
    MOV X2, #13             // 문자열 길이 (13바이트)
    MOV X8, #64             // write 시스템 호출 번호
    SVC #0                  // 시스템 호출

    // 종료
    MOV X8, #93             // exit 시스템 호출 번호
    MOV X0, #0              // 종료 코드 0
    SVC #0                  // 시스템 호출

.section .data
message:
    .asciz "Hello, world!\n" // 출력할 문자열

