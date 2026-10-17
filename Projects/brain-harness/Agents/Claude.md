---
project: brain-harness
agent: claude
tags: [brain-harness, agent]
---
# Claude — brain-harness (L3)

> 이 프로젝트에서  역할, 설정, 알게 된 특이점. 공통 설정은 [[System/Environment]].

## 역할
- 메인 세션(Opus)이 로드맵 설계·적용과 vault 기록을 맡는다. 상세 설계는 Fable 하위 에이전트, 세션 로그는 Sonnet 하위 에이전트.
- `/handoff`·`/cross-review`·`/new-project`·`/brain-sync`는 이 에이전트만 실행한다.

## 설정
- 명령·스킬 원본은 `System/commands/`·`System/skills/`. 고친 뒤 `install-commands.sh`로 `~/.claude/`에 복사한다.

## 알게 된 점
- vault 커밋에 다른 프로젝트의 미추적 자료 폴더가 섞일 수 있다. 커밋 전 `git status`로 untracked를 확인한다 (자료 폴더는 .gitignore 처리됨).
