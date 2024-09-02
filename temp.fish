#!/usr/bin/env fish
# custom_fish_formatter.fish: fish_indent 결과를 스페이스 2칸으로 인덴트 조정

# 입력된 파일을 인자로 받아 처리합니다

# fish_indent 실행 후 탭을 스페이스 2칸으로 변환
fish_indent <$input_file | sed 's/\t/  /g' >"$input_file.formatted"

# 원본 파일에 덮어쓰기
mv "$input_file.formatted" $input_file
set input_file prototypes/_initialization/ubuntu/snippets_examples/configure_bridge_network_to_vm.fish
fish_indent <$input_file | sed 's/\t/  /g'
