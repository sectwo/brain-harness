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

## 2026-10-18 — 플랫폼 방향 회의: 종류별 팩·지식 후보함·기반 우선 로드맵
- **결정** (사용자 결정, 선택 창으로 하나씩): 브레인 하네스를 "어떤 프로젝트든 아래(L2)에 두고 진행하며 경험이 지식으로 쌓여 발전하는 **플랫폼**"으로 키운다.
  ① 중심 목표는 **기능 확장**(+플랫폼화). ② 대상 프로젝트는 소프트웨어 개발·문서/리서치·업무/운영·콘텐츠/디자인 4종 모두.
  ③ 지식 축적은 **자동 후보 + 정기 일괄 승인**(에이전트가 L1 후보함에 모으고 정기 점검 때 선택 창으로 승인).
  ④ 형태는 vault 유지 + **프로젝트 종류별 팩**(템플릿·품질 게이트·스킬 묶음), `/new-project`가 종류를 물어 팩 적용.
  ⑤ 안전장치: 자동 점검(세션 시작 doctor, 커밋 직전 큰 파일·미추적 폴더 차단, 스킬 동기화) + 자율성 기준표(묻고 하는 일/하고 보고하는 일)
  + **규칙 등록 절차**(근거·적용 범위·충돌 여부 기재) + 정기 규칙 정리(안 쓰이는·충돌 규칙 목록 → 사람이 선택). 비용은 먼저 재기만(상한은 프로젝트 2~3개 수치 후).
  ⑥ 새 로드맵: 3단계 플랫폼 기반 → 4단계 지식 축적 → 5단계 팩 → 6단계 두 번째 프로젝트(백로그: 거래소·커스터디·지갑 1개 + DID 1개). 본문은 [[Projects/brain-harness/Overview]].
- **이유**: 하네스는 프로젝트 지원용으로 시작했지만 진짜 지식 축적(경험)은 사람이 다양한 프로젝트를 진행하며 쌓인다는 사용자 판단.
  규칙은 중요하고 늘어나지만, 과도하고 무작위로 생긴 규칙이 에이전트를 잘못된 방향으로 굳힐 위험을 막아야 한다(⑤ 규칙 절차의 근거).
  사용자가 "하위 L3"라고 표현했으나 현재 트리에서 프로젝트는 L2이므로 "플랫폼 아래 프로젝트(L2)"로 기록했다.
- **대안**: Claude 추천 "가볍고 믿을 수 있게"(안정 우선) → 사용자가 확장 선택. 플러그인 포장 → 지금은 채택 안 함(나중 가능성).
  비용 상한 즉시 설정 → 수치 없이 정하면 근거가 없어 측정 뒤로. 스킬 먼저(옛 3단계) → 프로젝트를 하며 필요할 때 만들기로.
- **기록**: 세션 로그 [[Projects/brain-harness/Sessions/2026-10-18-main-claude]]

