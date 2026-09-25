---
project: intratnm
agent: codex
tags: [intratnm, agent]
---
# Codex — intratnm (L3)

> 이 프로젝트에서 Codex의 역할, 설정, 알게 된 특이점. 공통 설정은 [[System/Environment]].

## 역할
- Claude 구현분 교차 리뷰 (`/cross-review`에서 `codex review`로 실행), 필요 시 병렬 worktree 구현

## 설정
- Orca가 띄우는 Codex는 `CODEX_HOME=~/Library/Application Support/orca/codex-runtime-home/home`
- vault 쓰기: 두 config.toml의 `writable_roots`에 `~/Brain/Projects/intratnm` (L1 System은 쓰기 불가)
- Headroom 경유: Orca `agentCmdOverrides.codex` 적용 대기 → [[System/Knowledge/Orca-Codex-Headroom]]

## 알게 된 점
- (확인 필요) Orca가 `~/.codex`에서 설정을 다시 동기화할 때 `writable_roots`가 유지되는지 — 첫 Codex 세션에서 vault 쓰기로 확인
