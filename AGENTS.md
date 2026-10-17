# brain-harness — 프로젝트 규칙 (L2)

**L1 공통 규칙 `~/Brain/System/Rules.md`를 먼저 읽고 따른다. 이 파일은 프로젝트 고유 규칙만 담는다.**
L1과 충돌하면 이 파일이 우선한다. Claude Code는 `CLAUDE.md` → `@AGENTS.md`로, Codex는 이 파일을 직접 읽는다.

## 프로젝트
- 목적: 브레인 하네스(이 vault `~/Brain`과 `~/.claude`·`~/.codex` 설정) 자체를 설계하고 개선한다.
  intratnm 같은 다른 프로젝트는 이 하네스를 **통해** 진행하는 프로젝트이고, 이 프로젝트는 하네스를 **만드는** 프로젝트다.
- 저장소가 vault 자체다. `System/`은 하네스의 내용(L1), `Projects/brain-harness/`는 하네스를 만드는 작업 기록(L2·L3).
- vault: `~/Brain/Projects/brain-harness/` (루트 `.harness-project`로 연결)
  - L2: `Overview.md`(로드맵), `Decisions.md`, `Handoff.md`, `Knowledge/`
  - L3: `Agents/Claude.md`, `Agents/Codex.md`, `Sessions/`

## 고유 규칙
- `System/`, `~/.claude`, `~/.codex`를 바꾸는 것은 L1 변경이다. L1 절차를 따른다:
  계획 → 사람 확인 → 백업(`~/.brain-backups/YYYY-MM-DD/`) → 변경 → `System/Decisions.md`에 기록.
- `git push`는 매번 사람 승인 뒤에만 한다 (로컬 커밋은 자유).
- 기록 위치
  - 하네스 작업 기록(세션 로그, Handoff, 로드맵 순서·진행 방식 결정) → `Projects/brain-harness/`
  - 규칙·설정 자체를 바꾸는 결정 → `System/Decisions.md` (모든 프로젝트에 영향을 주기 때문)
- 다른 프로젝트의 vault(`Projects/<other>/`)는 그 프로젝트 작업이 아니면 건드리지 않는다.
  하네스 변경으로 다른 프로젝트 문서를 고쳐야 하면 계획에 명시하고 확인을 받는다.

## 추가 품질 게이트
L1 기본 게이트에 더해, `System/scripts/`·훅·상태줄 등 스크립트를 바꾸면 아래를 통과해야 한다.
- `sh -n <파일>` 문법 검사
- `sh ~/Brain/System/scripts/doctor.sh` 실행, 오류 없음
