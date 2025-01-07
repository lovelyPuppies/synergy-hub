# 첫 번째 스테이지: 빌드 단계
FROM ubuntu:24.04 AS builder

# 1단계: 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    vim

# 2단계: 테스트용 파일 작성
RUN echo "Step 2: Creating test file" | tee -a /testfile.txt

# 3단계: 파일에 추가 내용 쓰기
RUN echo "Step 3: Appending to test file" | tee -a /testfile.txt

# 두 번째 스테이지: 최종 이미지
FROM ubuntu:24.04

# 4단계: 첫 번째 스테이지에서 결과물 복사
COPY --from=builder /testfile.txt /testfile.txt

# 최종 실행 명령
CMD ["cat", "/testfile.txt"]
