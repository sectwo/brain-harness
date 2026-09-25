#!/bin/sh
# UserPromptSubmit 훅: 사용량이 기준을 넘으면 에이전트에게 경고를 넣는다. 기준 미만이면 아무것도 출력하지 않는다.
# 기준: HARNESS_USAGE_WARN (기본 80%). 6시간 넘게 갱신 안 된 기록은 무시한다.

USAGE="$HOME/.claude/state/usage.json"
WARN="${HARNESS_USAGE_WARN:-80}"
[ -f "$USAGE" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

jq -r --argjson now "$(date +%s)" --argjson warn "$WARN" '
  select(($now - (.updated_at // 0)) < 21600)
  | .model as $model
  | [ (if (.five_hour.used_pct // 0) >= $warn then "5시간 \(.five_hour.used_pct | floor)%" else empty end),
      (if (.seven_day.used_pct // 0) >= $warn then "7일 \(.seven_day.used_pct | floor)%" else empty end) ]
  | select(length > 0)
  | "⚠️ [하네스] 사용량 경고: \(join(", ")) 사용 (기준 \($warn)%). 현재 모델 \($model). Rules.md 5절: 비싼 모델은 꼭 필요한 곳에만 쓰고, 모델을 낮춰야 하면 바꾸기 전에 사람에게 먼저 말한다."
' "$USAGE" 2>/dev/null
exit 0
