---
description: brain-harness(~/Brain) 저장소를 사람이 원할 때만 수동으로 동기화한다 (SessionStart 자동 pull 없음)
---
`~/Brain/System/Rules.md` 2절(기억 저장소)을 따른다. **SessionStart에서 자동으로 pull하지 않는다** —
이 명령을 실행했을 때만 동기화한다. push는 이 명령이 하지 않는다: push는 항상 사람이 별도로 승인한 뒤에만 한다.

1. **상태 확인**: `git -C ~/Brain fetch origin`한 뒤
   `git -C ~/Brain rev-list --left-right --count origin/main...main`로 ahead/behind를 구한다.
   `git -C ~/Brain status --short`로 커밋 안 된 변경도 함께 보여준다.
2. **behind > 0** (원격에 새 커밋이 있음): 내용을 `git -C ~/Brain log --oneline main..origin/main`으로 보여주고
   사람에게 pull 여부를 묻는다. 승인하면 `git -C ~/Brain pull --ff-only origin main`만 쓴다
   (merge/rebase로 히스토리를 바꾸지 않는다. fast-forward가 안 되면 멈추고 사람에게 알린다).
3. **pull 이후 명령 동기화**: pull로 `System/commands/*.md`가 바뀌었으면
   `bash ~/Brain/System/scripts/install-commands.sh`를 실행해 `~/.claude/commands/`에 반영한다.
4. **ahead > 0** (로컬에 push 안 한 커밋이 있음): 개수만 알려주고 멈춘다. push는 이 명령의 범위가 아니다 —
   사람이 명시적으로 "push해줘"라고 하면 그때 `git -C ~/Brain push origin main`을 실행한다.
5. 결과(ahead/behind, pull 여부, 명령 동기화 여부)를 3줄 이내로 요약해 보고한다.

$ARGUMENTS
