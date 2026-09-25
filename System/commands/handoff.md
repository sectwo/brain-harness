---
description: 세션 로그를 모아 프로젝트 Handoff.md를 갱신하고, L1 지식 승격 후보를 제안한다
---
하네스 규칙은 `~/Brain/System/Rules.md`를 따른다. 대상 프로젝트는 저장소 루트의 `.harness-project`로 찾는다
(vault: `~/Brain/Projects/<프로젝트>/`). 파일이 없으면 멈추고 `/new-project`를 제안한다.

1. 이번 세션의 로그가 `Sessions/`에 없으면 먼저 작성한다.
   파일명: `Sessions/YYYY-MM-DD-<현재 worktree명>-claude.md` (`Sessions/_template.md` 형식)
2. 지난 `/handoff`(Handoff.md의 `last_handoff`) 이후 생긴 `Sessions/` 로그를 모두 읽는다. (Codex 로그 포함)
3. **L2 갱신** — `Handoff.md`
   - **현재 상태**: 지금 동작하는 것, 진행 중인 worktree와 담당 에이전트
   - **다음 할 일**: 우선순위 순서, 담당 표시
   - **막힌 점 / 확인 필요**: 사람이 답해야 하는 질문
   - **최근 결정**: Decisions.md의 새 항목 링크 ([[Decisions]])
   - 맨 위 `last_handoff` 날짜 갱신
   - 로그 중 이 프로젝트에서만 쓸 지식은 프로젝트 `Knowledge/`에, 에이전트별 특이점은 `Agents/<Claude|Codex>.md`에 정리한다.
4. **L1 승격 후보** — 로그와 프로젝트 Knowledge 중 **다른 프로젝트에도 쓸 만한 것**(도구 설정법, 문제 해결, 공통 규칙 개선)을 골라
   목록으로 보여 주고 사람에게 묻는다. 승인한 것만 `~/Brain/System/Knowledge/`(또는 Rules/Environment)에 올리고,
   L2에는 링크만 남긴다. 승인 없이 L1을 고치지 않는다.
5. 프로젝트 상태가 크게 바뀌었으면 `~/Brain/System/Projects.md`의 해당 행을 갱신한다.
6. 로그에 없는 내용은 지어내지 않는다. 바뀐 내용을 3줄 이내로 요약해 보고한다.

$ARGUMENTS
