#!/bin/sh
# 브레인 하네스 상태 점검. 아무것도 고치지 않고 확인만 한다. 사람이 직접 실행하고, 세션 시작 때 --quiet로 자동 실행된다.
# 점검 항목은 2026-09-25 2차 Fable 리뷰에서 "문서와 실제가 달랐던" 지점들 위주로 골랐다.
#
# 옵션:
#   --quiet   git fetch(네트워크)를 건너뛴다. session-context.sh가 세션 시작 때 WARN 줄만 골라 쓴다.

BRAIN="${HARNESS_BRAIN:-$HOME/Brain}"
QUIET=0
[ "${1:-}" = "--quiet" ] && QUIET=1
ok()   { echo "  OK   $1"; }
warn() { echo "  WARN $1"; }
info() { echo "  --   $1"; }

echo "# 브레인 하네스 점검 ($(date '+%Y-%m-%d %H:%M'))"
echo

echo "## 필수 도구 (bootstrap.sh 최소조건)"
# jq가 없으면 훅 4개가 조용히 꺼지므로 가장 먼저 본다.
for tool in git jq claude; do
  if command -v "$tool" >/dev/null 2>&1; then
    ok "$tool 설치됨"
  else
    warn "$tool 없음 — 설치 필요 (docs/setup.md 최소조건 참고)"
  fi
done
echo

echo "## 옵시디언 vault 등록"
OBS_JSON="$HOME/Library/Application Support/obsidian/obsidian.json"
if [ -f "$OBS_JSON" ] && command -v jq >/dev/null 2>&1; then
  if jq -e --arg p "$BRAIN" '.vaults[] | select(.path == $p)' "$OBS_JSON" >/dev/null 2>&1; then
    ok "obsidian.json에 $BRAIN 등록됨"
  else
    warn "obsidian.json에 $BRAIN 미등록 (옵시디언 앱에서 Open folder as vault로 열어야 한다)"
  fi
else
  warn "obsidian.json을 찾을 수 없음: $OBS_JSON"
fi
[ -d "$BRAIN/.obsidian" ] && ok "$BRAIN/.obsidian 존재" || warn "$BRAIN/.obsidian 없음 (한 번도 vault로 연 적 없음)"
echo

echo "## Headroom 프록시"
if command -v headroom >/dev/null 2>&1; then
  if curl -s -o /dev/null -m 2 http://127.0.0.1:8787/stats 2>/dev/null; then
    ok "127.0.0.1:8787 응답함"
  else
    warn "127.0.0.1:8787 응답 없음 (launchctl kickstart -k gui/\$(id -u)/com.headroom.default)"
  fi
else
  warn "headroom 명령을 찾을 수 없음 (PATH 확인)"
fi
echo

echo "## Orca 설정"
ORCA_JSON="$HOME/Library/Application Support/orca/profiles/local-default/orca-data.json"
if [ -f "$ORCA_JSON" ] && command -v jq >/dev/null 2>&1; then
  codex_cmd=$(jq -r '.settings.agentCmdOverrides.codex // empty' "$ORCA_JSON" 2>/dev/null)
  if [ -n "$codex_cmd" ]; then
    ok "agentCmdOverrides.codex 설정됨: $codex_cmd"
  else
    warn "agentCmdOverrides.codex 미설정 → Orca의 Codex는 Headroom을 거치지 않는다"
  fi
  codex_args=$(jq -r '.settings.agentDefaultArgs.codex // empty' "$ORCA_JSON" 2>/dev/null)
  case "$codex_args" in
    *dangerously-bypass*) warn "agentDefaultArgs.codex에 --dangerously-bypass-approvals-and-sandbox 있음 (샌드박스 무력화 상태)" ;;
    *) [ -n "$codex_args" ] && info "agentDefaultArgs.codex: $codex_args" ;;
  esac
else
  warn "orca-data.json을 찾을 수 없음: $ORCA_JSON"
fi
echo

