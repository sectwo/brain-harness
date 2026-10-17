#!/bin/sh
# precommit-check.sh 회귀 시험. 임시 저장소를 만들어 통과(0)·차단(2)을 확인한다. 실패가 있으면 exit 1.
# 실행: sh ~/Brain/System/scripts/tests/precommit-check.test.sh

P="$(cd "$(dirname "$0")/.." && pwd)/precommit-check.sh"
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
R="$T/repo with space"
mkdir -p "$R" && cd "$R" || exit 1
git init -q . && git -c user.name=t -c user.email=t@t commit -q --allow-empty -m init

fail=0
check() {  # check <기대 exit> <설명> <명령>
  got=$(jq -n --arg c "$3" --arg d "$R" '{cwd: $d, tool_input: {command: $c}}' | sh "$P" 2>/dev/null; echo $?)
  if [ "$got" = "$1" ]; then echo "  ok   $2"; else echo "  FAIL $2 (기대 $1, 실제 $got)"; fail=1; fi
}

echo small > small.txt && git add small.txt
check 0 "작은 파일" 'git commit -m x'
check 0 "커밋 아닌 명령" 'ls -la'

head -c 6000000 /dev/zero > big.bin && git add big.bin
check 2 "5MB 초과" 'git commit -m x'
check 2 "-C 인용 경로(공백)" "git -C \"$R\" commit -m x"
check 2 "-c 옵션" 'git -c user.name=x commit -m x'
check 2 "--no-pager" 'git --no-pager commit -m x'
check 2 "cd 후 커밋" "cd \"$R\" && git commit -m x"
check 2 "commit -C HEAD(메시지 재사용)" 'git commit -C HEAD'
check 0 "우회(명령 앞)" 'BRAIN_PRECOMMIT_OK=1 git commit -m x'
check 0 "우회(&& 뒤 명령 앞)" 'git status && BRAIN_PRECOMMIT_OK=1 git commit -m x'
check 2 "우회 문자열만 있음" 'echo BRAIN_PRECOMMIT_OK=1; git commit -m x'
git reset -q big.bin && rm big.bin

mkdir -p web/node_modules/p && echo x > web/node_modules/p/i.js && git add -f web/node_modules
check 2 "node_modules" 'git commit -m x'
git reset -q web && rm -rf web

mkdir many && i=0 && while [ $i -lt 310 ]; do echo $i > many/$i.txt; i=$((i + 1)); done && git add many
check 2 "새 파일 300개 초과" 'git commit -m x'
git reset -q many && rm -rf many

git -c user.name=t -c user.email=t@t commit -q -m small
head -c 6000000 /dev/zero > small.txt
check 2 "-a 수정 큰 파일" 'git commit -am x'
check 2 "--all 수정 큰 파일" 'git commit --all -m x'
check 0 "-a 없이 수정 큰 파일(커밋 안 됨)" 'git commit -m x'

[ "$fail" = "0" ] && echo "전부 통과" || echo "실패 있음"
exit "$fail"
