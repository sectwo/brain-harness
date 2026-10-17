---
level: 1
summary: "세션 중 설치한 플러그인은 로드 안 됨 — 프로세스 완전 재시작 필요"
tags: [knowledge, claude-code, plugin]
source: intratnm 2026-10-01
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

## 출처
- [[Projects/intratnm/Sessions/2026-10-01-master-claude]] — "홈페이지 리뉴얼 시도" 원인 진단·재시작 기록
- 설치 전 점검 절차는 [[System/Knowledge/Plugin-Supply-Chain-Check]]