## 2026-10-18 — 외부 저장소 벤치마킹 6종: 채택·각색·보류
- **결정** (사용자 결정, 선택 창으로 하나씩. 아직 적용 전 — 결정과 백로그만): 사용자가 공유한 저장소 6종(ECC, ui-ux-pro-max, karpathy-skills, ponytail, my-skills, firecrawl)을 Sonnet 하위 에이전트 3개가 분석했고 아래로 정했다.
  ① **ECC**: 릴리스 2.2.3으로 갱신 + `.mcp.json`의 chrome-devtools MCP 버전 고정(upstream은 @1.10.1). main은 안 따른다. ② **ui-ux-pro-max**: 2.15로 갱신. (①②는 L1 변경 → [[System/Decisions#2026-10-18 — L1 플러그인 갱신 방침: ECC 2.2.3·chrome-devtools MCP 고정·ui-ux-pro-max 2.15]])
  ③ **개발 원칙**(플러그인 설치 없이 각색): ponytail 우선순위 사다리(필요한가→이미 있나→표준 라이브러리→설치된 의존성) + `shortcut: <한계>, <업그레이드 시점>` 주석 규약 + karpathy 핵심 2줄(외과적 변경·단순함)을 개발 팩 AGENTS.md 틀의 상시 규칙으로. 출처(MIT) 표기.
  ④ **/cross-review** 표준·심층 점검표에 ponytail-review/audit 6관점(버그·보안·부하·테스트·속도·비대함) 추가. 가벼움은 그대로.
  ⑤ **규칙 등록·정기 정리**: ECC rules-distill(수집 후 판정)+config-gc(소프트 삭제·항목별 확인·로그) 틀을 각색한 vault 스킬 `rules-review`(대상 Rules.md, 정기 점검 때 선택 창으로 항목별 승인). `~/.claude` 정리는 config-gc 원본.
  ⑥ **비용 기록**: ECC stop:cost-tracker 수집 그대로 + `System/scripts` 집계 스크립트(프로젝트별·세션별, 하네스 작업 비중; 세션별 최대값, 합산 금지). 표 열은 ponytail band 참고. 한계: 세션 단위.
  ⑦ **지식 후보함**: ECC agent-self-evaluation 5축을 변형한 승격 가치 4축(다른 프로젝트에도 쓰이나·검증됐나·중복 없나·오래 유효한가) 점수, 정기 점검 때 점수순 제시. 자동 학습 훅은 계속 끔.
  ⑧ **firecrawl**: 연구·설계 팩 `site-research` 스킬을 WebFetch+chrome-devtools로 먼저. 대량 수집·차단으로 막히면 firecrawl MCP(공식 서버 MIT)를 프로젝트 범위·버전 고정·키는 환경 변수·피드백 도구 끔으로 도입.
  ⑨ **my-skills**: 설치·코드 복사 안 함(라이선스 없음). 아이디어 4개만 각색 — 세션 기록(jsonl) 분석(3·4단계 재료), 작업 후 변경 요약(개발 팩 CHANGELOG 한 줄), 프로젝트 시작 틀(intra-tnm 과정 기반 시작 체크리스트), 카드뉴스(콘텐츠·디자인 팩, 해당 프로젝트가 생길 때).
  보류·건너뜀: living-docs-governance·knowledge-ops 건너뜀. skill-stocktake(스킬 늘면)·eval-harness·strategic-compact 보류. 6단계 전 검토: ecc security-scan(외부 npm)·safety-guard freeze 모드·security-review 체크리스트(보안 강화 팩).
- **이유**: 3~5단계에 필요한 것(규칙 정리, 비용 집계, 후보함, 팩 규칙)은 이미 검증된 틀을 각색하면 빠르고, 플러그인·훅을 늘리면 공급망·비용 부담이 커진다. ponytail 자체 벤치마크는 재현하지 않았다.
- **대안**: ECC main 추종 → 미공개 GateGuard 재작업·새 UserPromptSubmit 훅(250커밋) 검증 부담으로 기각. ponytail 플러그인 설치 → 훅 3종·웹훅 추가 대비 얻는 것은 규칙 몇 줄이라 각색으로. firecrawl 지금 도입 → 요금·보존 정책 미확인·도구 27개라 조건부로. my-skills 설치 → 라이선스 없음·빌드 산출물·개인 설정 커밋이라 기각.
- **기록**: 세션 로그 [[Projects/brain-harness/Sessions/2026-10-18-main-claude]] (분석 원본은 세션 scratchpad 읽기 전용 클론)

## 2026-10-18 — 실험: claude-mem을 해마(임시 일화 기억)로 — brain-harness만, 2주
- **결정** (사용자 결정, 선택 창 — "claude-mem 시험 설치", 범위 "brain-harness 프로젝트만", 실험안 "이대로 시작"): 사용자 제안 비유대로 옵시디언은 **대뇌피질**(시냅스, 느리게 골라 굳힌 의미 기억), claude-mem은 **해마**(빠른 자동 일화 기억, 일시적). 기간: 2026-10-18 시작, 첫 리뷰는 brain-harness 세션 5회 또는 1주 중 먼저(아래 변경) (실험 트랙, [[System/Rules]] 1절).
  설치: bun 1.4.3은 공식 GitHub 릴리스 zip을 SHASUMS256·코드 서명 확인 후 `~/.bun/bin`(+`~/.local/bin/bun` 링크)에 설치(brew는 Command Line Tools 14.3이 낡아 실패, 사람 승인), 플러그인 `thedotmack/claude-mem` 태그 v14.0.1 고정, `~/Brain` 저장소 `.claude/settings.json`(project scope)에서만 켬. 스킬 27개(`claude-mem:handoff` 이름 겹침 주의)·상시 약 2,500토큰.
  설정(`~/.claude-mem/settings.json`): 텔레메트리 끔(DO_NOT_TRACK=1, CLAUDE_MEM_TELEMETRY=0, _ERRORS=0), Chroma 끔, FILE_READ_GATE 끔, transcript watcher 끔, 하위 에이전트 관찰 끔, 비밀 가리기 켬(일반 패턴 포함), worker idle 종료 1800초, 주입 관찰 5·세션 요약 2, 관찰 묶음 8, 모델 기본(Haiku 4.5, Claude 구독 인증).
  피질(옵시디언): 결정·규칙·검증된 지식·Handoff·세션 요약. 골라서 쓰고 사람 승인, 기준(source of truth), 오래 감.
  해마(claude-mem): 도구 호출 관찰(시도·실패·오류·읽은 파일). 훅이 자동 수집, 필요할 때만 검색(mem_search)·시작 주입 최소, 30일 뒤 삭제(`hippocampus-prune.sh`, 자체 TTL 없음), 기준 아님.
  정리(해마→피질): `/handoff` 때 해마 검색으로 후보 제안, 사람 승인 후 피질에. 실험이 채택되면 분담표를 Rules.md 2절에 반영.
  성공 기준: ① "지난번 그거" 검색이 jsonl grep 기준선보다 잘 찾음 ② `/handoff` 후보로 쓸 만한 것 나옴 ③ 사용량 증가 감당 가능(주당 호출 수·사용량 기록) ④ DB 비밀 값 패턴 0건. 시작 맥락 80줄 기준 유지.
  되돌리기: `claude-mem stop` → 플러그인 제거·마켓 제거 → `~/.claude-mem/`·`~/.local/bin/claude-mem` 삭제 → 선택 `~/.bun`·`~/.local/bin/bun` 삭제. 백업 `~/.brain-backups/2026-10-18/claude-mem-experiment/`.
- **이유**: 세션 로그 40줄 요약은 시도·실패·명령 같은 일화가 빠진다(해마 빈자리). 코드 조사 결과 플러그인 방식은 `~/.claude/settings.json`을 고치지 않고 bun 자동 설치·전역 transcript 감시가 없으며 텔레메트리·호스티드 서비스를 끌 수 있어 격리 실험이 가능하다.
  상보적 학습 시스템 이론(McClelland 외 1995: 빠른 일화 저장소 + 느린 의미 저장소)과도 맞다.
- **대안**: 완전 격리 CLAUDE_CONFIG_DIR → ECC 없는 환경이라 측정이 비현실적이어서 기각. jsonl grep 기준선만 → 비교 기준선으로 함께 씀. 기본 설정 그대로 → 텔레메트리 기본 켬·자동 소멸 없음·주입 50개라 기각.
- **기록**: [[System/Decisions#2026-10-18 — 실험 트랙 추가: 검증 전 도구를 격리해 시험, 기억·학습 방침 문구 정리]], 세션 로그 [[Projects/brain-harness/Sessions/2026-10-18-sectwo-하네스-업데이트-자업-claude]]
- **변경 (2026-10-18)**: 사용자 결정으로 고정 2주 시험 대신 "적용하고 실제로 작업하며 보완"으로 바꿨다. 첫 리뷰는 세션 5회 또는 1주 중 먼저, 이후 리뷰마다 계속·조정·중단을 정한다. 해마 소멸 30일은 그대로.

## 2026-10-18 — 3단계에 유지보수 체계를 ②로 추가: 원본 목록·upstream-check·정기 점검 순서
- **결정** (사용자 제기, 선택 창 — "3단계 ②로 당기기"): 사용자가 "적용한 스킬·라이브러리와 각색한 내용도 꾸준히 업데이트가 필요하다, 하네스를 어떻게 유지보수해야 하나"를 물었다.
  3단계 순서를 ① 자동 점검(완료) → ② 유지보수 체계 → ③ 비용 기록 → ④ 자율성 기준표 → ⑤ 규칙 등록 절차로 바꿨다(옛 ②비용·③자율성·④규칙이 하나씩 밀림).
  내용: `System/Upstreams.md`(종류 설치·각색, 고정 버전 태그·커밋, 우리 위치, 각색 출처 파일·커밋, 마지막 확인일),
  `upstream-check.sh`(최신 태그·릴리스 대 고정 버전, 각색 원본 파일의 그 커밋 이후 변경 diff; 네트워크를 쓰므로 세션 시작이 아니라 정기 점검 때),
  정기 점검 고정 순서(upstream-check → 공급망 점검 [[System/Knowledge/Plugin-Supply-Chain-Check]] → 재각색 판단 → 기한 된 실험 판정 → rules-review).
  갱신 강도: 보안 수정은 바로 제안, 일반 갱신은 정기 점검 때 일괄, 메이저는 실험 트랙.
- **이유**: 설치(ECC 2.2.3, chrome-devtools MCP 1.10.1, ui-ux-pro-max 고정 불가, karpathy, claude-mem 14.0.1, bun 1.4.3, Codex CLI, Headroom)·각색(ponytail 6관점, rules-distill·config-gc,
  cost-tracker, 4축 점수, one-skill·claude-mem 아이디어)이 10개를 넘는데 언제 확인했고 원본이 무엇이 바뀌었는지 모아 둔 곳이 없다. 각색은 원본이 좋아지거나 고쳐져도 알 길이 없다.
  비용 집계보다 먼저 두는 이유: ui-ux-pro-max는 update 한 번에 main 최신으로 올라가는 등 갱신 사고 위험이 지금 있다.
- **대안**: 3단계 끝에 추가 → 위험을 늦게 잡아 기각. 목록만 먼저 → 확인 자동화 없이는 목록이 낡아 기각.
- **기록**: [[Projects/brain-harness/Overview]] 3단계, 세션 로그 [[Projects/brain-harness/Sessions/2026-10-18-sectwo-하네스-업데이트-자업-claude]]

## 2026-10-18 — 실험: one-skill(task-observer) — brain-harness만, 세션 5회 또는 1주
- **결정** (사용자 결정, 선택 창 — "시험 적용을 하고 싶지만 2주는 너무 길다, 유즈케이스를 확인 후 우선 적용", 적용안 "이대로 적용하고 실제로 작업해 가며 보완"): rebelytics/one-skill-to-rule-them-all v3.7.0(commit 3463c7c, CC-BY-4.0)의 task-observer를 프로젝트 스킬 `~/Brain/.claude/skills/task-observer/`에 원본 그대로 설치(SKILL.md·references·scripts 3개, validate-skill-bundle.py·migrate-log.py 제외, NOTICE.md 출처 표기). 전역 `~/.claude/skills`에는 넣지 않음.
  작업 폴더 `~/.brain-experiments/task-observer/`(git 밖 실험 격리 — vault 안이면 worktree마다 사본이 갈라짐). 활성화: 프로젝트 `.claude/settings.json` env `TASK_OBSERVER_WORKSPACE` + SessionStart 훅 `.claude/hooks/task-observer-start.sh`(원본 environments.md 예시 각색, 관찰은 한국어) + 프로젝트 CLAUDE.md 활성화 블록. 반영은 리뷰에서 사람 승인만([[System/Rules]] 6절).
  유즈케이스(이번 세션·기록에서 실제로 있었던 일): ① 교정 — "선택 창으로 물어봐" 반복, "발전을 막는 방침" 지적 → 스킬·규칙 개선안 ② 반복 작업 — Fable Decisions·Sonnet 세션 로그 지시 7회 직접 작성, L1 절차(백업→수정→기록→커밋→병합) 4회, 외부 저장소 벤치마킹 2회 → 스킬 후보 brain-record·l1-change·repo-benchmark
  ③ 규칙 위반 반복 — 세션 로그 40줄 초과, 작업 폴더 이탈(`cd ~/Brain`), Headroom 압축으로 시험 출력 오독 위험 → 두 번째부터 구조적 차단 제안.
  첫 리뷰: brain-harness 세션 5회 또는 1주 중 먼저. 측정: 세션당 추가 토큰(SKILL.md 691줄), 관찰 수, 승인된 제안 수. 해마 실험과 구분해 기록(해마=무엇을 했나, task-observer=무엇을 고쳐야 하나).
  되돌리기: 프로젝트 settings의 훅·env 제거, CLAUDE.md 블록 제거, `.claude/skills/task-observer/` 삭제, 작업 폴더는 리뷰 후 삭제.
- **이유**: 분석에서 스크립트에 네트워크·eval 없음, 스킬 변경은 승인 정책이 있어 하네스 철학과 가깝다. 원본 README도 스킬이 적은 환경에선 효과가 작다고 밝혀, 고정 기간보다 실제 유즈케이스로 바로 써 보고 판단하는 쪽이 맞다.
  리뷰 알림 분기는 never·30일 경과·2일 경과 가짜 기록으로 시험해 기대대로 동작.
- **대안**: 아이디어만 각색 → 사용자가 실제 적용을 원해 보류. 2주 고정 → 사용자 기각. 기록을 vault 안 → worktree 분열로 기각. 전역 설치 → 다른 프로젝트까지 매 세션 비용이라 기각.
- **기록**: [[System/Decisions#2026-10-18 — 실험 트랙 추가: 검증 전 도구를 격리해 시험, 기억·학습 방침 문구 정리]], 세션 로그 [[Projects/brain-harness/Sessions/2026-10-18-sectwo-하네스-업데이트-자업-claude]]
