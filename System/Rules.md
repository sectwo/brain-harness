---
level: 1
tags: [system, rules]
---
# Rules — Level 1 공통 규칙 (브레인 하네스)

> 이 PC의 모든 프로젝트·에이전트(Claude Code, Codex)가 따르는 **최상위 규칙**이다.
> 이 하네스 전체를 우리는 **브레인(Brain) 하네스**라고 부른다. 사람의 뇌처럼 계층으로 나뉘고,
> 언제든 바뀌고 넓어질 수 있다. 사람과 에이전트가 함께 설계해 나간다.
> Claude Code는 `~/.claude/CLAUDE.md`, Codex는 `~/.codex/AGENTS.md`와 각 프로젝트 `AGENTS.md`를 통해 읽는다.
> 규칙을 바꿀 때는 이 파일만 고치고, 바꾼 이유를 [[System/Decisions]]에 남긴다.

## 1. 하네스 트리
하네스는 트리 구조다. 아래 계층은 위를 **상속**하고 필요한 것만 덧붙이거나 덮어쓴다.
충돌하면 가까운 계층이 우선한다 (L3 > L2 > L1).

```
L1  전역(Global)  ~/Brain/System/            시스템 구성, 환경 설정, 공통 규칙, 공통 지식
└─ L2  프로젝트   ~/Brain/Projects/<이름>/   + 저장소 AGENTS.md (프로젝트 고유 규칙·지식)
   └─ L3  에이전트·세션  Projects/<이름>/Agents/, Sessions/  (에이전트별 특이점, 세션 로그)
```

| 계층 | 파일 | 용도 |
|---|---|---|
| L1 | `Rules.md` | 이 파일. 공통 규칙 |
| L1 | `Environment.md` | 시스템 구성과 환경 설정 (도구, 경로, 포트, 설정 파일 위치) |
| L1 | `Decisions.md` | 전역 결정 기록 |
| L1 | `Projects.md` | 프로젝트 목록과 상태 (트리 전체 지도) |
| L1 | `Reviews.md` | 브레인 정기 점검 주기와 기록 |
| L1 | `Knowledge/` | 프로젝트를 넘어 쓰는 지식 (도구 사용법, 문제 해결, 패턴) |
| L1 | `Templates/Project/` | 새 프로젝트용 vault 틀 (`/new-project`가 사용) |
| L1 | `scripts/` | 공통 훅·상태줄·점검 스크립트 (`install-commands.sh`, `doctor.sh` 포함) |
| L1 | `commands/` | 공통 명령 **원본** (`/handoff`, `/cross-review`, `/new-project`, `/brain-sync`). Claude 전용 |
| L2 | `Overview.md` | 요구사항, 기술 스택, 구조. 사람이 작성 |
| L2 | `Decisions.md` | 프로젝트 결정 기록 |
| L2 | `Handoff.md` | 현재 상태, 다음 할 일. `/handoff`로만 갱신 |
| L2 | `Knowledge/` | 이 프로젝트에서만 쓰는 지식 |
| L3 | `Agents/Claude.md`, `Agents/Codex.md` | 이 프로젝트에서 에이전트별 역할·설정·알게 된 특이점 |
| L3 | `Sessions/` | 세션별 작업 로그. 각 에이전트는 자기 파일만 쓴다 |

**어디에 둘지 판단**: 새 규칙·설정·지식은 "다른 프로젝트에도 쓰이나?"로 정한다.
쓰이면 L1, 이 프로젝트만이면 L2, 특정 에이전트·세션에만 해당하면 L3.

**지식 올리기 (아래 → 위)**
- L3 세션 로그 → `/handoff` 때 L2(Handoff, Decisions, Knowledge)로 정리한다.
- L2에서 다른 프로젝트에도 쓸 만한 것은 `/handoff`가 **L1 `Knowledge/` 승격 후보**로 제안하고,
  사람이 승인한 것만 올린다. 올린 뒤 L2에는 링크만 남긴다(중복 금지).

**확장**: 계층 수와 구성은 고정이 아니다. 새 계층·영역(예: 도메인별 지식, 팀, 장비)이 필요하면
계획을 보여 주고 사람 확인을 받아 추가하고, [[System/Decisions]]에 남긴다.

**정기 점검 (최상위 브레인)**: [[System/Reviews]]의 주기마다 최신 트렌드 중 **효율적이고 검증된** 방법
(에이전트 하네스, 기억 구조, 모델 운용, 도구)을 조사해 지금 브레인과 비교한다.
- 검증 기준: 공식 문서·재현 가능한 결과·실사용 사례가 있는 것만. 유행만 하는 것은 거른다.
- 결과는 후보 목록(효과, 비용, 위험, 적용 계층)으로 정리해 **사람과 상의한 뒤에만** 적용한다.
- 주기가 지나면 세션 시작 맥락에 알림이 뜬다. 에이전트는 사람에게 점검을 제안한다(바로 진행하지 않는다).

