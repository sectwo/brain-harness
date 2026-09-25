---
level: 1
tags: [knowledge, orca, codex, headroom]
source: intratnm 2026-09-25
---
# Orca에서 띄우는 Codex를 Headroom으로 보내기

## 핵심
- Orca는 에이전트 실행 명령을 `orca-data.json`의 `settings.agentCmdOverrides`(에이전트 id → 명령 문자열)로 덮어쓴다.
  Codex는 `agentCmdOverrides.codex`.
- 넣을 값: `headroom wrap codex --no-proxy --code-memory none --`
  - `--no-proxy`: 이미 떠 있는 프록시 사용
  - `--code-memory none`: Serena MCP 등록 안 함
  - 끝의 `--`: Orca가 뒤에 붙이는 `--dangerously-bypass-approvals-and-sandbox`(`agentDefaultArgs.codex`)나 `resume` 인수가 headroom이 아니라 codex로 넘어가게 함
- Orca가 띄우는 Codex는 `CODEX_HOME=~/Library/Application Support/orca/codex-runtime-home/home`을 쓴다.
  `~/.codex/config.toml`만 고치면 적용되지 않는다. 두 곳 다 고친다.

## 함정
- Orca는 설정을 메모리에 들고 있어서, **실행 중에 `orca-data.json`을 고치면 무시되거나 덮어써진다.**
  Orca를 완전히 종료(⌘Q)한 뒤 고친다. Orca 안에서 돌던 에이전트 세션도 같이 끝난다.
- 설정 화면에서 넣었는데도 `agentCmdOverrides`가 `{}`로 남은 적이 있다. 저장 뒤 파일로 반드시 확인한다:
  `python3 -c "import json;print(json.load(open('<orca-data.json>'))['settings']['agentCmdOverrides'])"`
- 새 Codex 탭부터 적용된다. 확인은 `headroom perf`에 gpt 모델이 잡히는지.
- **`kill`로 하나만 죽이면 재기동된다.** Orca 메인 앱(부모, ppid 1)이 데몬(자식, `--spawner-exec-path`로
  자신을 다시 띄울 수 있음)을 물고 있는 부모-자식 구조라, 하나만 죽이면 1~2분 안에 서로 다시 살리는
  핑퐁이 일어난다. 터미널 `kill`/`pkill` 대신 **Orca 앱에서 직접 ⌘Q(정상 종료)**를 쓴다 — 그래야 설정이
  파일에 flush되고 데몬도 같이 정리된다.
- **Orca와 무관하게 먼저 검증하는 법**: Orca 설정을 건드리기 전에 터미널에서 아래처럼 실행해서
  "Headroom 경유가 되느냐"와 "Orca 설정을 어떻게 넣느냐"를 분리해서 확인할 수 있다.
  ```
  CODEX_HOME="$HOME/Library/Application Support/orca/codex-runtime-home/home" \
    headroom wrap codex --no-proxy --code-memory none -- exec "reply ok"
  ```
  이후 `headroom perf`에 gpt 모델이 잡히면 Headroom 경유 자체는 문제없다는 뜻이고, 남은 문제는
  Orca에 이 명령을 어떻게 물리느냐로 좁혀진다.
- `headroom wrap codex`는 실행할 때마다(모델 목록 조회 포함) 대상 Codex의 `config.toml`에
  `[mcp_servers.headroom]`을 자동 등록한다. 원치 않으면 `--no-mcp`를 붙인다.
- ChatGPT 로그인 방식 Codex가 `OPENAI_BASE_URL`을 실제로 따르는지는 `TODO(확인 필요)` —
  위 터미널 검증으로 직접 확인한다.
