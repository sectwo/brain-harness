---
level: 1
summary: "ECC GateGuard 훅이 작업을 멈출 때 대응, 현재 예외 설정, 훅 판정을 가짜 입력으로 확인하는 법"
tags: [knowledge, ecc]
source: intratnm 2026-09-25, brain-harness 2026-10-18
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

## 설정 확인법 (파일을 바꾸지 않고 훅 판정만 본다)
- 플러그인 루트 `~/.claude/plugins/cache/ecc/ecc/<버전>`에서 `CLAUDE_PLUGIN_ROOT`를 그 경로로 지정하고 `settings.json`의 env
  (`GATEGUARD_*`, `ECC_DISABLED_HOOKS`)를 export한 뒤, 가짜 tool 입력 JSON을 훅에 넣는다.
  - Edit/Write: `echo '<JSON>' | node scripts/hooks/run-with-flags.js pre:edit-write:gateguard-fact-force scripts/hooks/gateguard-fact-force.js standard,strict`
    (JSON에 `session_id`, `tool_name`, `tool_input.file_path`). 예외 경로면 입력이 그대로 나오고, 예외 밖 첫 수정이면 deny JSON이 나온다.
  - Bash: `scripts/hooks/pre-bash-dispatcher.js`에 `tool_input.command`를 넣는다. 루틴 비활성이면 `ls` 통과, `rm -rf`·`git reset --hard`는 deny.
  - 훅 켜짐 여부: `scripts/lib/hook-flags.js`의 `isHookEnabled('<id>')` (예: `pre:observe`, `stop:evaluate-session`은 false여야 한다).
- 시험이 끝나면 가짜 세션 id의 `~/.gateguard/state-<id>.json`을 지운다 (`STATE_DIR` 기본 `~/.gateguard`).
- 2026-10-18 ECC 2.2.3에서 위 방법으로 예외 통과·예외 밖 차단·파괴적 명령 차단·루틴 비활성을 확인했다.
