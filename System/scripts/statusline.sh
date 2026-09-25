#!/bin/sh
# Claude Code 상태줄: 모델, 컨텍스트 %, 5시간·7일 사용량을 보여 주고
# 사용량을 ~/.claude/state/usage.json에 기록한다 (usage-check.sh와 session-context.sh가 읽음).
# rate_limits는 claude.ai Pro/Max 구독에서만 들어온다.

input=$(cat)
STATE="$HOME/.claude/state"
mkdir -p "$STATE"

echo "$input" | jq -c --argjson now "$(date +%s)" '{
  updated_at: $now,
  model: .model.display_name,
  context_pct: (.context_window.used_percentage // null),
  five_hour: {used_pct: (.rate_limits.five_hour.used_percentage // null), resets_at: (.rate_limits.five_hour.resets_at // null)},
  seven_day: {used_pct: (.rate_limits.seven_day.used_percentage // null), resets_at: (.rate_limits.seven_day.resets_at // null)}
}' > "$STATE/usage.json.tmp" 2>/dev/null && mv "$STATE/usage.json.tmp" "$STATE/usage.json"

echo "$input" | jq -r '
  def pct(x): if x == null then "–" else "\(x | floor)%" end;
  "[\(.model.display_name)] ctx \(pct(.context_window.used_percentage)) | 5h \(pct(.rate_limits.five_hour.used_percentage)) · 7d \(pct(.rate_limits.seven_day.used_percentage))"'
