#!/bin/sh
# 에이전트의 git commit 직전에 큰 파일·빌드 산출물·대량 미추적 폴더가 들어가는 것을 막는다. (하네스 L1 공통 스크립트)
# Claude Code: 전역 PreToolUse(Bash) 훅으로 자동 실행 (~/.claude/settings.json). stdin으로 훅 JSON을 받는다.
# 사람의 git commit에는 걸리지 않는다 (저장소별 git hook·husky는 건드리지 않기 위함).
#
# 막으면 exit 2 + 이유를 stderr로 (Claude가 읽고 멈춘다). 그 밖의 모든 경우(판단 불가 포함)는 exit 0으로 통과한다.
# 사람이 확인하고 그대로 커밋하라고 하면 명령 앞에 BRAIN_PRECOMMIT_OK=1을 붙인다.

MAX_BYTES=$((5 * 1024 * 1024))   # 파일 하나 상한 5MB
MAX_NEW_FILES=300                # 한 커밋에 새로 추가되는 파일 수 상한
JUNK_RE='(^|/)(node_modules|\.next|dist|build|\.venv|__pycache__)/'

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)

# git commit이 들어 있는 명령만 본다 (git -C <경로> commit 포함)
printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+commit([[:space:]]|$)' || exit 0
case "$cmd" in *BRAIN_PRECOMMIT_OK=1*) exit 0 ;; esac

# 저장소 위치: git -C <경로> > 맨 앞 cd <경로> > 훅의 cwd
dir=$(printf '%s' "$cmd" | sed -nE 's/.*git[[:space:]]+-C[[:space:]]+("[^"]+"|[^[:space:]]+)[[:space:]]+commit.*/\1/p' | head -1)
[ -n "$dir" ] || dir=$(printf '%s' "$cmd" | sed -nE 's/^[[:space:]]*cd[[:space:]]+("[^"]+"|[^[:space:];&]+).*/\1/p' | head -1)
dir=$(printf '%s' "$dir" | sed 's/^"//; s/"$//')
case "$dir" in "~"*) dir="$HOME${dir#\~}" ;; esac
[ -n "$dir" ] || dir="$cwd"
case "$dir" in /*) ;; *) dir="$cwd/$dir" ;; esac
git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# 커밋에 들어갈 파일: 스테이징된 것(크기는 인덱스) + (-a/--all이면) 수정된 추적 파일(크기는 작업 트리)
staged=$(git -C "$dir" diff --cached --name-only --diff-filter=AM 2>/dev/null)
added=$(git -C "$dir" diff --cached --name-only --diff-filter=A 2>/dev/null)
modified=""
if printf '%s' "$cmd" | grep -Eq 'commit([[:space:]]+[^[:space:]]+)*[[:space:]]+(-[a-zA-Z]*a[a-zA-Z]*|--all)([[:space:]]|$)'; then
  modified=$(git -C "$dir" diff --name-only --diff-filter=M 2>/dev/null)
fi

problems=""
root=$(git -C "$dir" rev-parse --show-toplevel)
big=$( {
  printf '%s\n' "$staged" | while IFS= read -r f; do
    [ -n "$f" ] && echo "$(git -C "$dir" cat-file -s ":$f" 2>/dev/null) $f"
  done
  printf '%s\n' "$modified" | while IFS= read -r f; do
    [ -n "$f" ] && echo "$(wc -c < "$root/$f" 2>/dev/null | tr -d ' ') $f"
  done
} | sort -rn | awk '{s=$1; sub(/^[^ ]* /, ""); if (!seen[$0]++) print s " " $0}' | while read -r size f; do
  [ -n "$size" ] && [ "$size" -gt "$MAX_BYTES" ] && echo "    $f ($((size / 1024 / 1024))MB)"
done)
[ -n "$big" ] && problems="$problems
  - 5MB 넘는 파일:
$big"

junk=$(printf '%s\n' "$added" | grep -E "$JUNK_RE" | sed -E "s#$JUNK_RE.*#\\1\\2/#" | sort | uniq -c | sort -rn | head -5)
[ -n "$junk" ] && problems="$problems
  - 빌드 산출물·의존성 폴더 (.gitignore에 넣는다):
$(printf '%s\n' "$junk" | awk '{printf "    %s (%s개)\n", $2, $1}')"

new_count=$(printf '%s\n' "$added" | sed '/^$/d' | wc -l | tr -d ' ')
if [ "$new_count" -gt "$MAX_NEW_FILES" ]; then
  top=$(printf '%s\n' "$added" | awk -F/ 'NF>1{print $1"/"} NF==1{print "(루트)"}' | sort | uniq -c | sort -rn | head -3 | awk '{printf "    %s (%s개)\n", $2, $1}')
  problems="$problems
  - 새 파일 ${new_count}개 (상한 ${MAX_NEW_FILES}개) — 미추적 폴더를 통째로 넣지 않았는지 확인:
$top"
fi

[ -n "$problems" ] || exit 0
{
  echo "[precommit-check] 커밋을 막았다 ($root)$problems"
  echo "  스테이징에서 빼거나(.gitignore) 사람에게 확인받는다. 사람이 그대로 커밋하라고 하면 명령 앞에 BRAIN_PRECOMMIT_OK=1을 붙인다."
} >&2
exit 2
