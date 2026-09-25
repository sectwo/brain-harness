---
level: 1
tags: [system, decisions]
---
# Decisions — Level 1 (전역)

> 모든 프로젝트에 영향을 주는 결정. 새 결정은 맨 아래에 추가한다. 형식: 날짜 — 제목 / 결정 / 이유 / 대안
> 이 PC 하네스의 초기 결정(도구 구성, 기억 파일 쓰기 규칙, 세션 맥락 주입, 교차 리뷰)은
> intratnm에서 먼저 정했다 → [[Projects/intratnm/Decisions]]

## 2026-09-25 — 하네스 트리 구조 (L1 → L2 → L3)
- **결정**: 하네스를 L1(PC 전체: 시스템 구성·환경·공통 규칙·공통 지식, `~/Brain/System`) → L2(프로젝트, `~/Brain/Projects/<이름>` + 저장소 AGENTS.md) → L3(에이전트·세션, `Agents/`, `Sessions/`) 트리로 나눈다. 아래 계층은 위를 상속하고, 충돌하면 가까운 계층이 우선한다. 공통 명령(`/handoff`, `/cross-review`, `/new-project`)과 훅·상태줄은 전역(`~/.claude`)에 두고 스크립트 원본은 `~/Brain/System/scripts`에 둔다. 프로젝트는 저장소 루트 `.harness-project`로 vault와 연결한다.
- **이유**: 새 프로젝트마다 하네스를 다시 만들지 않고, 프로젝트에서 얻은 지식을 위로 쌓아 다음 작업에 이어 쓰기 위함 (사람 요청).
- **대안**: 프로젝트마다 하네스 복사 → 규칙이 흩어지고 개선이 전파되지 않아 제외. 스크립트를 `~/.claude/hooks`에 두기 → Codex도 같은 스크립트를 쓰므로 에이전트 중립 위치(vault)에 둠.

## 2026-09-25 — 모델 자동 설정과 사용량 감시
- **결정**: 메인 세션 기본 모델을 `opusplan`으로 둔다(플랜 모드 Opus, 실행 Sonnet). 하위 에이전트·Codex 리뷰 모델은 에이전트가 Rules 표대로 고르고, 바꿀 때마다 사람에게 알린다. 상태줄 스크립트가 5시간·7일 사용량을 `~/.claude/state/usage.json`에 기록하고, 80% 이상이면 UserPromptSubmit 훅이 경고를 넣어 에이전트가 하향을 먼저 제안하게 한다.
- **이유**: 사람이 모델 전환을 신경 쓰지 않으면서도 요금제 안에서 쓰기 위함 (사람 요청: 직접 설정하되 변경·사용량 이슈는 알릴 것).
- **대안**: 매번 사람이 `/model` → 번거롭고 잊기 쉬움. 세션 중 에이전트가 메인 모델 변경 → Claude Code에서 불가.
- **한계**: `rate_limits`는 claude.ai Pro/Max 구독에서만 상태줄에 들어온다. Codex 사용량은 감시하지 못한다.

## 2026-09-25 — ECC 스킬 채택 범위
- **결정**: L1에 `/harness-audit`(하네스 점검), `verification-loop`(품질 게이트 절차), `/cost-report`(모델 하향 판단 근거)를 채택한다. continuous-learning-v2 자동 학습 훅(`pre:observe`, `post:observe:continuous-learning`, `stop:evaluate-session`)은 `ECC_DISABLED_HOOKS`로 끈다. GateGuard는 `GATEGUARD_EXEMPT_GLOBS=/Users/isaac/Brain/**`로 vault 문서만 예외로 둔다. 웹 관련 스킬(accessibility, seo, browser-qa 등)은 프로젝트(L2) 시작 시 상의해 채택한다.
- **이유**: 하네스 점검·검증·비용 확인은 모든 프로젝트에 쓰인다. 자동 학습은 옵시디언과 기억이 이중화된다. GateGuard의 첫 수정 확인은 코드에는 유용하지만 vault 문서에는 의미가 없고 작업을 반복해서 멈춘다 (사람 결정).
- **대안**: GateGuard 전체 끄기(`ECC_GATEGUARD=off`) → 코드 파일과 파괴적 명령 확인까지 사라져 제외. 학습 결과를 승격 후보로 참고 → 두 기억을 대조하는 비용이 커서 제외.
- **정정(2026-09-25, 2차 Fable 리뷰)**: `post:observe:continuous-learning`은 ECC 2.2.2 `hooks/hooks.json`에 없는 id라 실제로는 무시된다. 진짜로 꺼지는 건 `pre:observe`, `stop:evaluate-session` 두 개뿐. `Environment.md`와 `~/.claude/settings.json`의 `ECC_DISABLED_HOOKS` 값에서 존재하지 않는 id를 지운다.

