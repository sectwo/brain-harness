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
- 로드맵은 3단계 플랫폼 기반 → 4단계 지식 축적 → 5단계 종류별 팩 → 6단계 두 번째 프로젝트. 외부 저장소 6종 벤치마킹으로
  정한 즉시 작업 ①②(플러그인 갱신)는 적용됐고, ③(`/cross-review` 6관점)과 3~5단계 항목은 아직이다.
  단계별 항목·참고 저장소 목록은 [[Projects/brain-harness/Overview]] 3~5단계.
- ECC는 v2.2.3에 마켓플레이스 ref 태그로 고정돼 있고 chrome-devtools MCP는 1.10.1 고정. ui-ux-pro-max는 2.15.0(main 커밋)이지만
  CLI가 커밋 고정을 못 해 **`claude plugin update` 한 번이면 main 최신으로 올라간다** — 갱신 전 공급망 점검 필수.
- 두 플러그인 변경은 새 세션부터 적용되며, ECC 2.2.3 훅(GateGuard 등) 실제 동작은 아직 확인 전. 옛 캐시(ecc 2.2.2, ui-ux-pro-max 2.13.0)는
  남아 있고 백업은 `~/.brain-backups/2026-10-18/`.
- 스킬은 프로젝트를 하며 필요할 때 만든다(`step-choice`만 있음). 규칙 변경은 아직 없다.
- Codex CLI는 ChatGPT.app 내장 codex-cli 링크로 동작한다. 앱 업데이트로 경로가 바뀌면 끊긴다 (복구법은 [[System/Environment]] Codex 행).
- `doctor.sh`는 `~/.claude/skills` 동기화를 아직 점검하지 않는다.
- 1단계(GateGuard 예외·모델 배치) 효과는 아직 측정하지 않았다.
- `Agents/`·`Knowledge/`는 비어 있다. Codex 관련 스킬·내용은 사용자가 추후 추가 예정.
- 저장소: `~/Brain` `main`은 벤치마킹 결정 커밋까지, `.obsidian/graph.json` 수정 미커밋. 이 worktree `sectwo/브레인하네스-설정`에
  기록 커밋 2개가 main 미병합(push도 안 함).

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| sectwo/브레인하네스-설정 | Claude | 플러그인 갱신(즉시 작업 ①②) | 완료·기록 커밋, main 병합·push 대기 (사람 승인 필요) |

## 다음 할 일
1. [ ] (Claude) 새 세션에서 ECC 2.2.3 훅(GateGuard 예외·Bash 루틴 비활성·MCP 상태 훅) 실제 동작 확인 + 시작 맥락 길이·색인 확인(2단계 7/8).
   intra-tnm 쪽 세션도 함께
2. [ ] (사람·Claude) 이 worktree를 main에 병합, push는 사람 승인 후
3. [ ] (Claude) **즉시 작업 ③** `/cross-review` 원본(`System/commands/`) 표준·심층 점검표에 6관점(버그·보안·부하·테스트·속도·비대함) 추가 후
   `install-commands.sh`. 가벼움은 그대로
4. [ ] (Claude) 3단계 플랫폼 기반 계획 — 자동 점검(세션 시작 doctor 자동, 커밋 직전 큰 파일·미추적 폴더 차단, 스킬 동기화), 자율성 기준표,
   `rules-review` 스킬(rules-distill+config-gc 각색), 비용 집계 스크립트(세션별 최대값·합산 금지) + 세션 기록 jsonl 분석.
   계획을 보여 주고 확인 후 적용 (Overview 3단계)
5. [ ] (Claude) 1단계 효과 측정 — 다음 기능 하나 작업 후 `costs.jsonl` 세션별 최대값으로 비교 (합산 금지)
6. [ ] (Claude) `doctor.sh`에 `~/.claude/skills` 동기화 점검 추가 — 3단계 자동 점검의 일부로 흡수
7. [ ] (사람) Codex 관련 스킬·내용 추가 (추후 예정). 백로그 DID 프로젝트 범위는 시작 전에 논의. firecrawl 요금·보존 정책은 도입 전 확인

## 막힌 점 / 확인 필요
- 없음

## 관련 결정
- [[System/Decisions#2026-10-18 — ECC 2.2.3 적용: 마켓플레이스 ref 태그 고정]] — ref 태그 고정 방법과 갱신 절차
- [[System/Decisions#2026-10-18 — ui-ux-pro-max 2.15.0 적용: main 커밋, 태그 고정 불가]] — 커밋 고정 불가, 다음 갱신 전 점검 조건
- [[Projects/brain-harness/Decisions#2026-10-18 — 외부 저장소 벤치마킹 6종: 채택·각색·보류]] — 즉시 작업 ③과 3~5단계 채택 항목의 근거
