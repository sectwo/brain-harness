---
level: 1
tags: [system, diagrams]
---
# diagrams — 브레인 구성도

> 브레인 하네스 전체 구조를 한 장으로 보는 구성도. 기준일 **2026-10-18**.
> 규칙의 원문은 [[System/Rules]]이고, 이 그림은 그 규칙을 그린 것이다. 둘이 다르면 Rules.md가 맞다.

## 파일
| 파일 | 용도 |
|---|---|
| `brain-harness.html` | 구성도 본체. 단독 실행되는 인터랙티브 HTML(약 860KB). 외부 의존성 없음 |
| `brain-harness.architecture.json` | archify 원본 명세. 구성도를 고칠 때는 이 파일을 고치고 HTML을 다시 만든다 |

## 보는 법
- 로컬: `brain-harness.html`을 브라우저로 연다 (`open ~/Brain/System/diagrams/brain-harness.html`).
- GitHub 웹에서는 HTML이 소스 코드로만 보인다. 내려받아서(Raw → 저장) 브라우저로 열어야 한다.

## 담긴 구성요소
화면 위쪽 "읽는 법" 카드와 하단 5개 보기(일하는 흐름·처음 설치·자동 점검·기억 계층·실험 트랙)로 영역별로 따라 볼 수 있다.
- 일하는 흐름: 사람 → Orca(기능당 worktree) → Claude Code(Headroom 프록시 → Anthropic API) → Codex 교차 리뷰 → 프로젝트 저장소 → GitHub(push는 매번 승인)
- 처음 설치: `git clone ~/Brain` → `System/scripts/bootstrap.sh`(`--check` 후 적용) → settings 하네스 조각(`System/Templates/claude-settings.harness.json`) → `install-commands.sh` → `doctor.sh`.
  `bootstrap.sh`와 settings 조각은 다른 작업에서 만드는 중이라 이름만 반영했다.
- 자동 점검: SessionStart `session-context.sh`(+`doctor.sh --quiet` 경고), PreToolUse `precommit-check.sh`(커밋 차단), `statusline.sh` → `usage.json` → UserPromptSubmit `usage-check.sh`(80% 경고)
- 실험 트랙(brain-harness 범위만): claude-mem 해마(v14.0.1, 수동 `hippocampus-prune.sh`), task-observer(프로젝트 스킬 + SessionStart 훅, `~/.brain-experiments/task-observer`), 첫 리뷰(세션 5회 또는 1주)
- 기억 vault `~/Brain`: L1 스크립트 · 명령·스킬 원본 · L1 `System/` · L2 `Projects/<이름>` · L3 `Sessions/`·`Agents/`, `/handoff`가 L3 로그를 L2 Handoff로 정리하고 L1 승격 후보를 제안(사람 승인)
- 카드: 읽는 법, 최소조건(필수 macOS·git·jq·Claude Code / 권장 gh·Obsidian / 선택 Codex·Orca·Headroom·ECC·sqlite3), 계층, 작업 흐름·기록, 안전 규칙
- 범례는 색 종류별 의미(작업 도구·스크립트·기록·저장소·안전장치)를 보여 준다.

## 갱신법
구조가 바뀌었을 때(`/handoff`나 정기 점검에서 발견) 아래 순서로 다시 만든다.
1. `brain-harness.architecture.json`을 고친다 (components / boundaries / connections / cards).
2. archify 저장소를 임시 폴더에 clone 한다 (전역 설치 안 함).
   ```sh
   git clone --depth 1 https://github.com/tt-a1i/archify.git /tmp/archify-src/archify
   ```
3. finalize를 돌린다 (업데이트 확인 네트워크 호출은 끈다).
   ```sh
   cd /tmp/archify-src
   ARCHIFY_UPDATE_CHECK_DISABLED=1 node archify/bin/archify.mjs finalize architecture \
     ~/Brain/System/diagrams/brain-harness.architecture.json <출력>.html --quality showcase --json
   ```
   (2026-10-18에는 스크래치 폴더에 clone해 같은 방식으로 돌렸다.)
4. 결과 JSON의 `gates` 4개(`validate` · `deliver` · `check` · `browser-check`)가 모두 `pass`인지 확인한다.
   - 같은 출력 폴더에 이전 `*.browser-check.json`이 남아 있으면 `browser-check`가 "unowned evidence path"로
     실패한다. 옛 파일을 치우고 다시 돌리면 된다.
5. 통과하면 출력 HTML로 `brain-harness.html`을 교체하고, 이 README의 기준일을 고친다.
6. 바뀐 구조가 설계 결정이면 [[System/Decisions]]에도 남긴다.

## 출처·라이선스
- 생성 도구: [archify](https://github.com/tt-a1i/archify) (MIT). 2026-10-17 작업은 커밋 `88d1ae4`, 2026-10-18 작업은 `68be1e0` 기준.
- 사전 점검(2026-10-17): 런타임 의존성 0, 설치 훅 없음, 네트워크는 선택적 업데이트 확인뿐
  (`ARCHIFY_UPDATE_CHECK_DISABLED=1`로 끔). 전역 설치 없이 임시 clone에서 실행했다.
- 추가 경위: [[System/Decisions#2026-10-17 — 브레인 구성도(System/diagrams)와 문서 목차(docs/) 추가]]

## 점검 기록
- 2026-10-18: 구성도 확장(설치·자동 점검·실험 트랙·기억 승격 흐름, 범례·보기·최소조건 카드). finalize 4개 gate(`validate`·`deliver`·`check`·`browser-check`) 모두 pass, HTML 881,297바이트.
  경로 꺾임 13곳은 자동 점검 통과 후 시각 검토 권고(참고)로 남았다.