## 2026-09-25 — 2차 Fable 리뷰: 문서-실제 상태 불일치 정정
- **결정**: 세션이 비정상 종료된 뒤 Fable 모델로 하네스 상태를 재검증했고, 아래 3가지를 "이미 됐다"처럼 써놓았던 문서를 실제 상태로 고친다.
  1. `~/Brain`은 옵시디언 vault로 등록된 적이 없다(`obsidian.json`에 `~/Documents/Obsidian Vault`만 있고 `~/Brain/.obsidian`이 없음). 이전 세션 로그의 "보관함 열기 완료" 기록은 사실이 아니었다 — 정정함.
  2. Orca `agentCmdOverrides.codex`는 여전히 미적용(`{}`)이라 Codex는 아직 Headroom을 거치지 않는다.
  3. Orca가 띄우는 Codex는 `agentDefaultArgs.codex = --dangerously-bypass-approvals-and-sandbox`로 실행되어 `writable_roots` 샌드박스 설정이 무력화된다. L1 보호는 `AGENTS.md` 텍스트 지시 하나뿐이며 기술적으로 강제되지 않는다.
- **이유**: 하네스 문서가 원하는 상태를 이미 이루어진 사실처럼 적어 두면 다음 세션(사람이든 에이전트든)이 잘못된 전제로 작업하게 된다. 사실과 다른 문서는 "미적용/예정"으로 명시한다 (사람 요청: 다시 검증하고 다듬은 뒤 진행).
- **대안**: 그냥 넘어가고 Orca 문제만 먼저 해결 → 다음 세션도 같은 착각을 반복할 위험이 있어 기각.
- **전제조건 이행 완료 (2026-09-25)**: ~~옵시디언에서 `~/Brain` vault 등록~~ 완료 → ~~`git config --global`~~ 완료 (`임이삭 <misofamily@gmail.com>`) → ~~`gh auth login`~~ 완료 (계정 `sectwo`) → 저장소 범위는 `~/Brain` 전체 하나로 결정, **private**로 생성 → `git init` + 첫 커밋(`0097884`) + `gh repo create brain-harness --private --push` 완료. 원격: `https://github.com/sectwo/brain-harness`.
- **남은 설계 항목 (1차 Fable 리뷰) 반영 완료 (2026-09-25, 커밋 `4d2dc39`)**:
  - ~~SessionStart 자동 `git pull` 금지, 수동 동기화 명령으로 대체~~ → `/brain-sync` 추가 (사람이 실행할 때만 fast-forward pull, push는 안 함)
  - ~~커밋은 자유, push는 매번 사람 승인~~ → `Rules.md` 2절에 명시
  - ~~`~/.claude/commands/*.md` 원본을 vault로~~ → `~/Brain/System/commands/`가 원본, `install-commands.sh`로 복사 설치 (심링크는 Claude Code 지원 여부 미검증이라 복사 방식 채택)
  - ~~`scripts/doctor.sh` 추가~~ → 완료, 실행 확인함 (옵시디언/Headroom/Orca/git·gh/명령 동기화/ECC 훅 점검)
  - **미완료**: `~/.claude/settings.json`의 `ECC_DISABLED_HOOKS`에서 존재하지 않는 훅 id 제거는 Claude Code 자체 설정 파일 Bash 접근이 "Self-Modification" 분류로 자동 차단되어 못 함 (읽기도 막힘). 사람이 직접 지우거나 권한을 열어줘야 한다. 값은 여전히 `pre:observe,post:observe:continuous-learning,stop:evaluate-session` — 무해하지만 지워야 할 것은 `,post:observe:continuous-learning`.
- **다음**: Orca `agentCmdOverrides.codex` 적용 (⌘Q 정상 종료 후 `orca-data.json` 수정) → 이번 커밋들 push(사람 승인 필요, 아직 안 함).

## 2026-09-25 — "브레인 하네스"로 명명, 확장 원칙과 정기 점검
- **결정**: 이 하네스 체계를 **브레인(Brain) 하네스**로 부른다. 사람의 뇌처럼 계층을 나누고, 계층 수·구성은 고정하지 않고 필요하면 확장한다. 최상위 브레인(L1)에서 `Reviews.md`의 주기(기본 30일)마다 최신의 효율적이고 검증된 방법을 조사해 후보로 정리하고, 사람과 상의한 뒤에만 적용한다. 주기가 지나면 세션 시작 맥락이 알린다.
- **이유**: 하네스를 한 번 만들고 끝내지 않고 계속 좋아지게 하되, 검증 안 된 유행을 무분별하게 들이지 않기 위함 (사람 요청).
- **대안**: 필요할 때만 수동 점검 → 잊기 쉬움. 자동 적용 → 검증·상의 없이 전역 설정이 바뀌어 제외.
