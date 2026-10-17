# 브레인 하네스 — 문서 목차

이 저장소는 옵시디언 vault `~/Brain`이다. 이 PC의 모든 프로젝트와 에이전트(Claude Code, Codex)가 따르는
규칙·환경·결정·지식을 담은 **기억의 기준(source of truth)** 이며, 우리는 이 체계 전체를 "브레인 하네스"라고
부른다. 사람의 뇌처럼 계층으로 나뉜다: L1 전역(`System/`) → L2 프로젝트(`Projects/<이름>/`) →
L3 에이전트·세션(`Projects/<이름>/Agents/`, `Sessions/`). 아래 계층은 위를 상속하고 필요한 것만 덧붙이며,
충돌하면 가까운 계층이 우선한다(L3 > L2 > L1). 사람과 에이전트가 함께 설계해 나가는 구조라 계층 수와
구성은 고정이 아니다.

GitHub에서 처음 보는 사람은 이 페이지에서 시작하면 된다. 앞으로 사람이 읽는 정리 문서(가이드·설계안 등)는
이 `docs/` 아래에 둔다. 규칙·결정·지식의 원본은 그대로 `System/`·`Projects/`에 있고, `docs/`는 목차와
정리 문서만 담는다.

## 폴더 지도
| 폴더 | 계층 | 내용 |
|---|---|---|
| [`System/`](../System/) | L1 | 공통 규칙, 환경 설정, 전역 결정, 프로젝트 목록, 공통 지식, 스크립트, 명령 원본, 구성도 |
| [`Projects/`](../Projects/) | L2 · L3 | 프로젝트별 요구사항(Overview)·Handoff·결정·지식 + 에이전트별 특이점·세션 로그 |
| [`docs/`](./) | - | 이 목차와 사람이 읽는 정리 문서 |

## 주요 문서
**L1 전역 (`System/`)**
- [Rules.md](../System/Rules.md) — 공통 규칙. 하네스 트리, 기억 저장소, 작업 워크플로우, 교차 리뷰, 모델 선택, 도구 역할
- [Environment.md](../System/Environment.md) — 시스템 구성과 환경 설정(도구, 경로, 포트, 설정 파일 위치)
- [Decisions.md](../System/Decisions.md) — 전역 결정 기록
- [Projects.md](../System/Projects.md) — 프로젝트 목록과 상태
- [Reviews.md](../System/Reviews.md) — 브레인 정기 점검 주기와 기록
- [Knowledge/README.md](../System/Knowledge/README.md) — 프로젝트를 넘어 쓰는 지식 목록
- [Templates/Project/](../System/Templates/Project/) — 새 프로젝트용 vault 틀. 기록 템플릿 4종(세션 로그 `Sessions/_template.md`,
  `Handoff.md`, `Decisions.md` 머리말+항목 틀, `Knowledge/_template.md`)과 각 문서의 역할·길이 상한
- [diagrams/README.md](../System/diagrams/README.md) — 브레인 구성도(archify HTML + 원본 JSON), 보는 법·갱신법
- [commands/](../System/commands/) — 공통 명령 원본(`/handoff`, `/cross-review`, `/new-project`, `/brain-sync`)

**정리 문서 (`docs/`)**
- [stage2-record-structure.md](./stage2-record-structure.md) — 로드맵 2단계 설계안: 기록 구조 단순화(문서별 역할·상한, 템플릿 4종,
  세션 시작 색인, 링크 규칙, 기존 문서 정리 계획)
- [guide.md](./guide.md) — 사용자 가이드: 최소조건, 빠른 시작, 하루 작업 흐름, 명령·스킬, 기록 규칙, 자동 점검, 문제 해결
- [setup.md](./setup.md) — 설치·설정 가이드(`bootstrap.sh` 사용법)

**L2 프로젝트 — intratnm 홈페이지 (`Projects/intratnm/`)**
- [Handoff.md](../Projects/intratnm/Handoff.md) — 현재 상태와 다음 할 일 (`/handoff`로만 갱신)
- [Overview.md](../Projects/intratnm/Overview.md) — 요구사항, 페이지 구성, 기술 스택 (사람이 작성하는 기준 문서)
