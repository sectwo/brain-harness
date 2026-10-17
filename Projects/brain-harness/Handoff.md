---
project: brain-harness
last_handoff: 2026-10-17
tags: [brain-harness, handoff]
---
# Handoff — brain-harness

> 새 세션은 이 노트부터 읽는다. `/handoff`로만 갱신한다.

## 현재 상태
- 2026-10-17: 프로젝트 생성. 브레인 하네스(vault 자체)를 intratnm과 분리된 L2 프로젝트로 둔다
  (→ [[Projects/brain-harness/Decisions]] 2026-10-17, [[System/Decisions]] 2026-10-17 분리 결정).
- 2026-10-17: 로드맵 1단계(비용·마찰 줄이기) 완료 — GateGuard 예외, 모델 배치, 세션 길이, Headroom 지식.
  구성도(`System/diagrams/`)와 `docs/` 목차도 같은 날 추가. 기록은 [[Projects/brain-harness/Sessions/2026-10-17-main-claude]].
- 로드맵 전체는 [[Projects/brain-harness/Overview]].

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| main | Claude | 프로젝트 분리, 로드맵 1단계 기록 | 기록 완료 |

## 다음 할 일
1. [ ] 로드맵 2단계 — 기록 구조 단순화. 상세 설계는 Fable 하위 에이전트로 (→ [[Projects/brain-harness/Decisions]] 2026-10-17)
2. [ ] (사람) Codex `~/.codex/config.toml` `writable_roots`에 `/Users/isaac/Brain/Projects/brain-harness` 추가 여부 확인
   (현재는 intratnm 경로만 있음. L1 변경이라 확인 후 백업·수정)
3. [ ] 1단계 효과 측정 — 다음 기능 하나 작업 후 `costs.jsonl` 세션별 최대값으로 GateGuard 예외·모델 배치 효과 비교
4. [ ] (사람) vault 커밋 push 여부 확인

## 막힌 점 / 확인 필요
- 프로젝트가 2개가 되면서 `[[Projects/brain-harness/Decisions]]`·`[[Projects/brain-harness/Handoff]]` 같은 짧은 링크가 어느 프로젝트를 가리키는지 모호해졌다.
  Obsidian은 파일명으로 찾으므로 같은 이름이 둘이면 링크가 엉킬 수 있다. 2단계(기록 구조 단순화)에서 다룬다.

## 관련 결정
- 2026-10-17 — 브레인 하네스를 별도 L2 프로젝트로 분리 ([[Projects/brain-harness/Decisions]], [[System/Decisions]])
- 2026-10-17 — 로드맵 2단계 상세 설계는 Fable 하위 에이전트로 ([[Projects/brain-harness/Decisions]])
