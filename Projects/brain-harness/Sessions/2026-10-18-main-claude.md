---
project: brain-harness
date: 2026-10-18
agent: claude
worktree: main
summary: 로드맵 2단계 적용 완료(7/8 새 세션 확인 남음), step-choice 스킬, Codex 연결 복구, 두 저장소 push, /handoff, 플랫폼 방향 회의로 로드맵 3~6단계 재편, 외부 저장소 6종 벤치마킹 결정
tags: [brain-harness, session]
---
# 세션 — 2026-10-18 / main / claude
## 한 일
- 2026-10-17에서 이어 로드맵 2단계 진행. Fable 하위 에이전트가 [[docs/stage2-record-structure]] 작성(4945629). Q1~Q6 추천안 채택, Q5는 에이전트가 직접 설정하는 방식으로
  → 결정 [[System/Decisions#2026-10-18 — 로드맵 2단계: 기록 구조 단순화]]
- 커밋 16a9399 템플릿 4종, 377d36e summary·전체 경로 링크·newLinkFormat=absolute, 092235c session-context.sh 색인·--handoff·doctor.sh 링크 점검, b3949ef 명령·Rules·Decisions 갱신·intratnm Handoff 91→57줄·결정 4건 이관 (2~6/8)
- 선택 창(AskUserQuestion) 방식 step-choice 스킬 생성(a6562e7), install-commands.sh 스킬 설치 지원
  → 결정 [[System/Decisions#2026-10-18 — 단계별 객관식 질문 스킬(step-choice)과 설정 직접 적용]]
- 미추적 폴더 Projects/intratnm/INTRA_TNM_홈페이지_자료(69MB)가 커밋에 섞임 → git reset --mixed로 재작성해 제외, .gitignore 추가(226f4e8)
- Codex 링크 복구: ~/.local/bin/codex → ChatGPT.app 내 codex-cli(0.158.0-alpha.2.1); 옵시디언 재로드 후 app.json newLinkFormat=absolute 유지 확인
- 사용자 선택으로 두 저장소 push: brain-harness main 01e551e..226f4e8, intra-tnm master 0d11f9d..d99e7a5
- /handoff(8/8)로 brain-harness Handoff 재작성. 뺀 이력은 [[Projects/brain-harness/Sessions/2026-10-17-main-claude]]
- 플랫폼 방향 회의(선택 창 7문항): 기능 확장 우선·4종 프로젝트·자동 후보+정기 승인·종류별 팩·자동 점검+자율성 기준표+규칙 등록 절차·비용은 측정 먼저
  → 결정 [[Projects/brain-harness/Decisions#2026-10-18 — 플랫폼 방향 회의: 종류별 팩·지식 후보함·기반 우선 로드맵]]. Fable이 Overview 3~6단계·백로그(거래소·커스터디·지갑 + DID, DID 누락 정정)·Handoff·Projects.md 기록
- 외부 저장소 6종 벤치마킹(ECC·ui-ux-pro-max·karpathy-skills·ponytail·my-skills·firecrawl): Sonnet 하위 에이전트 3개가 scratchpad 읽기 전용 클론으로 분석(버전 차이·라이선스·훅·MCP·공급망). 사용자가 선택 창 Q1~Q9로 채택·각색·보류 결정. 적용은 아직 없음
  → 결정 [[Projects/brain-harness/Decisions#2026-10-18 — 외부 저장소 벤치마킹 6종: 채택·각색·보류]], L1 [[System/Decisions#2026-10-18 — L1 플러그인 갱신 방침: ECC 2.2.3·chrome-devtools MCP 고정·ui-ux-pro-max 2.15]]. Fable이 Overview(단계별 채택 항목·즉시 작업·참고 저장소)·Handoff(다음 할 일 상단 = 즉시 작업 3개) 기록
## 바꾼 파일
- vault 안: 템플릿·스크립트·명령·Rules·Decisions·.gitignore — 위 커밋 참고. 벤치마킹 기록: Projects/brain-harness/{Decisions,Overview,Handoff}.md, System/Decisions.md (미커밋)
- Projects/intratnm/Handoff.md — 91→57줄. ~/.codex/AGENTS.md — 시작 명령에 --handoff 추가. ~/orca/projects/intra-tnm CLAUDE.md — Overview import 제거(d99e7a5)
- 백업: ~/.brain-backups/2026-10-18/stage2/
## 검증
- sh -n 스크립트 OK; doctor.sh 위키링크 OK(짧은 링크 0); intratnm Handoff 57줄; brain-harness Handoff 60줄 이내
- session-context.sh 줄 수: Brain 47(--handoff 79), intra-tnm 56(--handoff 110)
- install-commands 후 ~/.claude/commands가 원본과 일치; Codex 로그인 정상, luna 응답 pong
## 막힌 점 / 확인 필요
- firecrawl 요금·데이터 보존 정책 미확인 `TODO(확인 필요)` — 조건부 도입 전에 확인. ponytail 자체 벤치마크는 재현 안 함
## 다음 세션에
- 즉시 작업 3개: ECC 2.2.3 갱신 + chrome-devtools MCP 버전 고정, ui-ux-pro-max 2.15, /cross-review 점검표 6관점 보강 (적용 전 백업·공급망 점검)
- 새 세션(intra-tnm Claude·Codex)에서 시작 맥락 길이·색인 확인 (2단계 7/8); 1단계 효과 측정(costs.jsonl 세션별 최대값); doctor.sh에 ~/.claude/skills 동기화 점검
- 로드맵 3단계(플랫폼 기반) 계획 — 자동 점검·자율성 기준표·rules-review·비용 집계 스크립트. 사람 확인 후 적용
