# # 📖 Index
# #   - original source by 조명근 팀원
# #   - modified additional source by 박준수 팀원


# #########################
# #########################
# # Author: 조명근 팀원
# import cv2
# import pytesseract
# import re
# import RPi.GPIO as GPIO
# import time
# import threading
# import socket


# # GPIO 핀 설정
# IR_SENSOR_PIN = 21  # 적외선 센서 입력 핀 (BCM 모드)
# SERVO1_PIN = 18  # 서보모터 제어 핀 (BCM 모드)
# SERVO2_PIN = 26  # 서보모터 제어 핀 (BCM 모드)

# # 서버 설정
# SERVER_IP = "10.10.14.35"  # 서버 IP 주소 (변경 필요)
# SERVER_PORT = 5000  # 서버 포트 번호 (변경 필요)
# USERNAME = "MGJ_LIN"  # 서버 로그인 아이디
# PASSWORD = "PASSWD"  # 서버 로그인 비밀번호

# # GPIO 초기화
# GPIO.setmode(GPIO.BCM)
# GPIO.setup(IR_SENSOR_PIN, GPIO.IN)  # 적외선 센서 입력
# GPIO.setup(SERVO1_PIN, GPIO.OUT)  # 서보모터 출력
# GPIO.setup(SERVO2_PIN, GPIO.OUT)

# # 서보모터 PWM 설정
# pwm1 = GPIO.PWM(SERVO1_PIN, 50)  # 50Hz (서보모터 주파수)
# pwm2 = GPIO.PWM(SERVO2_PIN, 50)  # 50Hz (서보모터 주파수)
# pwm1.start(0)  # 초기화
# pwm2.start(0)  # 초기화

# # 소켓 연결
# try:
#     client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     client_socket.connect((SERVER_IP, SERVER_PORT))
#     print(f"서버({SERVER_IP}:{SERVER_PORT})에 연결되었습니다.")

#     # 아이디와 비밀번호 전송
#     credentials = f"{USERNAME}:{PASSWORD}"
#     client_socket.sendall(credentials.encode("utf-8"))
#     print(f"로그인 정보 전송: {credentials}")
# except Exception as e:
#     print(f"서버에 연결할 수 없습니다: {e}")
#     client_socket = None


# # 각도에 따른 듀티 사이클 계산 함수
# def angle_to_duty_cycle(angle):
#     return 2.5 + (angle / 180.0) * 10


# # 서보모터 제어 함수
# def servo_control():
#     pwm1.ChangeDutyCycle(angle_to_duty_cycle(90))
#     pwm2.ChangeDutyCycle(angle_to_duty_cycle(0))
#     time.sleep(3)  # 3초 유지

#     pwm1.ChangeDutyCycle(angle_to_duty_cycle(0))
#     pwm2.ChangeDutyCycle(angle_to_duty_cycle(90))
#     print("서보모터가 원래 위치로 복귀합니다.")

#     time.sleep(3)
#     pwm1.ChangeDutyCycle(0)
#     pwm2.ChangeDutyCycle(0)


# # 텍스트 인식 함수
# def camera_text_detection():
#     cap = cv2.VideoCapture(0)
#     if not cap.isOpened():
#         print("웹캠을 열 수 없습니다.")
#         return

#     print("카메라 텍스트 인식 스레드 시작. ESC 키를 눌러 종료하세요.")

#     while True:
#         ret, frame = cap.read()
#         if not ret:
#             print("프레임 읽기 실패.")
#             continue

#         # 그레이스케일 변환
#         gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

#         # 텍스트 인식 수행
#         text = pytesseract.image_to_string(gray, lang="kor")
#         filtered_text = re.findall(r"(\d{3}+동).*?(\d{3}+호)", text)
#         if GPIO.input(IR_SENSOR_PIN) == GPIO.LOW:
#             if filtered_text:
#                 for match in filtered_text:
#                     message = f"[ALLMSG]{match[0]}@{match[1]}\n"  # 동과 호를 함께 출력
#                     print(f"인식된 텍스트: {message.strip()}")

#                     # 서버로 데이터 전송
#                     if client_socket:
#                         try:
#                             client_socket.sendall(message.encode("utf-8"))
#                             print(f"서버로 전송: {message.strip()}")
#                         except Exception as e:
#                             print(f"데이터 전송 실패: {e}")
#                     servo_control()

#         # 화면에 출력
#         cv2.imshow("Real-Time Text Detection", frame)

#         # ESC 키로 종료
#         if cv2.waitKey(1) == 27:
#             break

#     cap.release()
#     cv2.destroyAllWindows()


# # 멀티스레드 실행
# def main():
#     try:
#         # 스레드 생성

#         camera_thread = threading.Thread(target=camera_text_detection, daemon=True)

#         # 스레드 시작

#         camera_thread.start()

#         # 메인 스레드가 종료되지 않도록 대기
#         while True:
#             time.sleep(1)

#     except KeyboardInterrupt:
#         print("프로그램 종료.")

#     finally:
#         pwm1.stop()
#         pwm2.stop()
#         GPIO.cleanup()
#         if client_socket:
#             client_socket.close()
#             print("서버 연결을 종료했습니다.")
#         print("리소스를 정리했습니다.")


# if __name__ == "__main__":
#     main()

# #########################
# # Author: 박준수 팀원
# ## 🚧 Prerequisite
# #   %shell> pip install protobuf==5.29.3


# %%
from IPython.core.interactiveshell import InteractiveShell
from external.protobuf import smart_pkg_delivery_pb2
import socket
import time

InteractiveShell.ast_node_interactivity = "all"


SERVER_IP = "10.10.14.19"
SERVER_PORT = 1234


def main():
    # 소켓 연결
    try:
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client_socket.connect((SERVER_IP, SERVER_PORT))
        print(f"서버({SERVER_IP}:{SERVER_PORT})에 연결되었습니다.")
        while True:
            wrapper_msg = smart_pkg_delivery_pb2.WrapperMsg()
            msg1_node_event = wrapper_msg.node_event
            address = msg1_node_event.pkg_arrival_event.address
            address.building_num = 105
            address.unit_num = 505
            time.sleep(5)
    except Exception as e:
        print(f"서버에 연결할 수 없습니다: {e}")
        client_socket = None
    finally:
        if client_socket:
            client_socket.close()
            print("서버 연결을 종료했습니다.")
        print("리소스를 정리했습니다.")


# %% 🧪🆗 Test protobuf for Encoding, Decoding
wrapper_msg = smart_pkg_delivery_pb2.WrapperMsg()
msg1_node_event = wrapper_msg.node_event
address = msg1_node_event.pkg_arrival_event.address
address.building_num = 105
address.unit_num = 505

print(f"Before encoded:\n {wrapper_msg}\n\n")

# Method
x: str = wrapper_msg.SerializePartialToString()
print(f"Encoded string (size: {len(x)} bytes):\n{x}\n\n")

# Method
wrapper_msg2 = smart_pkg_delivery_pb2.WrapperMsg()
y: int = wrapper_msg2.ParseFromString(x)
print(f"Decoded string (size: {y} bytes):\n{wrapper_msg2}\n\n")
