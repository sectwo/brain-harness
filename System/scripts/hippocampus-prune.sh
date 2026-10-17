#!/bin/sh
# 해마(claude-mem) 소멸: N일(기본 30일)이 지난 일화를 지운다. (실험 트랙 스크립트, 2026-10-18 시작 — 쓰면서 보완)
# claude-mem에는 자체 만료가 없어서 만들었다. 기준 → [[Projects/brain-harness/Decisions#2026-10-18 — 실험: claude-mem을 해마(임시 일화 기억)로 — brain-harness만, 2주]]
#
# 일화 단위(sdk_sessions)로 지운다. foreign_keys가 켜져 있으면 관찰·요약·중복 후보가 CASCADE로,
# 검색 색인(FTS)은 삭제 트리거로 함께 지워진다. 진행 중(active) 세션은 남긴다.
#
# 사용: sh hippocampus-prune.sh [--days N] [--apply]
#   기본은 미리보기(지울 개수만 출력). --apply면 DB를 백업한 뒤 지운다.

DB="${CLAUDE_MEM_DATA_DIR:-$HOME/.claude-mem}/claude-mem.db"
BACKUP_DIR="$HOME/.brain-backups/hippocampus"
DAYS=30
APPLY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --days) DAYS="$2"; shift ;;
    --apply) APPLY=1 ;;
    *) echo "알 수 없는 옵션: $1" >&2; exit 1 ;;
  esac
  shift
done
case "$DAYS" in ''|*[!0-9]*) echo "--days는 숫자여야 한다: $DAYS" >&2; exit 1 ;; esac

command -v sqlite3 >/dev/null 2>&1 || { echo "sqlite3 없음" >&2; exit 1; }
[ -f "$DB" ] || { echo "DB 없음: $DB (아직 기록 전이면 정상)"; exit 0; }

cutoff=$(( ($(date +%s) - DAYS * 86400) * 1000 ))   # created/started_at_epoch는 ms
where="started_at_epoch < $cutoff AND status != 'active'"

q() { sqlite3 -cmd ".timeout 5000" "$DB" "$1"; }
sessions=$(q "SELECT COUNT(*) FROM sdk_sessions WHERE $where;")
obs=$(q "SELECT COUNT(*) FROM observations WHERE memory_session_id IN (SELECT memory_session_id FROM sdk_sessions WHERE $where);")
total=$(q "SELECT COUNT(*) FROM observations;")
echo "해마: ${DAYS}일 지난 일화 ${sessions}개 (관찰 ${obs}개 / 전체 ${total}개)"

[ "$APPLY" = "1" ] || { echo "미리보기만 했다. 지우려면 --apply"; exit 0; }
[ "$sessions" = "0" ] && exit 0

mkdir -p "$BACKUP_DIR"
backup="$BACKUP_DIR/claude-mem-$(date +%Y%m%d-%H%M%S).db"
q ".backup '$backup'" || { echo "백업 실패 — 지우지 않았다" >&2; exit 1; }
q "PRAGMA foreign_keys = ON; DELETE FROM sdk_sessions WHERE $where;" || { echo "삭제 실패 (백업: $backup)" >&2; exit 1; }
echo "지웠다. 백업: $backup (남은 관찰 $(q 'SELECT COUNT(*) FROM observations;')개)"
# 백업은 최근 3개만 둔다
ls -t "$BACKUP_DIR"/claude-mem-*.db 2>/dev/null | tail -n +4 | while IFS= read -r old; do rm -f "$old"; done
