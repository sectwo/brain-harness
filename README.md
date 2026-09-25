# 브레인(Brain) 하네스

`~/Brain`은 이 PC에서 Claude Code와 Codex가 함께 쓰는 옵시디언(Obsidian) vault다. 사람과 에이전트가
같이 설계해 나가는 하네스 전체를 우리는 **브레인(Brain) 하네스**라고 부른다. 사람의 뇌처럼 계층으로
나뉘고, 언제든 바뀌고 넓어질 수 있다.

## 왜 옵시디언인가 — 시냅스 비유

여기 있는 노트 하나하나(`Overview.md`, `Decisions.md`, `Handoff.md`, `Rules.md`, `Sessions/` 로그 등)는
뉴런에 해당한다. 그리고 노트 안에서 다른 노트를 가리키는 `[[위키링크]]`가 시냅스 역할을 한다 —
예를 들어 프로젝트 `Overview.md`의 기술 스택 항목이 `[[Decisions#...]]`로 그 결정의 이유를 가리키고,
세션 로그가 다시 `Decisions`를 가리키는 식이다. 기억(노트)들이 따로따로 존재하는 게 아니라 서로
연결되어야 다음에 필요할 때 맥락을 잃지 않고 이어갈 수 있기 때문에, 이 연결 구조 자체가 핵심이다.
옵시디언의 그래프 뷰를 열면 이 연결이 실제로 시각화된다.

기억의 기준(source of truth)은 항상 이 옵시디언 vault다. ECC·Headroom 같은 다른 도구의 기억과 다르면
여기 내용이 우선한다.

## 하네스 트리 구조

하네스는 트리 구조이고, 아래 계층은 위를 상속하고 필요한 것만 덧붙이거나 덮어쓴다. 충돌하면 가까운
계층이 우선한다 (L3 > L2 > L1).

| 계층 | 위치 | 내용 |
|---|---|---|
| **L1** PC 전체 | `System/` | 시스템 구성, 환경 설정, 공통 규칙, 공통 지식 |
| **L2** 프로젝트 | `Projects/<이름>/` + 저장소 `AGENTS.md` | 프로젝트 고유 규칙·지식 |
| **L3** 에이전트·세션 | `Projects/<이름>/Agents/`, `Sessions/` | 에이전트별 특이점, 세션 작업 로그 |

자세한 규칙은 [[System/Rules]]에 있다. Claude Code는 `~/.claude/CLAUDE.md`를 통해, Codex는
`~/.codex/AGENTS.md`와 각 프로젝트 `AGENTS.md`를 통해 이 규칙을 읽는다.

## 폴더 구조

- **`System/`** — L1 공통 규칙과 지식
  - `Rules.md` — 최상위 규칙 (이 하네스 전체가 따르는 기준)
  - `Environment.md` — 시스템 구성과 환경 설정 (도구, 경로, 포트, 설정 파일 위치)
  - `Decisions.md` — 전역 결정 기록
  - `Projects.md` — 프로젝트 목록과 상태 (트리 전체 지도)
  - `Reviews.md` — 브레인 정기 점검 주기와 기록
  - `Knowledge/` — 프로젝트를 넘어 쓰는 지식
  - `Templates/Project/` — 새 프로젝트용 vault 틀 (`/new-project`가 사용)
  - `scripts/`, `commands/` — 공통 훅·상태줄·점검 스크립트, 공통 명령 원본
- **`Projects/<이름>/`** — 프로젝트별 vault (L2 + L3)
  - `Overview.md`, `Decisions.md`, `Handoff.md`, `Knowledge/` (L2)
  - `Agents/Claude.md`, `Agents/Codex.md`, `Sessions/` (L3)

## 세션이 시작할 때 읽는 순서

1. 세션 시작 맥락 — Claude Code는 SessionStart 훅이 자동으로 넣고, Codex는
   `sh ~/Brain/System/scripts/session-context.sh`를 직접 실행한다. (L1 요약 + 프로젝트 Handoff 이후
   세션 로그 + 현재 worktree 상태가 나온다.)
2. 프로젝트 `Handoff.md`, `Overview.md`. Handoff와 최근 세션 로그가 다르면 더 최근 로그를 따른다.
3. 설계에 영향을 주는 작업이면 해당 계층의 `Decisions.md`도 읽는다.

## 새 프로젝트 시작하기

Claude Code에서 `/new-project` 명령으로 시작한다. `System/Templates/Project/` 템플릿을 바탕으로
새 프로젝트의 L2 vault 구조(Overview/Decisions/Handoff/Knowledge)를 만들어 준다.

## 주요 문서

- [[System/Rules]] — 최상위 규칙 (하네스 트리, 작업 워크플로우, 교차 리뷰, 모델 선택, 공통 코드 규칙)
- [[System/Environment]] — 도구·경로·포트 등 환경 설정
- [[System/Decisions]] — 전역 결정 기록
- [[System/Projects]] — 프로젝트 목록과 상태
- [[System/Reviews]] — 정기 점검 주기와 기록

## 원격 저장소

`brain-harness` (private, `github.com/sectwo/brain-harness`). 세션 시작 시 자동으로 pull하지 않는다 —
동기화는 사람이 `/brain-sync`를 실행했을 때만(fast-forward만 허용) 한다. 커밋은 의미 있는 단위로
자유롭게 하되, **push는 매번 사람이 명시적으로 승인한 뒤에만** 한다.
