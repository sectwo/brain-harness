#!/bin/sh
# 세션 시작 시 이어서 작업할 맥락을 출력한다. (하네스 L1 공통 스크립트)
# Claude Code: 전역 SessionStart 훅으로 자동 실행 (~/.claude/settings.json)
# Codex: 작업 시작 전에 `sh ~/Brain/System/scripts/session-context.sh --handoff`를 직접 실행 (Rules.md)
#
# 프로젝트는 저장소 루트의 .harness-project(한 줄: vault 프로젝트 이름) 또는 HARNESS_PROJECT로 찾는다.
# Handoff.md는 프로젝트 CLAUDE.md가 불러오고(Codex는 `--handoff` 옵션으로 여기서 출력),
# Overview.md는 색인(절 제목)만 보여 준다. 그 밖에 현재 worktree 상태, 색인(결정·지식·세션 로그 요약),
# 마지막 /handoff 이후에 쌓인 세션 로그의 요약·막힌 점·다음 할 일을 보여 준다.
# 첫 메시지가 `시작`·`이어서`뿐일 때 에이전트가 할 일(할 수 있는 일/기다리는 일 정리, 추천 1개)도 한 절로 지시한다.
#
# 옵션:
#   --handoff   마지막에 프로젝트 Handoff.md 본문을 그대로 붙인다 (Codex용)

BRAIN="${HARNESS_BRAIN:-$HOME/Brain}"
SYSTEM="$BRAIN/System"
USAGE="$HOME/.claude/state/usage.json"
MAX_LOGS=5          # /handoff 이후 로그·색인의 세션 로그 개수
MAX_LOG_LINES=25    # 로그 하나당 출력 상한
MAX_DECISIONS=5     # 색인의 프로젝트 결정 개수
MAX_KNOWLEDGE=15    # 색인의 지식 문서 개수

WITH_HANDOFF=0
for arg in "$@"; do
  case "$arg" in
    --handoff) WITH_HANDOFF=1 ;;
  esac
done

