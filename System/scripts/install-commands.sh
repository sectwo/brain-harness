#!/bin/sh
# ~/Brain/System/commands/*.md (원본)를 ~/.claude/commands/로, ~/Brain/System/skills/<이름>/ 을
# ~/.claude/skills/<이름>/ 으로 복사한다 (Claude Code가 실제로 읽는 곳).
# 심링크가 아니라 복사인 이유: Claude Code가 심링크된 command 파일을 읽는지 검증하지 않았다.
# 복사본이 오래돼도 안전하도록, 이 스크립트는 pull 뒤(/brain-sync)나 원본을 고친 뒤 사람이 직접 실행한다.

SRC="$HOME/Brain/System/commands"
DST="$HOME/.claude/commands"

[ -d "$SRC" ] || { echo "원본 디렉터리 없음: $SRC" >&2; exit 1; }
mkdir -p "$DST"

for f in "$SRC"/*.md; do
  name=$(basename "$f")
  cp "$f" "$DST/$name"
  echo "설치: $name"
done

# 스킬 (폴더 단위)
SKILL_SRC="$HOME/Brain/System/skills"
SKILL_DST="$HOME/.claude/skills"
if [ -d "$SKILL_SRC" ]; then
  mkdir -p "$SKILL_DST"
  for d in "$SKILL_SRC"/*/; do
    [ -f "$d/SKILL.md" ] || continue
    name=$(basename "$d")
    mkdir -p "$SKILL_DST/$name"
    cp -R "$d". "$SKILL_DST/$name/"
    echo "설치(스킬): $name"
  done
fi
