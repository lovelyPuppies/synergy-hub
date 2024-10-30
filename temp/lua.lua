local input_file = arg[1]  -- 첫 번째 인수: 입력 파일 경로
local output_file = arg[2] -- 두 번째 인수: 출력 파일 경로
local unique_comment = "# Add ll alias for lsd" -- 고유 주석
local interactive_block_start = "if status --is-interactive"

local found = false

-- 파일 열기
local input = io.open(input_file, "r")
local output = io.open(output_file, "w")

for line in input:lines() do
    -- 기존 줄 쓰기
    output:write(line .. "\n")

    -- 시작 블록 찾기
    if not found and line:match(interactive_block_start) then
        found = true
    elseif found and line:match("^end$") then
        -- 새 코드 삽입
        output:write("    " .. unique_comment .. "\n")
        output:write("    function ll\n")
        output:write("        lsd -l $argv\n")
        output:write("    end\n\n")
        output:write(line .. "\n") -- "end" 줄 쓰기
        found = false
        break -- 작업 완료 후 종료
    end
end

-- 나머지 줄 처리
if found then
    for line in input:lines() do
        output:write(line .. "\n")
    end
end

-- 파일 닫기
input:close()
output:close()