# --- 공통 함수 ---
# fm_summary <파일>: frontmatter(첫 줄 ---부터 다음 ---까지) 안의 summary: 값. 없으면 "(summary 없음)".
fm_summary() {
  _s=$(awk 'NR==1 { if ($0 != "---") exit; next }
            /^---[[:space:]]*$/ { exit }
            /^summary:/ { sub(/^summary:[[:space:]]*/, ""); print; exit }' "$1" 2>/dev/null \
       | sed 's/^"\(.*\)"$/\1/; s/^'"'"'\(.*\)'"'"'$/\1/')
  if [ -n "$_s" ]; then echo "$_s"; else echo "(summary 없음)"; fi
}

# decision_titles <파일> <n>: "## YYYY-MM-DD — 제목" 중 마지막 n개 (제목만)
decision_titles() {
  grep '^## [0-9]\{4\}-' "$1" 2>/dev/null | sed 's/^## //' | tail -n "$2"
}

# section <파일> <절 제목>: "## <절 제목>"으로 시작하는 절(들)을 다음 "## " 전까지 출력
section() {
  awk -v h="## $2" '/^## / { p = (index($0, h) == 1) } p' "$1" 2>/dev/null
}

# section_any <파일> <절 제목>...: 앞에서부터 처음으로 내용이 있는 절을 출력 (구 로그 절 이름 호환용)
section_any() {
  _f="$1"; shift
  for _t in "$@"; do
    _out=$(section "$_f" "$_t")
    if [ -n "$_out" ]; then echo "$_out"; return 0; fi
  done
  return 1
}

# body <파일>: frontmatter를 뺀 본문
body() {
  awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---[[:space:]]*$/ {fm=0; next} !fm' "$1" 2>/dev/null
}

# knowledge_files <폴더>: README.md·_template.md를 뺀 *.md 파일명 (확장자 없이)
knowledge_files() {
  ls "$1" 2>/dev/null | grep '\.md$' | grep -v -e '^README\.md$' -e '^_template\.md$' | sed 's/\.md$//'
}

# finish: --handoff면 Handoff.md 본문을 붙이고 끝낸다. VAULT가 정해진 뒤의 모든 종료는 이것으로.
finish() {
  if [ "$WITH_HANDOFF" = "1" ] && [ -n "${VAULT:-}" ] && [ -f "$VAULT/Handoff.md" ]; then
    echo
    echo "## Handoff.md (--handoff)"
    body "$VAULT/Handoff.md"
  fi
  exit 0
}

echo "# 세션 이어가기 맥락 (자동 생성)"
echo

# --- L1 ---
echo "## L1 (PC 전체)"
echo "- 공통 규칙: \`$SYSTEM/Rules.md\` / 환경: \`Environment.md\` / 공통 지식: \`Knowledge/\`"
if [ -d "$SYSTEM/Knowledge" ]; then
  knowledge=$(knowledge_files "$SYSTEM/Knowledge" | tr '\n' ',' | sed 's/,$//; s/,/, /g')
  [ -n "$knowledge" ] && echo "- 지식 목록: $knowledge"
fi
if [ -f "$SYSTEM/Decisions.md" ]; then
  echo "- 최근 전역 결정 (\`System/Decisions.md\` 마지막 3개):"
  decision_titles "$SYSTEM/Decisions.md" 3 | sed 's/^/  - /'
fi
if [ -f "$USAGE" ] && command -v jq >/dev/null 2>&1; then
  jq -r '"- 사용량(마지막 기록): 5시간 \(.five_hour.used_pct // "?")% · 7일 \(.seven_day.used_pct // "?")% · 모델 \(.model // "?")"' "$USAGE" 2>/dev/null
fi
# 하네스 점검 (doctor.sh --quiet: 네트워크 없이, WARN 줄만)
if [ -f "$SYSTEM/scripts/doctor.sh" ]; then
  warns=$(sh "$SYSTEM/scripts/doctor.sh" --quiet 2>/dev/null | sed -n 's/^  WARN //p')
  if [ -z "$warns" ]; then
    echo "- 점검(doctor): 경고 0"
  else
    echo "- 점검(doctor): 경고 $(echo "$warns" | wc -l | tr -d ' ')개 — 자세히는 \`sh $SYSTEM/scripts/doctor.sh\`"
    echo "$warns" | head -3 | sed 's/^/  - /'
  fi
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

echo "## 첫 메시지가 \`시작\`·\`이어서\`처럼 구체적 요청이 없으면"
echo "- Handoff의 다음 할 일과 아래 '/handoff 이후 세션 로그'를 보고 '지금 바로 할 수 있는 일 / 사람 답을 기다리는 일'로 나눠 정리한다."
echo "- 추천 다음 작업 1개를 계획과 함께 제안한다 (구현은 사람 확인 후)."
echo "- 현재 worktree가 그 작업에 맞지 않으면(코드 작업인데 master, 병합 끝난 worktree 등) 함께 알린다."
echo

# --- 색인 (저장하지 않고 매번 만든다: Overview 절 제목, Decisions 제목, frontmatter summary) ---
all_logs=$(ls "$VAULT/Sessions" 2>/dev/null \
  | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}-.+\.md$' | sort)

echo "## 색인"
if [ -f "$VAULT/Overview.md" ]; then
  sections=$(grep '^## ' "$VAULT/Overview.md" | sed 's/^## //' | paste -sd, - | sed 's/,/, /g')
  echo "- Overview 절: ${sections:-(절 없음)} → 필요한 절만 Read. Overview 전체가 필요하면(회사 정보 대조 등) 직접 읽는다."
fi
if [ -f "$VAULT/Decisions.md" ]; then
  echo "- 결정(최근 $MAX_DECISIONS, \`Decisions.md\`):"
  decision_titles "$VAULT/Decisions.md" "$MAX_DECISIONS" | sed 's/^/  - /'
fi
if [ -d "$VAULT/Knowledge" ]; then
  echo "- 지식 (\`Knowledge/\`):"
  kcount=0
  for k in $(knowledge_files "$VAULT/Knowledge" | head -n "$MAX_KNOWLEDGE"); do
    echo "  - $k — $(fm_summary "$VAULT/Knowledge/$k.md")"
    kcount=$((kcount + 1))
  done
  [ "$kcount" = "0" ] && echo "  - (없음)"
fi
echo "- 세션 로그(최근 $MAX_LOGS, \`Sessions/\`):"
if [ -n "$all_logs" ]; then
  for f in $(echo "$all_logs" | tail -n "$MAX_LOGS"); do
    echo "  - ${f%.md} — $(fm_summary "$VAULT/Sessions/$f")"
  done
else
  echo "  - (없음)"
fi
echo

last_handoff=$(sed -n 's/^last_handoff:[[:space:]]*//p' "$VAULT/Handoff.md" 2>/dev/null | head -1)
[ -n "$last_handoff" ] || last_handoff="0000-00-00"

# 파일명 앞의 날짜가 last_handoff 이상인 로그 (같은 날은 반영 여부를 알 수 없으므로 포함)
logs=$(echo "$all_logs" | awk -v d="$last_handoff" 'substr($0,1,10) >= d' | tail -n "$MAX_LOGS")

echo "## 마지막 /handoff($last_handoff) 이후 세션 로그"
if [ -z "$logs" ]; then
  echo "- 없음. Handoff.md가 최신이다."
  finish
fi
echo "Handoff.md에 아직 반영되지 않았을 수 있다. Handoff.md와 다르면 더 최근 로그를 따른다."
echo "로그마다 summary·막힌 점·다음 할 일만 보여 준다(${MAX_LOG_LINES}줄 상한). 전체는 파일을 Read."
echo

for f in $logs; do
  echo "### Sessions/$f"
  path="$VAULT/Sessions/$f"
  summary=$(fm_summary "$path")
  if [ "$summary" != "(summary 없음)" ]; then
    {
      echo "- summary: $summary"
      section "$path" "막힌 점"
      section_any "$path" "다음 세션에" "다음 할 일"
    } | head -n "$MAX_LOG_LINES"
  else
    # summary가 없는 옛 로그: 본문 앞부분만 (하위 호환)
    body "$path" | head -n "$MAX_LOG_LINES"
  fi
  echo
done

finish