## 2. 기억 저장소 (옵시디언)
- 기억의 기준(source of truth)은 옵시디언 vault `~/Brain`이다.
- ECC·Headroom 등 다른 도구의 기억과 다르면 **옵시디언이 우선**이다. Headroom 메모리 기능은 쓰지 않는다.

**작업 시작 전**
1. 세션 시작 맥락을 읽는다. Claude Code는 SessionStart 훅이 자동으로 넣는다.
   Codex는 `sh ~/Brain/System/scripts/session-context.sh`를 직접 실행한다.
   (L1 요약 + 프로젝트 Handoff 이후 세션 로그 + 현재 worktree 상태가 나온다)
2. 프로젝트 `Handoff.md`, `Overview.md`를 읽는다. Handoff와 세션 로그가 다르면 더 최근 로그를 따른다.
3. 설계에 영향을 주는 작업이면 해당 계층의 `Decisions.md`도 읽는다.

**작업 중**
- 설계 결정을 내리면 해당 계층의 `Decisions.md` 맨 아래에 추가한다.
  형식: `## YYYY-MM-DD — 결정 제목` / 결정 / 이유 / 대안
  (Codex가 L1에 해당하는 결정을 내렸으면 직접 쓰지 않고 세션 로그에 제안만 남긴다 — 아래 7절)

**작업 종료 전**
- `Sessions/YYYY-MM-DD-<worktree명>-<claude|codex>.md`에 **자기 세션 로그만** 쓴다.
  `<worktree명>`은 현재 git 브랜치 이름. 같은 날 같은 파일이 있으면 이어서 쓴다.
- `Handoff.md`는 직접 고치지 않는다. `/handoff`로 한 번에 갱신한다
  (여러 worktree 에이전트가 같은 파일을 동시에 덮어쓰는 것을 막기 위함).

**원격 저장소 (`brain-harness`, private, `github.com/sectwo/brain-harness`)**
- **세션 시작 시 자동으로 `git pull`하지 않는다.** 동기화는 사람이 `/brain-sync`를 실행했을 때만 한다
  (fast-forward만 허용, merge/rebase로 히스토리를 바꾸지 않는다).
- **커밋은 자유롭게 한다.** 의미 있는 단위로 로컬 커밋을 남기는 것은 승인 없이 해도 된다.
- **`git push`는 매번 사람이 명시적으로 승인한 뒤에만 한다.** `/brain-sync`도 push는 하지 않는다.
- `/brain-sync`로 원격의 새 커밋을 받았고 그 안에 `System/commands/*.md` 변경이 있으면
  `~/Brain/System/scripts/install-commands.sh`로 `~/.claude/commands/`에 반영한다 (아래 "명령 원본" 참고).

**명령 원본과 설치**
- `~/.claude/commands/*.md`는 Claude Code가 실제로 읽는 위치이지만 **버전 관리 대상이 아니다.**
  진짜 원본은 `~/Brain/System/commands/*.md`(vault, git 추적됨)이고, `install-commands.sh`가
  단순 복사로 반영한다 (심링크가 아닌 이유: Claude Code가 심링크된 명령 파일을 읽는지 검증 전이라
  실패 시 명령이 통째로 사라지는 위험을 피하기 위함).
- 명령 내용을 고칠 때는 **`~/Brain/System/commands/`의 원본을 고치고** `install-commands.sh`를 실행한다.
  `~/.claude/commands/`를 직접 고치면 다음 pull/install 때 덮어써진다.

## 3. 작업 워크플로우
모든 기능은 아래 순서를 따른다. **Orca에서 기능 하나당 worktree 하나.**
1. **계획**: 구현 전에 계획을 세우고 사람 확인을 받는다. 계획은 세션 로그에 남긴다.
2. **구현**: 해당 worktree 안에서만 작업한다. 다른 worktree 파일은 건드리지 않는다.
3. **교차 리뷰**: 아래 4절. `/cross-review`·`/handoff`·`/new-project`는 Claude Code에서만 실행한다.
   Codex가 구현한 worktree는 Claude 세션을 열어 `/cross-review`를 돌린다. Codex는 세션 로그만 남긴다.
4. **품질 게이트**: 빌드 성공, 린트·타입 오류 없음 + 프로젝트 `AGENTS.md`의 추가 게이트.
   ECC `verification-loop` 스킬 절차(빌드 → 타입 → 린트 → 테스트 → 보안 → diff 점검)로 확인하고 결과를 세션 로그에 남긴다.
5. **핸드오프**: 세션 로그를 쓰고 종료한다.

