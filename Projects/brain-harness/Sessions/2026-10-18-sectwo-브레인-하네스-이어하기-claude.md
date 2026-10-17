---
project: brain-harness
date: 2026-10-18
agent: claude
worktree: sectwo/브레인-하네스-이어하기
summary: Handoff 1번 — ECC 2.2.3 훅 실제 동작 확인과 2단계 7/8 시작 맥락 길이·색인 실측, 모두 통과
tags: [brain-harness, session]
---
# 세션 — 2026-10-18 / sectwo/브레인-하네스-이어하기 / claude
## 한 일
- 설치 확인: installed_plugins.json에 ecc 2.2.3(c05b2d6), ui-ux-pro-max 2.15.0(56ea9cf). settings.json env는 GATEGUARD_EXEMPT_GLOBS(Brain, /private/tmp/claude-501, memory, orca/workspaces), GATEGUARD_BASH_ROUTINE_DISABLED=1, ECC_DISABLED_HOOKS=pre:observe,stop:evaluate-session 그대로
- hooks.json(2.2.3): pre:observe·stop:evaluate-session id 실제 존재, MCP 상태 훅(pre:mcp-health-check, post:mcp-health-check) matcher `^mcp__`
- 실제 세션: 첫 Bash가 GateGuard에 막히지 않음 (Bash 루틴 비활성 동작)
- 가짜 입력 시뮬레이션(훅 스크립트에 JSON 주입, 파일 변경 없음):
  - worktree·vault 경로 Edit 통과 / 예외 밖 경로(~/someproj) 첫 Edit은 deny(Fact-Forcing Gate) / Bash `ls` 통과
  - 파괴적 Bash(`rm -rf`, `git reset --hard`)는 pre-bash-dispatcher 경로에서도 deny
  - hook-flags.js isHookEnabled: pre:observe·stop:evaluate-session=false, gateguard·cost-tracker=true
  - mcp-health-check는 플러그인 MCP(chrome-devtools) 설정을 못 찾아 "skipping preflight probe"로 통과만 함(차단 없음, 무해)
  - 시뮬레이션용 ~/.gateguard/state-bh-*.json 2개는 지움
- 2단계 7/8 실측 (기준: session-context.sh 출력 80줄 이내)
  - brain-harness worktree 55줄/2.9K자(--handoff 108줄), intra-tnm(master) 55줄/4.7KB(--handoff 110줄)
  - intra-tnm 시작 맥락 합계 = import 277줄/23.1KB(~/.claude/CLAUDE.md 5, Rules 180, CLAUDE.md 8, AGENTS.md 27, Handoff 57) + 맥락 55줄/4.7KB ≈ 332줄/27.8KB. 2단계 전 570줄/47.2KB 대비 약 41% 감소
  - Overview는 더 이상 import 안 되고 색인(절 제목)만 나옴
## 바꾼 파일
- 이 세션 로그만 추가. 설정·스크립트 변경 없음
## 검증
- doctor.sh: ERROR 0, WARN 2 (Orca Codex Headroom 미경유, codex 샌드박스 우회 인자 — 기존 WARN). 스크립트 변경 없음이라 `sh -n` 해당 없음
- 교차 리뷰: 코드 diff 없음(문서만) — 건너뛰기
## 막힌 점 / 확인 필요
- 없음. ECC 훅 부트스트랩은 CLAUDE_PLUGIN_ROOT가 없으면 plugins/cache를 순서대로 뒤져 옛 ecc/2.2.2 캐시를 잡을 수 있음 → 옛 캐시(ecc 2.2.2, ui-ux-pro-max 2.13.0, 백업 ~/.brain-backups/2026-10-18/) 삭제 후보
- intra-tnm에서 실제 Claude·Codex 세션을 연 확인은 아님(스크립트 실행으로 대신함)
## 다음 세션에
- Handoff 2번 이 worktree들 main 병합(push는 사람 승인), 3번 /cross-review 6관점
- 2단계 7/8 완료를 /handoff 때 [[Projects/brain-harness/Overview]]·Handoff에 반영
- 옛 플러그인 캐시 삭제 여부 사람 확인
