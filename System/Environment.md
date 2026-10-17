---
level: 1
tags: [system, environment]
---
# Environment — 브레인 L1: 시스템 구성과 환경 설정

> 이 PC의 개발 환경 기준 문서. 설정을 바꾸면 여기를 고치고, 이유는 [[System/Decisions]]에 남긴다.

## 구성

    Orca worktree ─┬─ Claude Code ─┐
                   └─ Codex ───────┴(예정, 미적용)─> Headroom 프록시 (127.0.0.1:8787) ─> Anthropic / OpenAI
                         │
                         └─ 읽기/쓰기 ─> ~/Brain (옵시디언 vault)

## 도구와 설정 위치
| 도구 | 역할 | 설정 위치 |
|---|---|---|
| Claude Code | 에이전트 | 전역 `~/.claude/settings.json`, `~/.claude/CLAUDE.md`, `~/.claude/commands/`·`~/.claude/skills/`(설치된 복사본, 원본은 `~/Brain/System/commands/`·`skills/`) / 프로젝트 `.claude/settings.json` |
| Codex CLI | 에이전트 | `~/.codex/config.toml`, `~/.codex/AGENTS.md`. `~/.local/bin/codex` → `/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex` 링크 (ChatGPT 앱 내장, 2026-10-18 기준 codex-cli 0.158.0). ChatGPT 앱 업데이트로 경로가 바뀌면 링크가 끊긴다 — `find /Applications/ChatGPT.app -path '*codex-cli/bin/codex'`로 찾아 `ln -sfn`으로 다시 건다 (2026-10-18, 이전 경로 `Resources/codex`가 사라져 한 번 끊겼음) |
| Orca | worktree·에이전트 실행 | `~/Library/Application Support/orca/profiles/local-default/orca-data.json` |
| Orca가 띄우는 Codex | | `CODEX_HOME=~/Library/Application Support/orca/codex-runtime-home/home` (config.toml, AGENTS.md를 여기서 읽음) |
| Headroom | 프록시 압축 | `headroom proxy` (기본 127.0.0.1:8787), 로그 `~/.headroom/logs/` |
| ECC | 하네스 플러그인 | Claude Code 플러그인 `ecc@ecc` |
| 옵시디언 | 기억 | vault `~/Brain` (System = L1, Projects = L2·L3). 2026-09-25 등록 완료 (`obsidian.json`에 `~/Brain` 등록 확인) |

