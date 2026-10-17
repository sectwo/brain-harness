---
project: brain-harness
tags: [brain-harness, decisions]
---
# Decisions — brain-harness

> 이 프로젝트의 결정. 모든 프로젝트에 영향을 주는 결정은 [[System/Decisions]]에 쓴다.
> 새 결정은 맨 아래에 추가한다. 형식: 날짜 — 제목 / 결정 / 이유 / 대안

## 2026-10-17 — 브레인 하네스를 별도 L2 프로젝트로 분리
- **결정**: 브레인 하네스(vault `~/Brain` 자체) 작업을 intratnm에서 떼어 L2 프로젝트 `brain-harness`로 둔다.
  vault 루트에 `.harness-project`·`CLAUDE.md`·`AGENTS.md`를 두어 저장소를 이 프로젝트에 연결하고,
  `Projects/brain-harness/`(Overview=로드맵, Decisions, Handoff, Sessions)에 작업 기록을 쌓는다.
  결정 기록 위치는 둘로 나눈다 — **규칙·설정 자체를 바꾸는 결정**(Rules, Environment, `~/.claude`, `~/.codex`,
  스크립트·명령)은 [[System/Decisions]]에, **로드맵 순서·진행 방식·이 프로젝트 안에서의 선택**은 이 파일에.
- **이유**: 사용자 요청. intratnm은 하네스를 통해 진행한 첫 프로젝트일 뿐인데, 하네스 설계·로드맵 작업이
  intratnm 세션 로그와 Handoff에 섞여 두 프로젝트의 맥락을 함께 읽어야 했다. 전역 결정은 이미 `System/Decisions`에
  쓰고 있었으므로, 그 원칙은 유지하고 작업 기록만 분리한다.
- **대안**: `System/` 아래에 하네스 세션 로그를 두기 → L1(규칙·지식)이 작업 기록으로 비대해져 기각.
  intratnm에 계속 기록 → "프로젝트마다 vault 폴더 하나" 원칙에 어긋나 기각.

## 2026-10-17 — 로드맵 2단계 상세 설계는 Fable 하위 에이전트로
- **결정**: 로드맵 2단계(기록 구조 단순화)의 상세 설계는 메인 세션(Opus 5.5)이 Agent 도구 `model: fable`로
  Fable 하위 에이전트에 맡긴다 (사용자 선택 A). 설계안은 사람 확인 후 적용한다.
- **이유**: Rules 5절 표대로 "상세설계, 정말 중요한 설계"는 Fable 담당이고, 쓰기 전에 사람에게 묻는다.
  메인 세션을 바꾸지 않아 지금 맥락을 그대로 쓸 수 있다.
- **대안**: 메인 세션을 `/model`로 Fable(Max)로 전환 → 세션 전체 비용이 커져 보류. Opus로 설계 → 기록 구조는 이후
  모든 세션이 따르는 틀이라 정확성이 중요해 기각.
