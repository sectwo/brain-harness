#!/bin/sh
# brain-harness 프로젝트 SessionStart 훅: task-observer(one-skill) 활성화 + 리뷰 상태를 맥락에 넣는다. (실험 트랙)
# 원본 references/environments.md "A session-start hook" 예시를 각색 — 작업 폴더는 실험 격리 위치로 고정.
WS="${TASK_OBSERVER_WORKSPACE:-$HOME/.brain-experiments/task-observer}"
SKILL_DIR="$(cd "$(dirname "$0")/../skills/task-observer" 2>/dev/null && pwd)"
d="$WS/skill-observations"
open=$(find "$d/observation-log" -maxdepth 1 -name '*.md' -exec grep -l '^status: open$' {} + 2>/dev/null | wc -l | tr -d ' ')
last=$(tr -d '\r' 2>/dev/null < "$d/last-review-date.txt"); last=${last:-never}
msg="Make the first tool call of this session one batched call that both lists the task-observer workspace ($WS) and invokes the task-observer skill; then run its Session Start Protocol. Observation files are created only by $SKILL_DIR/scripts/new-observation.sh, never by copying a header. Write observations in Korean."
msg="$msg Open observations: ${open:-0}; last review: $last."
cutoff=$(date -v-7d +%F 2>/dev/null || date -d '7 days ago' +%F)
if [ "${open:-0}" -gt 0 ]; then
  case "$last" in
    never) msg="$msg Offer the review." ;;
    *) [ "$(printf '%s\n%s\n' "$last" "$cutoff" | sort | head -1)" = "$last" ] && msg="$msg Offer the review." ;;
  esac
fi
msg=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr -d '\000-\037')
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
