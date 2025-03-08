# First stage: Build phase
FROM ubuntu:24.04 AS builder

# 📍 Set environment variables for timezone and to suppress interactive prompts during package installation 📅 2025-01-09 00:34:14
ENV DEBIAN_FRONTEND=noninteractive
# 🌏 Set the system timezone to Asia/Seoul
ENV TZ=Asia/Seoul

# Install essential packages and configure timezone
RUN apt-get update && \
  apt-get install -y \
  curl nano && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime


# # 2단계: 테스트용 파일 작성
# RUN echo "Step 2: Creating test file" | tee -a /testfile.txt

# # 3단계: 파일에 추가 내용 쓰기
# RUN echo "Step 3: Appending to test file" | tee -a /testfile.txt

# # 두 번째 스테이지: 최종 이미지
# FROM ubuntu:24.04

# # 4단계: 첫 번째 스테이지에서 결과물 복사
# COPY --from=builder /testfile.txt /testfile.txt

# # 최종 실행 명령
# CMD ["cat", "/testfile.txt"]
