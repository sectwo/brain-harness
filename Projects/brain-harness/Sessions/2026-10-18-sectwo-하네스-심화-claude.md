---
project: brain-harness
date: 2026-10-18
agent: claude
worktree: sectwo/하네스-심화
summary: Handoff 1번 — 두 실험 활성화 확인(task-observer 훅 발동·관찰 1건, claude-mem worker 정상·관찰 6건, 시작 맥락 79줄). 설치 단계 bootstrap.sh 추가, README 설명서와 docs/guide·setup 분리, 구성도 2026-10-18 갱신
tags: [brain-harness, session]
---
# 세션 — 2026-10-18 / sectwo/하네스-심화 / claude
## 한 일
### Handoff 1번: 두 실험 활성화 확인
- task-observer: SessionStart 훅 정상 발동("Open observations: 0; last review: never"). 스킬 3.7.0 로드, 참조 8개·스크립트 3개 모두 있음.
  작업 폴더 `~/.brain-experiments/task-observer/skill-observations/` 첫 생성(observation-log/, archive/, last-review-date.txt=never, cross-cutting-principles.md, checkpoints.log). session-start-scan 정상(files 1, suspect 0)
- 관찰 1건: 0001 "작업 폴더 생성 스니펫이 문서 안에만 있어 셸로 옮기다 깨짐 — 스크립트로"(Headroom 압축 출력에서 d= 줄이 빠져 read-only 실패, 피해 없음). 반영은 리뷰에서 사람 승인 시
- claude-mem 해마: worker v14.0.1 healthy(localhost:37701), 관찰 6건. project 키가 "Brain/하네스-심화"(worktree 이름) — worktree마다 기억이 나뉠 수 있음, 리뷰 때 확인.
  클라우드 동기화 없음(sync_outbox·sync_state 0건), 텔레메트리 env 꺼짐. CLAUDE_MEM_PROVIDER=claude라 요약 생성이 Claude 구독 사용량을 씀 — 리뷰 측정 항목에 포함
- 시작 맥락 79줄(80줄 이내, 한계 근접). 사용량 경고: 5시간 85%
### 설치 단계·README/가이드 분리·구성도 갱신
- 계획 확인 후 Sonnet 하위 에이전트 3개로 병렬 구현. 백업 `~/.brain-backups/2026-10-18/harness-setup/`. 결정은 [[System/Decisions#2026-10-18 — 설치 단계(bootstrap.sh)·README 설명서와 사용자 가이드 분리·구성도 갱신]]
- 메인에서 고친 것: bootstrap ECC 탐지(plugins 폴더 이름 → installed_plugins.json의 "ecc@"), README 구성도 기준일 10-17→10-18
- 교차 리뷰: 사용자 지시로 push 먼저(1회 예외), 리뷰는 push 후
## 바꾼 파일
- 실험 확인: 이 세션 로그, `~/.brain-experiments/task-observer/skill-observations/` 신규 파일(관찰 0001 포함). 스크립트·훅·설정 변경 없음
- 설치 단계: 신규 `System/scripts/bootstrap.sh`, `System/Templates/claude-settings.harness.json`, `docs/guide.md`, `docs/setup.md`. 수정 `System/scripts/doctor.sh`, `README.md`, `docs/README.md`,
  `System/diagrams/`(README, architecture.json, html), `Projects/brain-harness/Overview.md`, `System/Decisions.md`
## 검증
- 실험 확인: "한 일"의 확인 결과가 검증 전부. 코드 diff 없음
- 게이트: `sh -n` 전 스크립트 통과, doctor exit 0(기존 WARN 2개만: Orca codex Headroom 미연결·샌드박스 우회). 임시 HOME에서 bootstrap 실행·재실행 멱등·기존 값 보존·깨진 JSON 중단 확인.
  실제 HOME은 `--check`만(settings 단계 "필요"는 `~/Brain` main에 조각 파일이 아직 없어서 — 병합 후 OK). 비밀 값 grep 0건. 구성도 archify 4 gate pass + headless Chrome 캡처로 화면 확인, localhost:3009 200
- 한계: mermaid GitHub 렌더 미확인, 새 Mac 실제 실행 미시험, install-commands.sh는 `$HOME/Brain` 고정
## 막힌 점 / 확인 필요
- 없음. starter principles(v4, 29개)는 비워 두고 다음 세션에서 근거와 함께 추천 후 적용 여부를 사람에게 묻는다(마커 starter-principles-reviewed.txt 일부러 없음 → 시작 프로토콜이 다시 묻는다). 백필은 실험 리뷰 때 판단
## 다음 세션에
- 교차 리뷰 → main 병합(사람 확인). 그 뒤 Handoff 2번: 3단계 ② 유지보수 체계(새 worktree, 계획 확인 후)
- 시작 직후 task-observer starter principles 29개를 읽고 우리 하네스에 맞는 것을 근거와 함께 추천 → 적용 여부를 사람에게 확인(사용자 요청, 기존 항목 유지)
- 실험 첫 리뷰 때: claude-mem 프로젝트 키 분리 여부, 요약 생성 사용량 확인
