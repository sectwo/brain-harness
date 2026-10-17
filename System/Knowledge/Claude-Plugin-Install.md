---
level: 1
summary: "세션 중 설치한 플러그인은 로드 안 됨(완전 재시작 필요) + 한 프로젝트에만 태그 고정 설치(--scope project)"
tags: [knowledge, claude-code, plugin]
source: intratnm 2026-10-01, brain-harness 2026-10-18 (프로젝트 범위 설치)
---
# Claude Code 플러그인은 세션 중 설치해도 로드되지 않는다 — 완전 재시작 필요

## 상황
세션이 떠 있는 동안 플러그인(`ui-ux-pro-max`, `andrej-karpathy-skills`)을 설치했는데, 같은 세션에서
스킬 이름(`ui-ux-pro-max:ui-ux-pro-max`, `ui-ux-pro-max:ui-styling`,
`andrej-karpathy-skills:karpathy-guidelines`)을 정확히 넣어도 계속 `Unknown skill`로 실패했다.

## 원인
`installed_plugins.json`·`settings.json`의 `enabledPlugins`는 정상이었지만, **세션 프로세스가 시작할 때
만든 스킬 레지스트리에는 그 이후에 설치한 플러그인이 반영되지 않는다.**
- `claude plugin disable` → `enable` 토글로 세션 중 재등록을 시도했지만 실패 — 세션 도중에는 새로고침이 안 된다.
- 사용자에게 "이어서 진행해줘"라고 받아도 프로세스가 바뀌지 않아 두 번 더 실패했다.
- 완전히 새 프로세스(`claude -p`)에서는 정상 작동했다.

## 해결
- 플러그인을 설치했으면 **프로세스를 종료(`kill <pid>`)하고 완전히 새로 시작**한다. 재시작 후에야
  새 스킬 레지스트리가 로드된다.
- 설치 직후 로드 여부를 확인하려면 `claude plugin details`(정적 컴포넌트 인벤토리)와 별도의 새
  `claude -p` 프로세스(독립 세션) 두 가지로 본다.
- 참고: 스킬 이름이 Claude 내장 기능(예: "Design" 아티팩트)과 겹치면 Skill 도구가
  `disable-model-invocation`으로 거부할 수 있다 — 플러그인 네임스페이스를 붙인 정확한 이름으로 호출한다.

## 한 프로젝트에만 태그 고정 설치 (`--scope project`)
전역(`~/.claude/settings.json`)을 건드리지 않고 특정 저장소에서만 플러그인을 켜고 싶을 때 (실험 격리 등).
1. `claude plugin marketplace add "https://github.com/<owner>/<repo>.git#<태그>" --scope project`
   → 프로젝트 `.claude/settings.json`의 `extraKnownMarketplaces.<마켓>.source.ref`에 태그가 기록된다.
2. `claude plugin install <plugin>@<마켓> --scope project` → 같은 파일의 `enabledPlugins`에 들어간다.
3. `~/.claude/settings.json`은 바뀌지 않는다 — 설치 전 백업과 diff로 확인한다.
4. 고정 확인: 마켓 클론(`~/.claude/plugins/marketplaces/<마켓>`)에서 `git rev-parse HEAD`가 태그 커밋인지 본다.
   annotated 태그는 `git rev-parse <태그>^{}`의 커밋과 비교한다.
5. 플러그인용 환경 변수(예: 텔레메트리 끔)는 프로젝트 `.claude/settings.json`의 `env`에 넣으면 그 프로젝트에만 적용된다.
6. 동작 확인: 그 프로젝트 폴더에서 연 새 `claude -p` 세션은 훅이 동작하고, 다른 폴더 세션은 동작하지 않아야 한다.
- 주의: 범위가 프로젝트여도 **캐시는 전역**에 생긴다 — `~/.claude/plugins/`(`marketplaces/`, `cache/`)와
  `known_marketplaces.json`에 흔적이 남는다. 되돌릴 때 함께 정리한다.
- 참고(관찰): 저장소 `.claude/skills/<이름>/`에 둔 프로젝트 스킬(task-observer)이 그 세션의 스킬 목록에 나타났다.
  이 세션에서 본 사실만 적는다 — 플러그인과 같은 재시작 규칙이 적용되는지는 확인하지 않았다.
- 사례: claude-mem v14.0.1 — [[Projects/brain-harness/Decisions#2026-10-18 — 실험: claude-mem을 해마(임시 일화 기억)로 — brain-harness만, 2주]]

## 출처
- [[Projects/intratnm/Sessions/2026-10-01-master-claude]] — "홈페이지 리뉴얼 시도" 원인 진단·재시작 기록
- [[Projects/brain-harness/Sessions/2026-10-18-sectwo-하네스-업데이트-자업-claude]] — 프로젝트 범위 설치(claude-mem, task-observer)
- 설치 전 점검 절차와 전역 범위의 태그 고정은 [[System/Knowledge/Plugin-Supply-Chain-Check]]
