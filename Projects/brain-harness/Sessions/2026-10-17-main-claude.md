---
project: brain-harness
date: 2026-10-17
agent: claude
worktree: main
tags: [brain-harness, session]
---
# 세션 — 2026-10-17 / main / claude

> 이 로그의 앞 두 절은 intra-tnm 세션(`b05b868a`)에서 한 하네스 작업을 [[Projects/intratnm/Sessions/2026-10-17-master-claude]]에서 옮긴 것이다 (2026-10-17 프로젝트 분리).

## 추가 — 브레인 구성도와 문서 목차 (같은 날 이어서)
- **archify 점검·실행**: [tt-a1i/archify](https://github.com/tt-a1i/archify)(MIT, 커밋 `88d1ae4`) 소스 점검 —
  런타임 의존성 0, 설치 훅 없음, 네트워크는 선택적 업데이트 확인뿐. 전역 설치 없이 세션 임시 폴더에 clone 해
  `ARCHIFY_UPDATE_CHECK_DISABLED=1 node archify/bin/archify.mjs finalize architecture … --quality showcase --json`으로 실행.
- **구성도 첫 안 → 사실 오류 3건 수정**: (1) Claude → 저장소 "구현·커밋" 연결이 빠져 있어 추가,
  (2) 저장소 → GitHub "git push" 연결 추가, (3) L1 스크립트 → 명령 원본 '실행'으로 잘못 그린 연결 제거
  (스크립트는 명령을 실행하지 않고 `install-commands.sh`로 복사만 한다). 수정 후 4개 게이트
  (validate · deliver · check · browser-check) 모두 pass. 기록 단계에서 최종 파일로 finalize를 다시 돌려
  같은 해시(HTML `7e5d60…`, JSON `7289b8…`)로 4개 pass 재확인 — 옛 `*.browser-check.json`이 남아 있으면
  browser-check가 "unowned evidence path"로 실패하므로 치우고 돌려야 함(diagrams/README 갱신법에 적음).
- **vault 변경 (사용자 승인, L1 백업 `~/.brain-backups/2026-10-17/`)**: `System/diagrams/`(HTML·JSON·README),
  `docs/README.md`(GitHub용 문서 목차), `System/Rules.md` 1절에 `diagrams/` 행과 `docs/` 설명 추가,
  `System/Decisions.md`에 결정 추가. 커밋 2건 후 `brain-harness` `main` push(사용자가 GitHub 관리까지 요청해
  이번 변경에 한해 승인된 것으로 봄).

## 로드맵 1단계(비용·마찰) 적용 (같은 날 이어서)
- **사용자 승인**: "브레인 발전 로드맵 1단계: 비용·마찰 줄이기". 위 "막힌 점"의 세션 비용 관리 방침이 이걸로 정해짐.
- **바꾼 것** (L1, 백업 `~/.brain-backups/2026-10-17/` — settings는 `claude-settings.json`, vault 파일은 `*-stage1`):
  - `~/.claude/settings.json` env: `GATEGUARD_EXEMPT_GLOBS`(Brain·세션 임시 폴더·메모리 폴더·orca workspaces),
    `GATEGUARD_BASH_ROUTINE_DISABLED=1`. 메인 세션이 처리. 새 세션부터 적용.
  - `System/Rules.md` 5절: vault 기록을 판단 기록(Fable) / 사실 기록(Sonnet)으로 나눔, "세션 길이" 불릿 추가.
  - `System/Knowledge/ECC-GateGuard.md`(현재 설정값·이유), `System/Knowledge/Headroom-Output-Compression.md`(긴 출력은 나눠 실행).
  - `System/Decisions.md`: `2026-10-17 — 로드맵 1단계` 결정 추가.
- **기준값**: `costs.jsonl` 세션별 최대값 기준 이번 세션(`b05b868a`) Opus 약 $251 + Sonnet 약 $52 = 약 $303(API 가격 환산).
  줄마다 누적값이라 합산하면 약 $14,000로 부풀려짐 — 합산 금지. 요금제 사용률 5시간 12%, 7일 2%.
- **다음**: 새 세션에서 GateGuard 예외·모델 배치 효과 확인(다음 기능 하나 작업 후 같은 방식으로 비교).
  vault push 여부는 사용자에게 확인.

## 하네스 프로젝트 분리 (2026-10-17, 이어서)
- 사용자 요청으로 brain-harness를 별도 L2 프로젝트로 만들었다.
- **만든 것**: `Projects/brain-harness/`(템플릿), `~/Brain/.harness-project`, `CLAUDE.md`, `AGENTS.md`,
  `System/Projects.md` 행, `System/Rules.md` 1절 문장, `System/Decisions`·프로젝트 Decisions 결정.
- 백업: `~/.brain-backups/2026-10-17/*-harness-split`.
- 로드맵 원문은 intra-tnm 세션 대화에만 있어 `Overview.md`로 옮겼다.
- 2단계 설계는 Fable 하위 에이전트가 맡는다 (사용자 선택 A).
- 모델: L1·결정 기록은 Fable, 세션 로그는 Sonnet.

## 막힌 점 / 확인 필요
- Codex `writable_roots`(`~/.codex/config.toml`)에는 intratnm 경로만 있어 brain-harness 경로 추가가 필요하다. 사람 확인 대기.

## 다음 할 일
- Codex `writable_roots`에 brain-harness 경로 추가 여부 확인.
- 짧은 위키링크 모호성 해결 (2단계).
- vault push 여부 사람에게 확인.