echo "## git / gh (brain-harness)"
if git -C "$BRAIN" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  remote=$(git -C "$BRAIN" remote get-url origin 2>/dev/null)
  [ -n "$remote" ] && ok "origin: $remote" || warn "origin remote 없음"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    ok "gh 로그인 상태"
  else
    warn "gh 로그인 안 됨 (gh auth login 필요)"
  fi
  [ "$QUIET" = "1" ] || git -C "$BRAIN" fetch origin >/dev/null 2>&1
  counts=$(git -C "$BRAIN" rev-list --left-right --count origin/main...main 2>/dev/null)
  if [ -n "$counts" ]; then
    behind=$(echo "$counts" | awk '{print $1}')
    ahead=$(echo "$counts" | awk '{print $2}')
    info "origin/main 대비: ahead $ahead, behind $behind (/brain-sync로 동기화)"
  fi
  dirty=$(git -C "$BRAIN" status --porcelain | wc -l | tr -d ' ')
  [ "$dirty" = "0" ] && ok "커밋 안 된 변경 없음" || info "커밋 안 된 변경 ${dirty}개"
else
  warn "$BRAIN이 git 저장소가 아님"
fi
echo

echo "## 명령어 동기화 (vault ↔ ~/.claude/commands)"
SRC="$BRAIN/System/commands"
DST="$HOME/.claude/commands"
if [ -d "$SRC" ]; then
  diff_found=0
  for f in "$SRC"/*.md; do
    name=$(basename "$f")
    if [ ! -f "$DST/$name" ] || ! diff -q "$f" "$DST/$name" >/dev/null 2>&1; then
      warn "$name: vault와 ~/.claude/commands 불일치 (install-commands.sh 실행 필요)"
      diff_found=1
    fi
  done
  [ "$diff_found" = "0" ] && ok "모든 명령어 파일이 vault와 일치"
else
  warn "$SRC 없음"
fi
echo

echo "## 스킬 동기화 (vault ↔ ~/.claude/skills)"
SKILL_SRC="$BRAIN/System/skills"
SKILL_DST="$HOME/.claude/skills"
if [ -d "$SKILL_SRC" ]; then
  diff_found=0
  for d in "$SKILL_SRC"/*/; do
    [ -f "$d/SKILL.md" ] || continue
    name=$(basename "$d")
    if [ ! -d "$SKILL_DST/$name" ] || ! diff -rq "$d" "$SKILL_DST/$name" >/dev/null 2>&1; then
      warn "$name: vault와 ~/.claude/skills 불일치 (install-commands.sh 실행 필요)"
      diff_found=1
    fi
  done
  [ "$diff_found" = "0" ] && ok "모든 스킬이 vault와 일치"
else
  info "$SKILL_SRC 없음 (스킬 원본 없음)"
fi
echo

echo "## 위키링크 (vault 루트 기준 전체 경로 — Rules.md 2절 링크 규칙)"
# 짧은 링크([[Decisions]], [[Knowledge/…]] 등)는 프로젝트가 둘 이상이면 어느 파일인지 모호하다.
# 템플릿의 [[Projects/{{project}}/…]] 치환자는 전체 경로라 이 검사에 걸리지 않는다.
if [ -d "$BRAIN/System" ] || [ -d "$BRAIN/Projects" ]; then
  short_links=$(grep -rn --include='*.md' '\[\[\(Decisions\|Handoff\|Overview\|Knowledge/\|Sessions/\)' "$BRAIN/System" "$BRAIN/Projects" 2>/dev/null)
  if [ -z "$short_links" ]; then
    ok "짧은 위키링크 없음 (System, Projects)"
  else
    short_count=$(echo "$short_links" | wc -l | tr -d ' ')
    short_files=$(echo "$short_links" | cut -d: -f1 | sort -u | wc -l | tr -d ' ')
    warn "짧은 위키링크 ${short_count}건 / ${short_files}개 파일 — [[Projects/<이름>/…]] 또는 [[System/…]] 전체 경로로 바꾼다"
    echo "$short_links" | cut -d: -f1 | sort | uniq -c | sort -rn | head -10 | awk '{printf "       %s (%s건)\n", $2, $1}' | sed "s#$BRAIN/##"
  fi
else
  warn "$BRAIN/System 또는 Projects 없음"
fi
echo

echo "## ECC 훅 설정"
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ] && command -v jq >/dev/null 2>&1; then
  disabled=$(jq -r '.env.ECC_DISABLED_HOOKS // empty' "$SETTINGS" 2>/dev/null)
  info "ECC_DISABLED_HOOKS = $disabled"
  case "$disabled" in
    *post:observe:continuous-learning*) warn "존재하지 않는 훅 id(post:observe:continuous-learning)가 남아 있음 — 지워도 무방" ;;
  esac
else
  warn "$SETTINGS를 찾을 수 없음"
fi
