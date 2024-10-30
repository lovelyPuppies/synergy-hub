#!/usr/bin/env fish

# 감시할 디렉토리 설정
set WATCH_DIR $HOME/repos/synergy-hub/prototypes/_initialization/ubuntu/howto/general

# 실시간 감시 시작
inotifywait -m -e create -e modify --format '%w%f' $WATCH_DIR | while read FILE
    # 조건 검사: .fish 확장자 파일이고 일반 파일인지 확인
    if test (string match -r '\.fish$' $FILE) -a -f $FILE
        chmod u+x $FILE
        echo "Changed permissions for $FILE"
    end
end
