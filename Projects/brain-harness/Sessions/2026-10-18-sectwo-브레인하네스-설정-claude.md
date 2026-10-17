---
project: brain-harness
date: 2026-10-18
agent: claude
worktree: sectwo/브레인하네스-설정
summary: ECC 2.2.2→2.2.3(마켓플레이스 ref v2.2.3 태그 고정, chrome-devtools MCP 1.10.1 확인)과 ui-ux-pro-max 2.13.0→2.15.0(main 56ea9cf, 태그 고정 불가) 적용, 게이트 통과
tags: [brain-harness, session]
---
# 세션 — 2026-10-18 / sectwo/브레인하네스-설정 / claude
## 한 일
- 메인 모델 Opus 5.5. Handoff 1번(ECC 2.2.3 + chrome-devtools MCP 고정)과 2번(ui-ux-pro-max 2.15.0) 수행, 계획은 사용자 승인("적용해줘") 받음
- 질문 방식: 사용자 지적 이후 진행 선택은 step-choice 선택 창으로 물음(다음 단계 → 2번 진행, 갱신 대상 → main 56ea9cf, 고정 방법 → 지금 main으로 갱신)
- ECC 확인: 설치본 e482e57은 v2.2.2 태그(c70874f)보다 이전 main 커밋, 변경 908파일 약 +9만 줄(대부분 테스트·문서·opencode)
- ECC 로드 부분 변경: hooks.json MCP 상태 훅 matcher `.*`→`^mcp__`, gateguard·block-no-verify·config-protection 보강, lib/shell-scan.js 신규
- ECC 공급망 점검 통과(네트워크·child_process·eval·new Function·postinstall 없음). GATEGUARD_EXEMPT_GLOBS·GATEGUARD_BASH_ROUTINE_DISABLED·ECC_DISABLED_HOOKS 유지, v2.2.3 .mcp.json은 이미 chrome-devtools-mcp@1.10.1
- ECC 적용: 백업 → settings.json `extraKnownMarketplaces.ecc.source.ref`=v2.2.3 → `marketplace add "…ECC.git#v2.2.3"` → `plugin update ecc@ecc` (2.2.2→2.2.3, sha c05b2d6)
  시행착오(선언 불일치 add 거부, 선언만 바꾸면 update "not found") → [[System/Decisions#2026-10-18 — ECC 2.2.3 적용: 마켓플레이스 ref 태그 고정]] (Fable 기록)
- UI/UX 확인: GitHub 릴리스 태그 v2.15.0(a38d04c, 08-13)은 설치본 09170ee와 갈라진 이전 줄기(퇴행 약 7천 줄, SVG 손상 수정 #526 없음). plugin.json 2.15.0은 main 7246805(10-12)부터
- UI/UX 점검: 09170ee..56ea9cf 52파일 +2060/-199, 로드되는 skills 11파일, 추가 줄에 네트워크·subprocess·eval 없음, 훅·MCP 없음
- UI/UX 시도 실패: extraKnownMarketplaces ref에 커밋 SHA → `marketplace add` "Remote branch not found"(ref는 브랜치·태그만). settings 원복, 설치본 변화 없음 확인
- UI/UX 적용: 백업 → `git ls-remote`로 main=56ea9cf 확인 → marketplace update → plugin update 2.13.0→2.15.0 (sha 56ea9cf). ref 고정 없음 — 다음 update는 main 최신으로 감
  → [[System/Decisions#2026-10-18 — ui-ux-pro-max 2.15.0 적용: main 커밋, 태그 고정 불가]] (Fable 기록)
## 바꾼 파일
- ~/.claude/plugins/ (ECC 2.2.3, ui-ux-pro-max 2.15.0), ~/.claude/settings.json (ECC ref 고정만 남음; UI/UX 시도분은 원복)
- 백업: ~/.brain-backups/2026-10-18/plugins-ecc/, plugins-uiux/
- System/Decisions.md (결정 2건 추가), System/Environment.md (ECC 버전 2.2.3, hooks 기준, ref 고정 표기)
## 검증
- plugin details ecc 2.2.3 (훅 7, MCP 1), ui-ux-pro-max 2.15.0 (Skills 7, Hooks 0). 새 claude -p 세션에서 chrome-devtools MCP 도구·ui-ux-pro-max 스킬 로드 확인
- doctor.sh 오류 없음 (기존 WARN 2: Orca Codex Headroom 미경유, codex 샌드박스 우회 인자 — 무관). 스크립트 변경 없음
- 교차 리뷰: 코드 diff 없음(설정·문서만) — 건너뛰기
## 막힌 점 / 확인 필요
- 없음. 참고: 플러그인 변경은 새 세션부터 적용(이 세션 훅은 ECC 2.2.2). 옛 캐시 ecc/2.2.2·ui-ux-pro-max/2.13.0 남아 있음
## 다음 세션에
- Handoff 3번 /cross-review 점검표 6관점 추가
- 새 세션에서 ECC 2.2.3 훅(GateGuard 등) 실제 동작 확인
