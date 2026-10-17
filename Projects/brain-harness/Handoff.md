---
project: brain-harness
last_handoff: 2026-10-18
tags: [brain-harness, handoff]
---
# Handoff — brain-harness

> 새 세션은 이 노트부터 읽는다. `/handoff`로만 갱신한다. 이력은 쓰지 않는다 — 언제 무엇을 했는지는 Sessions/, 왜는 Decisions.

<!-- 규칙: 60줄 이내. "현재 상태"는 매번 다시 쓴다(누적 금지). 완료된 "다음 할 일"은 지운다 — 완료 사실은 세션 로그에 있다.
금지: 날짜·커밋 해시·"~했다" 이력, 리뷰 이력, 완료 항목 목록, 결정 본문(링크 3개 이내로만). -->

## 현재 상태
- 로드맵 1·2단계 완료, 3단계(플랫폼 기반) 진행 중. 순서는 ① 자동 점검(완료) → ② 유지보수 체계 → ③ 비용 기록 → ④ 자율성 기준표 → ⑤ 규칙 등록 절차.
  항목 하나당 worktree 하나. 세부 항목·참고 저장소는 [[Projects/brain-harness/Overview]] 3단계.
- 자동 점검 동작 중: 세션 시작 때 `doctor.sh --quiet` 경고가 시작 맥락에 보이고(최대 3줄), Claude의 `git commit` 전에 `precommit-check.sh`가 큰 파일·산출물·대량 새 파일을 차단한다
  (회귀 시험 `System/scripts/tests/precommit-check.test.sh`, 우회는 명령 앞 `BRAIN_PRECOMMIT_OK=1`). 스킬 동기화도 doctor가 본다. **Codex 커밋 차단은 아직 미연결.**
- `/cross-review` 표준·심층은 6관점(버그·보안·부하·테스트·속도·비대함) 점검표로 본다. 가벼움은 그대로.
- Rules 1절에 실험 트랙이 있다(격리 범위에서 시험, 시작 전 Decisions 기록, 끝나면 System/Decisions에 판정). 지금 실험 2개가 brain-harness 범위로만 켜져 있다.
- 실험 ① claude-mem 해마: 이 저장소 `.claude/settings.json`(project scope)에 v14.0.1 고정, 텔레메트리 끔. 30일 소멸은 `System/scripts/hippocampus-prune.sh`를 **수동 실행**한다(자체 TTL 없음).
  `claude-mem:handoff` 스킬이 우리 `/handoff`와 이름이 겹친다.
- 실험 ② task-observer(one-skill): 프로젝트 스킬 `.claude/skills/task-observer/` + SessionStart 훅 `.claude/hooks/task-observer-start.sh`, 작업 폴더 `~/.brain-experiments/task-observer/`.
  설치한 세션에서는 활성화를 못 봤다 — **새 세션에서 확인 필요.** 제안 반영은 사람 승인만.
- 두 실험의 첫 리뷰는 brain-harness 세션 5회 또는 1주 중 먼저 오는 때. 리뷰마다 계속·조정·중단을 사람이 정한다.
- ui-ux-pro-max는 커밋 고정이 안 돼 **`claude plugin update` 한 번이면 main 최신으로 올라간다** — 갱신 전 공급망 점검 필수([[System/Knowledge/Plugin-Supply-Chain-Check]]).
- Codex CLI는 ChatGPT.app 내장 codex-cli 링크로 동작한다. 앱 업데이트로 경로가 바뀌면 끊긴다(복구법은 [[System/Environment]] Codex 행).
- 저장소: `~/Brain` `main`은 origin과 같음. worktree `sectwo/하네스-업데이트-자업`도 main과 같음(병합 완료).

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| sectwo/하네스-업데이트-자업 | Claude | 3단계 ① 자동 점검·실험 2개 설치 | main 병합됨 — 다음 작업은 새 worktree에서 |

## 다음 할 일
1. [ ] (Claude) 새 세션에서 두 실험 활성화 확인 — task-observer 시작 프로토콜 출력·관찰 폴더 생성, claude-mem worker 동작·관찰 기록, 시작 맥락 80줄 이내 유지
2. [ ] (Claude) 3단계 ② 유지보수 체계 — `System/Upstreams.md`·`upstream-check.sh`·정기 점검 고정 순서. 새 worktree, 계획 확인 후 적용
3. [ ] (Claude) 실험 첫 리뷰(세션 5회 또는 1주 중 먼저) — 해마: 관찰 수·사용량·jsonl grep 대비 검색 품질·비밀 패턴 0건 /
   task-observer: 세션당 추가 토큰·관찰 수·승인된 제안 수. 결과로 계속·조정·중단을 사람에게 묻는다
4. [ ] (Claude) Codex `~/.codex/hooks.json` pre_tool_use에 `precommit-check.sh` 연결 — 훅 형식 확인 후
5. [ ] (Claude) 3단계 ③ 비용 기록 — 집계 스크립트(프로젝트별·세션별 최대값, 합산 금지) + 세션 jsonl 분석. 1단계 효과 측정은 여기에 흡수
6. [ ] (사람) OmniRoute 보류 추천에 대한 결정. Codex 관련 스킬·내용 추가(추후). 백로그 DID 범위는 시작 전 논의, firecrawl 요금·보존 정책은 도입 전 확인

## 막힌 점 / 확인 필요
- OmniRoute: 에이전트는 보류를 추천했고 사용자 결정은 아직 없다(다음 할 일 6)

## 관련 결정
- [[Projects/brain-harness/Decisions#2026-10-18 — 실험: claude-mem을 해마(임시 일화 기억)로 — brain-harness만, 2주]] — 설정값·성공 기준·되돌리기, 리뷰 기준 변경
- [[Projects/brain-harness/Decisions#2026-10-18 — 실험: one-skill(task-observer) — brain-harness만, 세션 5회 또는 1주]] — 유즈케이스·측정 항목·되돌리기
- [[System/Decisions#2026-10-18 — 실험 트랙 추가: 검증 전 도구를 격리해 시험, 기억·학습 방침 문구 정리]] — 실험 규칙과 판정 절차
