#!/bin/sh
# 새 Mac(또는 재설치한 PC)에서 브레인 하네스를 한 번에 설정한다. 멱등: 여러 번 실행해도 같은 결과.
# 전제: 이 private 저장소를 이미 $HOME/Brain에 clone했다 (규칙·명령이 ~/Brain 경로를 전제하므로 위치는 고정).
#
# 옵션:
#   --check   아무것도 바꾸지 않고 최소조건 표와 각 단계의 현재 상태(적용됨/필요)만 보여 준다.
#
# 하는 일: 백업 → ~/.claude/CLAUDE.md에 Rules 연결 → ~/.codex/AGENTS.md 안내(Codex가 있을 때)
#         → ~/.claude/settings.json에 하네스 조각 병합 → install-commands.sh → doctor.sh
# 안 하는 일: ECC·Headroom·Orca·Codex 설치/설정 (docs/setup.md의 선택 항목 참고)

BRAIN="${HARNESS_BRAIN:-$HOME/Brain}"
SCRIPTS="$BRAIN/System/scripts"
FRAGMENT="$BRAIN/System/Templates/claude-settings.harness.json"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
SETTINGS="$CLAUDE_DIR/settings.json"
CODEX_DIR="$HOME/.codex"
CODEX_MD="$CODEX_DIR/AGENTS.md"
BACKUP="$HOME/.brain-backups/$(date +%Y-%m-%d)/bootstrap"
RULES_LINE='@~/Brain/System/Rules.md'

CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

ok()   { echo "  OK   $1"; }
warn() { echo "  WARN $1"; }
info() { echo "  --   $1"; }
need() { echo "  필요 $1"; }
die()  { echo "중단: $1" >&2; exit 1; }

# --- 저장소 위치 확인 ---
if [ ! -f "$BRAIN/System/Rules.md" ]; then
  echo "브레인 저장소가 $BRAIN 에 없다." >&2
  echo "규칙과 명령이 ~/Brain 경로를 전제하므로 위치는 ~/Brain으로 고정이다. 먼저 clone한다:" >&2
  echo "  git clone <brain-harness 저장소 URL> ~/Brain" >&2
  exit 1
fi

has() { command -v "$1" >/dev/null 2>&1; }

# --- 상태 판정 함수 (--check와 본 실행이 같이 쓴다) ---
claude_md_done() { [ -f "$CLAUDE_MD" ] && grep -qF "$RULES_LINE" "$CLAUDE_MD"; }
codex_present()  { [ -d "$CODEX_DIR" ] || has codex; }
codex_md_done()  { [ -f "$CODEX_MD" ] && grep -qF "System/Rules.md" "$CODEX_MD"; }

