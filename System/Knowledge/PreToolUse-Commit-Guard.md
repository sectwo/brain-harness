---
level: 1
summary: "Claude Code PreToolUse(Bash) 훅으로 에이전트 git commit을 막는 패턴과 함정 6가지 (precommit-check.sh)"
source: brain-harness 2026-10-18
tags: [system, knowledge, claude-code, hook, git]
---
# PreToolUse(Bash) 훅으로 에이전트 커밋 막기

## 언제 쓰나
- 에이전트의 `git commit` 직전에 조건(큰 파일, 빌드 산출물, 대량 미추적 폴더 등)을 검사해 막고 싶을 때.
- 사람 커밋과 저장소별 git hook(husky 등)은 건드리지 않아야 할 때 — 전역 `core.hooksPath` 대신 이 방식을 쓴다.
- 우리 구현: `~/Brain/System/scripts/precommit-check.sh`. 설정 위치·기준값은 [[System/Environment]] (`hooks.PreToolUse`).

## 방법 (훅 계약)
- 훅은 stdin으로 JSON을 받는다. 보는 값은 `.tool_input.command`(실행될 명령)와 `.cwd`.
- **exit 2 + stderr** = 차단. stderr 내용이 모델에 전달되므로 막은 이유와 다음 행동을 거기에 쓴다.
- 판단 불가(jq 없음, git 저장소 아님 등)는 **exit 0으로 통과**시킨다 — 훅 오류로 모든 Bash가 멈추는 것을 막는다.
- 고칠 때마다 회귀 시험: `sh ~/Brain/System/scripts/tests/precommit-check.test.sh` (임시 저장소에서 통과·차단 16건).

## 주의 (실제로 겪은 함정)
1. **명령 실행 전 상태를 본다.** `git reset … && git commit`을 한 명령으로 보내면 reset 전 인덱스로 판단해 막힌다 → 나눠 실행한다.
2. **git 전역 옵션**(`-C "<공백 있는 경로>"`, `-c k=v`, `--no-pager`)이 `git`과 `commit` 사이에 올 수 있다. 단순한
   `git commit` 정규식은 놓친다 (교차 리뷰 "높음" 지적). 옵션 토큰을 넓게 허용하고 오탐은 점검 단계에서 통과시킨다.
3. **우회 토큰은 위치를 본다.** `BRAIN_PRECOMMIT_OK=1`은 명령(또는 `;`·`&&`·`||` 뒤 명령) 맨 앞 환경 변수 할당일 때만 인정한다.
   문자열 포함만 보면 `echo TOKEN; git commit`으로 뚫린다.
4. **`git commit -C HEAD`** 의 `-C`는 메시지 재사용이지 경로가 아니다. 경로로 읽어 저장소가 아니면 `cwd`로 다시 본다.
5. **`-a`/`--all`** 은 인덱스가 아니라 **작업 트리** 크기를 봐야 한다 (수정된 추적 파일이 그대로 들어간다).
6. **출력 압축 프록시**(Headroom)가 긴 시험 출력을 줄이면 결과를 잘못 읽을 수 있다 → 시험 결과를 파일로 받아 `grep FAIL`로 본다.
   [[System/Knowledge/Headroom-Output-Compression]]

## 관련
- [[System/Decisions#2026-10-18 — 3단계① 자동 점검: 세션 시작 doctor·스킬 동기화·커밋 전 차단]] — 도입 이유, 기각한 대안(`core.hooksPath`), 교차 리뷰 결과
- [[System/Environment]] — `~/.claude/settings.json`의 훅 등록과 기준값(5MB·새 파일 300개·산출물 폴더). 여기엔 적지 않는다
