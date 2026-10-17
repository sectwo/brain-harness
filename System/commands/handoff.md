---
description: 세션 로그를 모아 프로젝트 Handoff.md를 갱신하고, L1 지식 승격 후보를 제안한다
---
하네스 규칙은 `~/Brain/System/Rules.md`를 따른다. 대상 프로젝트는 저장소 루트의 `.harness-project`로 찾는다
(vault: `~/Brain/Projects/<프로젝트>/`). 파일이 없으면 멈추고 `/new-project`를 제안한다.
문서별 역할·상한·금지 내용은 Rules 2절과 각 템플릿(`~/Brain/System/Templates/Project/`) 머리말을 따른다.
위키링크는 항상 vault 루트 기준 전체 경로로 쓴다 (`[[Projects/<프로젝트>/Decisions#YYYY-MM-DD — 제목]]`, `[[System/Knowledge/<주제>]]`).

1. 이번 세션의 로그가 `Sessions/`에 없으면 먼저 작성한다.
   파일명: `Sessions/YYYY-MM-DD-<현재 worktree명>-claude.md` (`Sessions/_template.md` 형식, 40줄 이내)
2. 지난 `/handoff`(Handoff.md의 `last_handoff`) 이후 생긴 `Sessions/` 로그를 모두 읽는다. (Codex 로그 포함)
   frontmatter에 `summary:`가 없거나 비어 있는 로그는 한 줄을 채운다(색인 재료). 로그 본문은 고치지 않는다.
3. **L2 갱신** — `Handoff.md`를 템플릿(`Templates/Project/Handoff.md`) 틀대로 **다시 쓴다**. 60줄 이내.
   - **현재 상태**: 지금 동작하는 것·안 되는 것, 저장소 상태 한 줄. 10불릿 이내, 매번 새로 쓴다(누적 금지).
     날짜·커밋 해시·"~했다" 이력·리뷰 이력·수치 상세는 쓰지 않는다 — 세션 로그·Knowledge에 있으니 링크만.
   - **진행 중인 worktree**: 담당 에이전트와 상태
   - **다음 할 일**: 우선순위 순서, 담당 표시. 완료된 항목은 지운다(완료 사실은 세션 로그에 있다).
   - **막힌 점 / 확인 필요**: 사람이 답해야 하는 것만. 답이 나온 것은 지운다.
   - **관련 결정**: 아직 영향 중인 결정 **3개 이내**, 전체 경로 링크. 결정 본문은 옮겨 적지 않는다.
     "기록 후보" 목록 같은 실행 보고는 Handoff가 아니라 6번 보고에 넣는다.
   - 맨 위 `last_handoff` 날짜 갱신
   - 로그 중 이 프로젝트에서만 쓸 지식은 프로젝트 `Knowledge/`에(`Knowledge/_template.md` 틀, `summary:` 필수, 60줄 이내),
     에이전트별 특이점은 `Agents/<Claude|Codex>.md`에 정리한다. `Knowledge/README.md` 표의 설명은 각 문서의 `summary:`와 같게 맞춘다.
4. **L1 승격 후보** — 로그와 프로젝트 Knowledge 중 **다른 프로젝트에도 쓸 만한 것**(도구 설정법, 문제 해결, 공통 규칙 개선)을 골라
   목록으로 보여 주고 사람에게 묻는다. 승인한 것만 `~/Brain/System/Knowledge/`(또는 Rules/Environment)에 올리고,
   L2에는 링크만 남긴다. 승인 없이 L1을 고치지 않는다.
5. 프로젝트 상태가 크게 바뀌었으면 `~/Brain/System/Projects.md`의 해당 행을 갱신한다.
6. 로그에 없는 내용은 지어내지 않는다. 바뀐 내용을 3줄 이내로 요약해 보고한다.
   Handoff에서 뺀 내용이 있으면 "뺀 내용 → 남아 있는 곳"을 이번 세션 로그에 남긴다.

$ARGUMENTS