## Claude Code 전역 설정 (`~/.claude/settings.json`)
- `model: opusplan` — 플랜 모드는 Opus, 실행은 Sonnet (→ [[System/Rules#5. 모델 선택]])
- `statusLine` — `~/Brain/System/scripts/statusline.sh`: 모델, 컨텍스트 %, 5시간·7일 사용량 표시 + `~/.claude/state/usage.json` 기록
- `hooks.SessionStart` — `session-context.sh`: L1 요약 + 프로젝트 맥락 주입
- `hooks.UserPromptSubmit` — `usage-check.sh`: 사용량 80% 이상이면 경고 주입
- `permissions.additionalDirectories` — `~/Brain`
- `enabledPlugins."ecc@ecc"`, `extraKnownMarketplaces.ecc` — ECC 플러그인 설치 출처 (ref `v2.2.3` 고정)
- `skipDangerousModePermissionPrompt: true`, `hooks.SessionStart`에 Orca가 추가한 항목 하나 더 있음 —
  **Orca가 이 파일을 직접 고친다.** 백업에서 복원할 때 Orca 항목이 빠져도 Orca가 다시 넣는다.
  brain-harness에서는 이 파일 전체가 아니라 하네스 조각만 버전 관리한다.
- 백업: `~/.claude/settings.json.pre-harness.bak`

## 프로젝트 연결
- 저장소 루트의 `.harness-project` 파일에 vault 프로젝트 이름을 한 줄로 적는다 (예: `intratnm`).
  공통 스크립트가 이 파일로 `~/Brain/Projects/<이름>/`을 찾는다.
- 새 프로젝트는 `/new-project`로 만든다.

## Headroom
- 프록시는 launchd `com.headroom.default`(`~/Library/LaunchAgents/com.headroom.default.plist`, KeepAlive)가
  로그인 시 자동으로 띄운다. 죽었으면 `launchctl kickstart -k gui/$(id -u)/com.headroom.default`. 점검: `headroom doctor`
- Claude Code: 프로젝트 `.claude/settings.json`의 `env.ANTHROPIC_BASE_URL=http://localhost:8787`
  - 커스텀 base URL이면 1M 컨텍스트가 꺼질 수 있다(headroom#1158). 필요하면 `headroom wrap claude --1m`.
  - 같은 이유로 `/remote-control`(`/rc`)도 비활성화된다(headroom#746). Remote Control이 필요한 세션은 Headroom 없이 실행한다.
- Codex (Orca): **미적용** (2026-09-25 확인: `agentCmdOverrides = {}`, `headroom doctor` → codex not routed).
  목표 값 `agentCmdOverrides.codex = "headroom wrap codex --no-proxy --code-memory none --"`.
  적용 절차와 함정 → [[System/Knowledge/Orca-Codex-Headroom]]
- 확인: `headroom perf`의 Per-Model Breakdown에 해당 모델이 잡히는지
- 메모리 기능(`--memory`)은 쓰지 않는다.
- `headroom doctor`는 예산 미설정("spend unlimited")도 경고한다. 필요하면 `headroom proxy --budget <금액>`.

## Codex 샌드박스
- `writable_roots`는 **터미널에서 직접 띄운 `codex`(sandbox workspace-write 모드)에만** 적용된다.
  현재 등록: `~/Brain/Projects/intratnm` (두 config 모두). 새 프로젝트를 만들면 추가한다.
- **Orca가 띄우는 Codex는 `agentDefaultArgs.codex = --dangerously-bypass-approvals-and-sandbox`로 실행돼
  샌드박스·승인이 모두 꺼진다.** 확인: `orca-data.json`의 `settings.agentDefaultArgs.codex`.
  따라서 L1(`~/Brain/System`) 보호는 기술적으로 강제되지 않으며, 실제 방어선은
  `AGENTS.md`의 "L1은 직접 고치지 않는다"는 텍스트 지시 하나뿐이다.
- Orca가 띄우는 Claude Code도 기본 인수가 `--dangerously-skip-permissions`다(`agentDefaultArgs.claude`).
  Rules 7절의 "확인을 받는다"는 OS 권한 프롬프트가 아니라 에이전트가 사람에게 직접 묻는 절차를 뜻한다.
- 기술적 강제가 필요하면 Orca `agentDefaultArgs.codex`를 `--full-auto`(workspace-write 샌드박스 유지)로
  바꾸는 대안이 있다 (대가: Orca 안에서 승인 프롬프트가 생김). 바꾸기로 하면 [[System/Decisions]]에 기록한다.

## ECC
- 설치는 플러그인 한 가지 방식만 (중복 설치 시 훅 이중 등록). 버전: 2.2.3 (c05b2d6, `extraKnownMarketplaces.ecc.source.ref`=`v2.2.3`로 태그 고정 — [[System/Decisions#2026-10-18 — ECC 2.2.3 적용: 마켓플레이스 ref 태그 고정]])
- 전역 `settings.json`의 `env`로 조정:
  - `GATEGUARD_EXEMPT_GLOBS=/Users/isaac/Brain/**` — vault 문서는 GateGuard 첫 수정 확인을 건너뜀 (파괴적 Bash 확인은 유지)
  - `ECC_DISABLED_HOOKS=pre:observe,stop:evaluate-session` — 자동 학습(instinct) 끔. 옵시디언과 이중 기억 방지
    (ECC 2.2.3 `hooks/hooks.json` 기준 실제 id 2개만 유효. `post:observe:continuous-learning`은 존재하지 않는 id라
    무시된다 — 무해하지만 지운다. 버전을 올리면 `hooks.json`에서 id를 다시 확인)
- GateGuard 대응 → [[System/Knowledge/ECC-GateGuard]]

| 구분 | 스킬·명령 | 쓰는 곳 |
|---|---|---|
| 채택 (L1) | `/harness-audit` | 하네스 구조를 바꾼 뒤 점검 |
| 채택 (L1) | `verification-loop` | 품질 게이트 절차 (Rules 3절) |
| 채택 (L1) | `/cost-report` | 모델별 비용 확인, 모델 하향 판단 근거 (Rules 5절) |
| 후보 (L2, 웹 프로젝트) | `accessibility`, `seo`, `browser-qa`, `frontend-design-direction`, `brand-discovery` | 프로젝트 시작 시 상의 후 채택 |
| 끔 | `continuous-learning-v2` 훅 | 옵시디언과 역할 중복 |
| 안 씀 | `santa-loop`, `council`, `architecture-decision-records`, `knowledge-ops` | 반복 리뷰 비용 / Decisions·옵시디언과 중복 |

## 명령어 설치와 하네스 점검
- 명령 원본(`/handoff`, `/cross-review`, `/new-project`, `/brain-sync`)은 `~/Brain/System/commands/`에, 스킬 원본(`step-choice`)은
  `~/Brain/System/skills/<이름>/`에 있고, `~/Brain/System/scripts/install-commands.sh`가 `~/.claude/commands/`·`~/.claude/skills/`로 단순 복사한다.
  원본을 고쳤으면 이 스크립트를 다시 실행해야 반영된다 (자동으로 안 됨).
- `brain-harness` 저장소 동기화는 `/brain-sync` 명령으로 사람이 원할 때만 한다 (자동 pull 없음, push는 별도 승인).
  → [[System/Rules#2. 기억 저장소 (옵시디언)]]
- `~/Brain/System/scripts/doctor.sh`: 옵시디언 vault 등록, Headroom 프록시, Orca `agentCmdOverrides`/`agentDefaultArgs`,
  git/gh 상태, 명령어 동기화, ECC 훅 id를 한 번에 점검한다. 아무것도 고치지 않고 확인만 한다.

## 매일 쓰는 흐름
1. `headroom doctor`로 프록시 확인 (launchd가 상시 띄워 두므로 보통은 확인만 하면 됨)
2. Orca에서 기능 단위로 worktree 생성 → Claude Code 또는 Codex 실행
3. 시작 맥락 확인 → 계획 확인 → 구현
4. `/cross-review` → 품질 게이트 → 병합
5. `/handoff`로 Handoff 갱신 (+ L1 지식 승격 후보 확인)
