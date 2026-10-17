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
- 로드맵 1·2단계 적용 완료. 2단계(기록 구조 단순화)는 템플릿 4종, 전체 경로 위키링크, 세션 시작 색인
  (`session-context.sh`, Codex는 `--handoff`), 명령·Rules 갱신까지 동작한다. 새 세션에서 시작 맥락 길이·색인 실측만 남았다.
- 로드맵은 방향 회의로 재편됨 — 3단계 플랫폼 기반 → 4단계 지식 축적 → 5단계 종류별 팩 → 6단계 두 번째 프로젝트.
  스킬은 프로젝트를 하며 필요할 때 만든다(`step-choice`만 있음). 3단계 착수 예정, 규칙 변경은 아직 없다.
- Codex CLI는 ChatGPT.app 내장 codex-cli 링크로 동작한다. 앱 업데이트로 경로가 바뀌면 끊긴다 (복구법은 [[System/Environment]] Codex 행).
- `doctor.sh`는 `~/.claude/skills` 동기화를 아직 점검하지 않는다.
- 1단계(GateGuard 예외·모델 배치) 효과는 아직 측정하지 않았다.
- `Agents/`·`Knowledge/`는 비어 있다. Codex 관련 스킬·내용은 사용자가 추후 추가 예정.
- 로드맵 전체는 [[Projects/brain-harness/Overview]].
- 저장소: `~/Brain` `main` (origin과 같음. `.obsidian/graph.json` 수정만 미커밋)

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| main | Claude | 로드맵 2단계 적용, /handoff | 완료 — 새 세션 시작 권장 |

## 다음 할 일
1. [ ] (Claude·Codex) 새 세션에서 시작 맥락 길이·색인 확인 — 2단계 7/8. intra-tnm 쪽 세션도 함께
2. [ ] (Claude) 1단계 효과 측정 — 다음 기능 하나 작업 후 `costs.jsonl` 세션별 최대값으로 비교 (합산 금지)
3. [ ] (Claude) 3단계 플랫폼 기반 계획 — 자동 점검(세션 시작 doctor 자동, 커밋 직전 큰 파일·미추적 폴더 차단, 스킬 동기화),
   자율성 기준표, 규칙 등록 절차·정기 규칙 정리, 비용 기록(프로젝트별·작업별). 계획을 보여 주고 확인 후 적용 (Overview 3단계)
4. [ ] (Claude) `doctor.sh`에 `~/.claude/skills` 동기화 점검 추가 — 3단계 자동 점검의 일부로 흡수
5. [ ] (사람) 백로그 블록체인 프로젝트의 분할 수 확인 (TODO, Overview 백로그); Codex 관련 스킬·내용 추가 (추후 예정)

## 막힌 점 / 확인 필요
- 없음

## 관련 결정
- [[Projects/brain-harness/Decisions#2026-10-18 — 플랫폼 방향 회의: 종류별 팩·지식 후보함·기반 우선 로드맵]] — 새 3~6단계의 근거
- [[System/Decisions#2026-10-18 — 로드맵 2단계: 기록 구조 단순화]] — 문서 역할·상한·색인·전체 경로 링크
- [[Projects/brain-harness/Decisions#2026-10-17 — 브레인 하네스를 별도 L2 프로젝트로 분리]] — 결정 기록 위치(L1/L2) 기준