# settings.json에 조각의 훅 command가 전부 있고 statusLine·additionalDirectories도 있으면 적용됨
settings_done() {
  [ -f "$SETTINGS" ] && has jq || return 1
  jq -e --slurpfile f "$FRAGMENT" --arg b "$BRAIN" '
    . as $s
    | ($f[0].hooks | to_entries | all(.key as $k | .value[] | .hooks[].command as $c
        | ($s.hooks[$k] // []) | any(.[].hooks[]?; .command == $c)))
      and (.statusLine.command == $f[0].statusLine.command)
      and ((.permissions.additionalDirectories // []) | index($b) != null)
  ' "$SETTINGS" >/dev/null 2>&1
}

# --- 최소조건 ---
print_requirements() {
  echo "## 최소조건"
  echo "  구분  항목       상태  이유"
  req_row() { # <구분> <항목> <통과 0/1> <이유>
    if [ "$3" = "0" ]; then st="있음"; else st="없음"; fi
    printf '  %-4s  %-9s  %-4s  %s\n' "$1" "$2" "$st" "$4"
  }
  [ "$(uname -s)" = "Darwin" ]; req_row 필수 macOS $? "스크립트가 BSD date -v, sed -i '' 사용"
  has git;    req_row 필수 git $? "저장소 clone·커밋"
  has jq;     req_row 필수 jq $? "훅 4개가 jq 없으면 조용히 꺼진다"
  has claude; req_row 필수 claude $? "Claude Code"
  has gh;     req_row 권장 gh $? "push·PR"
  if [ -d "/Applications/Obsidian.app" ] || [ -d "$HOME/Applications/Obsidian.app" ]; then o=0; else o=1; fi
  req_row 권장 Obsidian $o "그래프 뷰 (vault는 일반 마크다운이라 없어도 동작)"
  has codex;     req_row 선택 Codex $? "교차 리뷰"
  if [ -d "/Applications/Orca.app" ] || [ -d "$HOME/Applications/Orca.app" ]; then o=0; else o=1; fi
  req_row 선택 Orca $o "worktree 병렬"
  has headroom;  req_row 선택 Headroom $? "토큰 압축 프록시"
  if [ -f "$CLAUDE_DIR/plugins/installed_plugins.json" ] && grep -q '"ecc@' "$CLAUDE_DIR/plugins/installed_plugins.json" 2>/dev/null; then e=0; else e=1; fi
  req_row 선택 ECC $e "플러그인 (docs/setup.md 참고)"
  has sqlite3;   req_row 선택 sqlite3 $? "일부 점검·실험에서 사용"
  echo
}

# 필수 4개가 모두 있으면 0
required_ok() {
  [ "$(uname -s)" = "Darwin" ] && has git && has jq && has claude
}

print_requirements

# --- --check: 상태만 보고 끝 ---
if [ "$CHECK" = "1" ]; then
  echo "## 단계별 현재 상태 (--check: 아무것도 바꾸지 않음)"
  required_ok && ok "최소조건: 필수 도구 모두 있음" || need "최소조건: 필수 도구가 빠졌다 (위 표)"
  claude_md_done && ok "~/.claude/CLAUDE.md에 Rules 연결됨" || need "~/.claude/CLAUDE.md에 Rules 연결 추가"
  if codex_present; then
    codex_md_done && ok "~/.codex/AGENTS.md에 Rules 안내 있음" || need "~/.codex/AGENTS.md에 Rules 안내 추가"
  else
    info "Codex 없음 — ~/.codex/AGENTS.md 단계 건너뜀"
  fi
  if has jq; then
    settings_done && ok "~/.claude/settings.json에 하네스 조각 병합됨" || need "~/.claude/settings.json에 하네스 조각 병합"
  else
    need "~/.claude/settings.json 병합 (jq 필요)"
  fi
  info "install-commands.sh, doctor.sh는 본 실행 때 돌린다 (doctor는 지금 직접 실행해도 된다)"
  exit 0
fi

# --- 본 실행 ---
echo "## 설정 적용"

# ① 최소조건
required_ok || die "필수 도구가 없다 (위 표의 '필수' 줄). 설치 후 다시 실행한다."
ok "① 최소조건 통과"

# ② 백업: 바꿀 파일만, 있을 때만
mkdir -p "$BACKUP" || die "백업 폴더를 만들 수 없음: $BACKUP"
for f in "$CLAUDE_MD" "$SETTINGS" "$CODEX_MD"; do
  [ -f "$f" ] && cp -pn "$f" "$BACKUP/$(basename "$(dirname "$f")")-$(basename "$f")"
done
ok "② 백업: $BACKUP"

# ③ ~/.claude/CLAUDE.md
mkdir -p "$CLAUDE_DIR"
if claude_md_done; then
  ok "③ ~/.claude/CLAUDE.md: 이미 Rules 연결됨 (그대로)"
else
  {
    [ -s "$CLAUDE_MD" ] && echo
    echo "# Level 1 — 이 PC의 공통 하네스"
    echo "모든 프로젝트에 적용되는 최상위 규칙. 프로젝트 규칙(저장소 AGENTS.md / CLAUDE.md)이 있으면 그것이 우선한다."
    echo "원본은 옵시디언 vault에 있다. 규칙을 바꿀 때는 원본만 고친다."
    echo
    echo "$RULES_LINE"
  } >> "$CLAUDE_MD"
  ok "③ ~/.claude/CLAUDE.md: Rules 연결 추가"
fi

# ④ ~/.codex/AGENTS.md (Codex가 있을 때만)
if codex_present; then
  if codex_md_done; then
    ok "④ ~/.codex/AGENTS.md: 이미 Rules 안내 있음 (그대로)"
  else
    mkdir -p "$CODEX_DIR"
    {
      [ -s "$CODEX_MD" ] && echo
      echo "# Level 1 — 이 PC의 공통 하네스 (Codex)"
      echo "작업을 시작하기 전에 아래 두 가지를 먼저 한다. 프로젝트 AGENTS.md가 있으면 그것이 우선한다."
      echo
      echo "1. 공통 규칙 \`$BRAIN/System/Rules.md\`를 읽고 따른다. (원본. 이 파일은 연결만 한다)"
      echo "2. \`sh $BRAIN/System/scripts/session-context.sh --handoff\`를 실행해 이어서 할 맥락과 Handoff를 읽는다."
      echo
      echo "- L1(\`~/Brain/System\`)은 직접 고치지 않는다. 바꿀 내용은 세션 로그 \"다음 할 일\"에 제안으로 남긴다."
      echo "- 모델·추론 강도를 스스로 고르거나 바꿀 때는 무엇을 왜 골랐는지 한 줄로 알린다."
    } >> "$CODEX_MD"
    ok "④ ~/.codex/AGENTS.md: Rules 안내 추가"
  fi
else
  info "④ Codex 없음 — 건너뜀"
fi

# ⑤ settings.json 병합: 기존 값은 그대로 두고 조각만 더한다.
#   - 객체는 재귀 병합, statusLine은 기존 값이 있으면 유지, 훅은 같은 command가 이미 있으면 추가 안 함
#   - additionalDirectories는 합집합
[ -f "$FRAGMENT" ] || die "조각 파일 없음: $FRAGMENT"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
jq empty "$SETTINGS" >/dev/null 2>&1 || die "$SETTINGS가 올바른 JSON이 아니다 (백업: $BACKUP). 직접 고친 뒤 다시 실행한다."
TMP="$SETTINGS.bootstrap.$$"
if jq --slurpfile f "$FRAGMENT" --arg b "$BRAIN" '
    ($f[0] | .permissions.additionalDirectories = [$b]) as $frag
    | .statusLine = (.statusLine // $frag.statusLine)
    | .permissions.additionalDirectories =
        ((.permissions.additionalDirectories // []) + $frag.permissions.additionalDirectories | unique)
    | reduce ($frag.hooks | to_entries[]) as $e (.;
        reduce $e.value[] as $entry (.;
          if ((.hooks[$e.key] // []) | any(.[].hooks[]?; .command == $entry.hooks[0].command))
          then .
          else .hooks[$e.key] = ((.hooks[$e.key] // []) + [$entry])
          end))
  ' "$SETTINGS" > "$TMP"; then
  mv "$TMP" "$SETTINGS"
  ok "⑤ ~/.claude/settings.json: 하네스 조각 병합 (statusLine·훅 3종·additionalDirectories)"
else
  rm -f "$TMP"
  die "settings.json 병합 실패 — 원본은 그대로, 백업: $BACKUP"
fi

# ⑥ 명령·스킬 설치
if sh "$SCRIPTS/install-commands.sh" >/dev/null; then
  ok "⑥ install-commands.sh: 명령·스킬 설치"
else
  warn "⑥ install-commands.sh 실패"
fi

# ⑦ 점검
echo "  -- ⑦ doctor.sh 결과:"
sh "$SCRIPTS/doctor.sh" --quiet | sed 's/^/     /'
echo
echo "끝. Claude Code를 완전히 종료했다가 다시 시작한다. 되돌리기: $BACKUP 의 파일을 원래 위치로 복사."
