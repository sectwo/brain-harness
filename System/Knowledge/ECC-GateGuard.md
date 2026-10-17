---
level: 1
summary: "ECC GateGuard 훅이 작업을 멈출 때 대응"
tags: [knowledge, ecc]
source: intratnm 2026-09-25
---
# ECC GateGuard 대응

- ECC의 GateGuard 훅은 세션의 **첫 Bash 명령**과 **파일별 첫 Edit/Write** 전에 작업을 막고 사실 확인을 요구한다.
  (요청 한 줄 요약, 명령이 확인하는 것, 파일을 불러가는 곳, 사용자 지시 원문 등)
- 대응: 요구한 사실을 답변에 적고 **같은 작업을 다시 실행**하면 통과한다. 우회하지 않는다.
- 병렬로 여러 수정을 보냈다면 일부는 이미 적용됐을 수 있다. 파일을 다시 읽고 이어간다.
- 특정 경로를 제외하려면 `GATEGUARD_EXEMPT_GLOBS`, 완전히 끄려면 `ECC_GATEGUARD=off`. 전역 설정 변경이므로 사람 승인 후에만.
- **현재 설정 (`~/.claude/settings.json` env, 2026-10-17 사용자 승인, 백업 `~/.brain-backups/2026-10-17/claude-settings.json`)**
  - `GATEGUARD_EXEMPT_GLOBS` = `/Users/isaac/Brain/**,/private/tmp/claude-501/**,/Users/isaac/.claude/projects/*/memory/**,/Users/isaac/orca/workspaces/**`
    (쉼표 구분. 파싱 위치: ECC `scripts/hooks/gateguard-fact-force.js` 106~117행)
  - `GATEGUARD_BASH_ROUTINE_DISABLED` = `1` — 세션 첫 Bash의 사실 확인만 끈다. 파괴적 Bash 확인은 유지.
  - 유지되는 확인: 프로젝트 원본(master) 폴더의 파일별 첫 수정, 파괴적 명령.
  - 이유: 2026-10-03~17 세션에서 GateGuard가 50회 넘게 작업을 막았고 대부분 worktree·세션 임시 폴더·메모리 폴더의
    첫 수정이었다. worktree 작업은 계획 승인 후 진행하고 교차 리뷰를 거치므로 첫 수정 확인이 중복이다.
  - 적용 시점: 훅이 시작 시 env를 읽으므로 **새 세션부터** 적용된다.
