---
level: 1
tags: [system, diagrams]
---
# diagrams — 브레인 구성도

> 브레인 하네스 전체 구조를 한 장으로 보는 구성도. 기준일 **2026-10-17**.
> 규칙의 원문은 [[System/Rules]]이고, 이 그림은 그 규칙을 그린 것이다. 둘이 다르면 Rules.md가 맞다.

## 파일
| 파일 | 용도 |
|---|---|
| `brain-harness.html` | 구성도 본체. 단독 실행되는 인터랙티브 HTML(약 840KB). 외부 의존성 없음 |
| `brain-harness.architecture.json` | archify 원본 명세. 구성도를 고칠 때는 이 파일을 고치고 HTML을 다시 만든다 |

## 보는 법
- 로컬: `brain-harness.html`을 브라우저로 연다 (`open ~/Brain/System/diagrams/brain-harness.html`).
- GitHub 웹에서는 HTML이 소스 코드로만 보인다. 내려받아서(Raw → 저장) 브라우저로 열어야 한다.

## 담긴 구성요소
- 사람(사용자) — 계획 승인, push 승인
- Orca — 기능당 worktree 1개
- Claude Code — 메인 세션(Opus 5.5), vault 기록은 Fable
- Headroom 프록시 — `localhost:8787`, 토큰 압축
- Anthropic API — 모델 호출
- Codex — 교차 리뷰(read-only)
- intra-tnm 저장소 — Next.js 홈페이지 코드
- GitHub — private 저장소 2개(코드, 브레인 vault). push는 매번 승인
- 옵시디언 vault `~/Brain` 안:
  - L1 스크립트 (`System/scripts/`: session-context, usage-check 등 훅·상태줄)
  - 명령 원본 (`System/commands/`: handoff, cross-review 등, `install-commands.sh`로 설치)
  - L1 `System/` (Rules · Decisions · Knowledge)
  - L2 `Projects/intratnm` (Overview · Handoff · Decisions)
  - L3 `Sessions/` · `Agents/` (에이전트별 세션 로그·특이점)

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
4. 결과 JSON의 `gates` 4개(`validate` · `deliver` · `check` · `browser-check`)가 모두 `pass`인지 확인한다.
   - 같은 출력 폴더에 이전 `*.browser-check.json`이 남아 있으면 `browser-check`가 "unowned evidence path"로
     실패한다. 옛 파일을 치우고 다시 돌리면 된다.
5. 통과하면 출력 HTML로 `brain-harness.html`을 교체하고, 이 README의 기준일을 고친다.
6. 바뀐 구조가 설계 결정이면 [[System/Decisions]]에도 남긴다.

## 출처·라이선스
- 생성 도구: [archify](https://github.com/tt-a1i/archify) (MIT). 2026-10-17 작업은 커밋 `88d1ae4` 기준.
- 사전 점검(2026-10-17): 런타임 의존성 0, 설치 훅 없음, 네트워크는 선택적 업데이트 확인뿐
  (`ARCHIFY_UPDATE_CHECK_DISABLED=1`로 끔). 전역 설치 없이 임시 clone에서 실행했다.
- 추가 경위: [[System/Decisions#2026-10-17 — 브레인 구성도(System/diagrams)와 문서 목차(docs/) 추가]]
