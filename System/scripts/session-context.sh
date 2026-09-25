#!/bin/sh
# 세션 시작 시 이어서 작업할 맥락을 출력한다. (하네스 L1 공통 스크립트)
# Claude Code: 전역 SessionStart 훅으로 자동 실행 (~/.claude/settings.json)
# Codex: 작업 시작 전에 `sh ~/Brain/System/scripts/session-context.sh`를 직접 실행 (Rules.md)
#
# 프로젝트는 저장소 루트의 .harness-project(한 줄: vault 프로젝트 이름) 또는 HARNESS_PROJECT로 찾는다.
# Handoff.md / Overview.md는 프로젝트 CLAUDE.md가 따로 불러오므로 여기서는
# 마지막 /handoff 이후에 쌓인 세션 로그와 현재 worktree 상태만 보여준다.

BRAIN="${HARNESS_BRAIN:-$HOME/Brain}"
SYSTEM="$BRAIN/System"
USAGE="$HOME/.claude/state/usage.json"
MAX_LOGS=5

echo "# 세션 이어가기 맥락 (자동 생성)"
echo

# --- L1 ---
echo "## L1 (PC 전체)"
echo "- 공통 규칙: \`$SYSTEM/Rules.md\` / 환경: \`Environment.md\` / 공통 지식: \`Knowledge/\`"
if [ -d "$SYSTEM/Knowledge" ]; then
  knowledge=$(ls "$SYSTEM/Knowledge" 2>/dev/null | grep -v '^README.md$' | sed 's/\.md$//' | tr '\n' ',' | sed 's/,$//; s/,/, /g')
  [ -n "$knowledge" ] && echo "- 지식 목록: $knowledge"
fi
if [ -f "$USAGE" ] && command -v jq >/dev/null 2>&1; then
  jq -r '"- 사용량(마지막 기록): 5시간 \(.five_hour.used_pct // "?")% · 7일 \(.seven_day.used_pct // "?")% · 모델 \(.model // "?")"' "$USAGE" 2>/dev/null
fi
# 정기 점검 주기 확인 (Reviews.md의 last_review + review_interval_days)
reviews="$SYSTEM/Reviews.md"
if [ -f "$reviews" ]; then
  last=$(sed -n 's/^last_review:[[:space:]]*//p' "$reviews" | head -1)
  interval=$(sed -n 's/^review_interval_days:[[:space:]]*//p' "$reviews" | head -1)
  last_s=$(date -j -f %Y-%m-%d "$last" +%s 2>/dev/null || echo 0)
  days=$(( ( $(date +%s) - last_s ) / 86400 ))
  if [ "$days" -ge "${interval:-30}" ]; then
    echo "- 🧠 브레인 정기 점검 시기: 마지막 점검 $last (${days}일 전, 주기 ${interval:-30}일). 사람에게 점검을 제안한다 (Reviews.md 절차)."
  else
    echo "- 브레인 정기 점검: 마지막 $last, 다음은 $(( ${interval:-30} - days ))일 뒤"
  fi
fi
echo

# --- L2 / L3 ---
root=$(git rev-parse --show-toplevel 2>/dev/null)
project="${HARNESS_PROJECT:-}"
if [ -z "$project" ] && [ -n "$root" ] && [ -f "$root/.harness-project" ]; then
  project=$(head -1 "$root/.harness-project" | tr -d '[:space:]')
fi
if [ -z "$project" ]; then
  echo "## 프로젝트: 연결 없음"
  echo "- 저장소에 \`.harness-project\`가 없다. L1 규칙만 적용한다. 새 프로젝트면 \`/new-project\`를 제안한다."
  exit 0
fi

VAULT="$BRAIN/Projects/$project"
echo "## L2 프로젝트: $project (\`$VAULT\`)"
if [ ! -d "$VAULT" ]; then
  echo "⚠️ 프로젝트 vault가 없다. 사람에게 알리고 \`/new-project\`로 만들지 묻는다."
  exit 0
fi
[ -d "$VAULT/Agents" ] && echo "- L3 에이전트 노트: $(ls "$VAULT/Agents" 2>/dev/null | tr '\n' ' ')"

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
today=$(date +%Y-%m-%d)

echo
echo "## 현재 worktree"
echo "- 브랜치(worktree명): \`$branch\`"
echo "- 커밋 안 된 변경: ${changes}개"
echo "- 최근 커밋: $(git log -1 --format='%h %s' 2>/dev/null)"
echo "- 이번 세션 로그: \`Sessions/${today}-${branch}-<claude|codex>.md\` (이미 있으면 이어서 쓴다)"
echo

last_handoff=$(sed -n 's/^last_handoff:[[:space:]]*//p' "$VAULT/Handoff.md" 2>/dev/null | head -1)
[ -n "$last_handoff" ] || last_handoff="0000-00-00"

# 파일명 앞의 날짜가 last_handoff 이상인 로그 (같은 날은 반영 여부를 알 수 없으므로 포함)
logs=$(ls "$VAULT/Sessions" 2>/dev/null \
  | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}-.+\.md$' \
  | awk -v d="$last_handoff" 'substr($0,1,10) >= d' \
  | sort | tail -n "$MAX_LOGS")

echo "## 마지막 /handoff($last_handoff) 이후 세션 로그"
if [ -z "$logs" ]; then
  echo "- 없음. Handoff.md가 최신이다."
  exit 0
fi
echo "Handoff.md에 아직 반영되지 않았을 수 있다. Handoff.md와 다르면 더 최근 로그를 따른다."
echo

for f in $logs; do
  echo "### Sessions/$f"
  # frontmatter는 빼고 본문만
  awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$VAULT/Sessions/$f" | head -60
  echo
done
