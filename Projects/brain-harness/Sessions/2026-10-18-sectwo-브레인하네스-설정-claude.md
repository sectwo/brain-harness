---
project: brain-harness
date: 2026-10-18
agent: claude
worktree: sectwo/브레인하네스-설정
summary: ECC 2.2.2→2.2.3 적용(마켓플레이스 ref를 v2.2.3 태그로 고정), chrome-devtools MCP는 1.10.1 고정 확인, 게이트 통과
tags: [brain-harness, session]
---
# 세션 — 2026-10-18 / sectwo/브레인하네스-설정 / claude
## 한 일
- 메인 모델 Opus 5.5. Handoff 다음 할 일 1번(ECC 2.2.3 + chrome-devtools MCP 고정) 수행
- 계획: 확인 결과와 적용 계획을 보여 주고 사용자 승인("적용해줘") 받음. 사용자 지적: 선택은 채팅 글이 아니라 step-choice 선택 창으로 물어야 함 — 앞으로 그렇게
- 확인: 설치본 e482e57은 v2.2.2 태그(c70874f)보다 이전 main 커밋. 실제 변경 908파일 약 +9만 줄(대부분 테스트·문서·opencode)
- 로드 부분 변경: hooks.json MCP 상태 훅 matcher `.*`→`^mcp__`, gateguard·block-no-verify·config-protection 보강, lib/shell-scan.js 신규
- 공급망 점검 통과: 네트워크·child_process·eval·new Function·postinstall 없음
- GATEGUARD_EXEMPT_GLOBS·GATEGUARD_BASH_ROUTINE_DISABLED·ECC_DISABLED_HOOKS 유지 확인. v2.2.3 .mcp.json은 이미 chrome-devtools-mcp@1.10.1
- 적용: 백업 → settings.json `extraKnownMarketplaces.ecc.source.ref`=v2.2.3 → `claude plugin marketplace add "https://github.com/affaan-m/ECC.git#v2.2.3"` → `claude plugin update ecc@ecc` (2.2.2→2.2.3, sha c05b2d6)
- 시행착오: 선언 불일치로 add가 "declared" 거부, 선언만 바꾸면 marketplace update가 "not found"
  → 결정 [[System/Decisions#2026-10-18 — ECC 2.2.3 적용: 마켓플레이스 ref 태그 고정]] (Fable 기록)
## 바꾼 파일
- ~/.claude/settings.json (ref 고정), ~/.claude/plugins/ (ECC 2.2.3). 백업: ~/.brain-backups/2026-10-18/plugins-ecc/
- System/Decisions.md (결정 추가), System/Environment.md (버전 2.2.3, hooks 기준, ref 고정 표기)
## 검증
- plugin details ecc 2.2.3 (훅 7, MCP 1); 새 claude -p 세션에서 chrome-devtools MCP 도구 로드 확인
- doctor.sh 오류 없음 (기존 WARN 2: Orca Codex Headroom 미경유, codex 샌드박스 우회 인자 — 이번 변경과 무관). 스크립트 변경 없음
- 교차 리뷰: 코드 diff 없음(설정·문서만) — 건너뛰기
## 막힌 점 / 확인 필요
- 없음. 참고: 이 세션의 훅은 아직 2.2.2로 돎, 새 세션부터 2.2.3. 옛 캐시 cache/ecc/ecc/2.2.2는 남아 있음(백업도 있음)
## 다음 세션에
- Handoff 2번 ui-ux-pro-max 2.13.0→2.15.0 (같은 방식: extraKnownMarketplaces ref 고정 검토)
- Handoff 3번 /cross-review 점검표 6관점 추가