## 4. 교차 리뷰
구현한 에이전트가 아닌 다른 에이전트가 diff를 리뷰한다 (Claude ↔ Codex). 실행은 `/cross-review`.
**리뷰 전에는 반드시 사람에게 알리고** 변경 규모(파일 수, 추가·삭제 줄)와 추천 강도를 보여 준 뒤,
사람이 고른 강도로만 진행한다. 전체 저장소가 아니라 diff 중심으로 본다.

| 강도 | 추천 상황 | 보는 범위 | Claude 리뷰어 | Codex 리뷰어 |
|---|---|---|---|---|
| 건너뛰기 | 문구·스타일 등 동작이 안 바뀌는 수정 | - | - | - |
| 가벼움 | diff 100줄 미만 | diff만. 치명적 문제만 | Haiku / Sonnet | `gpt-5.6-luna`, 추론 low |
| 표준 | diff 100~500줄, 새 섹션·페이지 | diff + 직접 관련 파일. 버그 + 품질 게이트 | Sonnet | `gpt-5.6-terra`, 추론 medium |
| 심층 | 500줄 이상, 구조 변경, 배포 직전 | 기능 전체 맥락 | Opus | `gpt-5.6-sol`, 추론 high |

- 심각도(치명 / 높음 / 참고)를 붙인다. 가벼움·표준에서 "참고"는 5개 이내.
- 재리뷰는 **1회까지**. 더 필요하면 다시 사람에게 묻는다.
- 결과(강도, 모델, 주요 지적, 반영 여부)는 세션 로그에 남긴다.

## 5. 모델 선택
| 작업 | Claude | Codex |
|---|---|---|
| 계획, 구조 설계, 심층 리뷰 | Opus | `gpt-5.6-sol`, 추론 high |
| 일반 구현, 표준 리뷰 | Sonnet | `gpt-5.6-terra`, 추론 medium |
| 단순 수정, 탐색, 가벼운 리뷰 | Haiku / Sonnet | `gpt-5.6-luna`, 추론 low |

- **에이전트가 직접 고른다.** 하위 에이전트의 `model`, Codex 실행의 모델·추론 강도
  (`codex exec -m`, `codex review -c model=… -c model_reasoning_effort=…`)처럼 고를 수 있는 곳은 위 표대로 에이전트가 정한다.
- **메인 세션**은 전역 설정 `"model": "opusplan"`으로 자동 전환한다. 플랜 모드(Shift+Tab)에서는 Opus, 실행 중에는 Sonnet.
  에이전트는 세션 도중 메인 모델을 직접 바꿀 수 없다. 더 필요하면 `/model <이름>`을 사람에게 권한다.
- **바꿀 때마다 알린다.** 어떤 작업을 어떤 모델로 돌리는지와 이유를 한 줄로 말한다.
- **남은 사용량 때문에 바꿔야 하면 바꾸기 전에 먼저 말한다.** 사용량은 상태줄 스크립트가
  `~/.claude/state/usage.json`에 기록하고, 5시간·7일 사용량이 기준(80%)을 넘으면 프롬프트마다 경고가 들어온다.
  경고가 오면 비싼 모델은 판단이 어려운 곳에만 쓰고, 하향(Opus → Sonnet → Haiku)을 사람에게 제안한다.
  모델별 누적 비용은 ECC `/cost-report`(`~/.claude/metrics/costs.jsonl`)로 확인해 판단 근거로 쓴다.
- Codex 모델 이름은 바뀔 수 있다. 실행이 실패하면 `codex debug models`로 목록을 확인하고 이 표를 고친다.

## 6. 도구 역할
- **ECC**: 하네스 도구 (에이전트, 스킬, 명령, 훅, 품질 게이트). 채택·제외 목록은 [[System/Environment#ECC]]
  - 기억·학습 기능(continuous-learning instinct)은 끈다. 기억은 옵시디언 하나로 관리한다.
- **옵시디언**: 기억과 결정의 기준
- **Headroom**: 프록시 토큰 압축 전용 (메모리 기능 안 씀)
- **Orca**: worktree와 에이전트 병렬 실행
- 설정 위치와 방법은 [[System/Environment]].

## 7. 공통 코드·작업 규칙
- 비밀 값은 코드에 쓰지 않고 환경 변수로 관리한다. `.env`는 커밋하지 않는다.
- 사실 정보(회사 정보, 수치, 연락처 등)는 **절대 지어내지 않는다.** 모르면 `TODO(확인 필요)`로 표시하고 세션 로그 "막힌 점"에 적는다.
- 큰 변경, 되돌리기 어려운 작업, **L1(전역: `~/Brain/System`, `~/.claude`, `~/.codex`) 변경**은
  **Claude Code 세션에서** 계획을 먼저 보여 주고 확인을 받은 뒤 한다. 바꾸기 전에 백업한다.
  **Codex는 L1을 직접 고치지 않고** 세션 로그 "다음 할 일"에 제안으로만 남긴다.
