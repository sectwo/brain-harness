---
project: intratnm
tags: [intratnm, decisions]
---
# Decisions — intratnm

> 새 결정은 맨 아래에 추가한다. 형식: 날짜 — 제목 / 결정 / 이유 / 대안

## 2026-09-25 — 하네스 구성
- **결정**: Orca(worktree) + Claude Code·Codex + ECC(하네스) + Headroom(프록시 압축) + 옵시디언(기억)
- **이유**: 두 에이전트를 병렬로 쓰면서 세션이 바뀌어도 맥락을 잃지 않기 위함
- **규칙**: 공통 규칙은 `AGENTS.md` 하나로 관리. 기억의 기준은 옵시디언. Headroom 메모리는 사용 안 함
- **대안**: Headroom/ECC 자체 메모리 사용 → 기억이 여러 곳으로 나뉘어 제외

## 2026-09-25 — 기억 파일 쓰기 규칙
- **결정**: 각 에이전트는 `Sessions/`에 자기 로그만 쓰고, `Handoff.md`는 `/handoff`로만 갱신
- **이유**: 여러 worktree의 에이전트가 동시에 같은 노트를 덮어쓰는 것을 막기 위함

## 2026-09-25 — 세션 시작 시 맥락 자동 주입
- **결정**: `.claude/hooks/session-context.sh`를 Claude Code SessionStart 훅(startup·resume·clear·compact)으로 실행해, 마지막 `/handoff` 이후 세션 로그(최대 5개)와 현재 worktree 상태를 자동으로 불러온다. Codex는 AGENTS.md에 따라 같은 스크립트를 직접 실행한다.
- **이유**: Handoff.md는 `/handoff` 때만 갱신되므로, 그 사이에 재시작하거나 다른 worktree·에이전트로 넘어가면 최근 작업이 빠진다. 스크립트 하나를 두 에이전트가 같이 써서 맥락을 맞춘다.
- **대안**: 세션 로그 전체를 CLAUDE.md에 `@` import → 로그가 쌓이면 컨텍스트가 커지고 Codex는 import를 못 써서 제외. ECC 세션 요약(`~/.claude/session-data`) → Claude 전용이고 옵시디언과 이중 관리라 제외.

## 2026-09-25 — 교차 리뷰 방식과 모델 선택
- **결정**: 구현 후 다른 에이전트가 교차 리뷰한다(Claude ↔ Codex). 리뷰 전에는 항상 사람에게 변경 규모와 추천 강도를 보여 주고 강도(건너뛰기/가벼움/표준/심층)를 고르게 한다. 실행은 `/cross-review`. 모델은 작업 성격에 맞춰 고른다(설계·심층 = 고성능, 구현·표준 = 균형, 단순·가벼움 = 빠른 모델).
- **이유**: 요금제 안에서 토큰을 무리하지 않게 쓰면서, 큰 변경에만 비싼 리뷰를 쓰기 위함. 사람이 매번 강도를 정해 예상 밖 사용량을 막는다.
- **대안**: 매번 고정 강도로 자동 리뷰 → 작은 변경에도 토큰 낭비. ECC `santa-loop`(두 리뷰어 모두 승인할 때까지 반복) → 반복 횟수가 커질 수 있어 기본으로는 쓰지 않음.

## 2026-09-25 — 하네스를 L1/L2/L3 트리로 분리
- **결정**: 이 프로젝트에 있던 공통 규칙·명령·스크립트·템플릿을 L1(`~/Brain/System`, `~/.claude`)으로 옮기고, 저장소 `AGENTS.md`에는 intratnm 고유 규칙(목적, 추가 품질 게이트, 회사 정보 금지)만 남긴다. `.harness-project`로 vault와 연결하고, vault에 L2 `Knowledge/`, L3 `Agents/`를 추가한다.
- **이유**: 전역 결정 → [[System/Decisions#2026-09-25 — 하네스 트리 구조 (L1 → L2 → L3)]]
- **대안**: 이 프로젝트에 그대로 두기 → 다음 프로젝트에서 다시 만들어야 해서 제외
