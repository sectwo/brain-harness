# 새 PC 설치 가이드

새 Mac(또는 재설치한 PC)에서 이 private 저장소를 clone한 뒤 브레인 하네스를 한 번에 설정한다.
규칙과 명령이 `~/Brain` 경로를 전제하므로 **저장소 위치는 `~/Brain`으로 고정**이다.

## 최소조건
| 구분 | 항목 | 이유 |
|---|---|---|
| 필수 | macOS | 스크립트가 BSD `date -v`, `sed -i ''`를 쓴다 |
| 필수 | git | clone·커밋 |
| 필수 | jq | 훅 4개가 jq 없으면 조용히 꺼진다 |
| 필수 | Claude Code (`claude`) | 하네스의 주 실행 환경 |
| 권장 | gh | push·PR |
| 권장 | Obsidian | 그래프 뷰. vault는 일반 마크다운이라 없어도 동작 |
| 선택 | Codex | 교차 리뷰 |
| 선택 | Orca | worktree 병렬 실행 |
| 선택 | Headroom | 토큰 압축 프록시 |
| 선택 | ECC 플러그인 | 하네스 도구(에이전트·스킬·품질 게이트) |
| 선택 | sqlite3 | 일부 점검·실험 |

버전 하한은 확인된 것이 없어 적지 않는다.

## 설치 단계
1. clone: `git clone <brain-harness 저장소 URL> ~/Brain` (private이라 `gh auth login` 먼저)
2. 확인만 하기: `sh ~/Brain/System/scripts/bootstrap.sh --check`
   최소조건 표와 단계별 상태(OK / 필요)가 나온다. 아무것도 바꾸지 않는다.
3. 실행: `sh ~/Brain/System/scripts/bootstrap.sh`
   필수 도구가 없으면 중단한다. 있으면 아래를 순서대로 하고 한 줄씩 결과를 보여 준다.
   - 바꿀 파일을 `~/.brain-backups/YYYY-MM-DD/bootstrap/`에 백업
   - `~/.claude/CLAUDE.md`에 `@~/Brain/System/Rules.md` 연결 추가 (이미 있으면 그대로)
   - Codex가 있으면 `~/.codex/AGENTS.md`에 Rules 안내 추가 (이미 있으면 그대로)
   - `~/.claude/settings.json`에 하네스 조각([[System/Templates/claude-settings.harness.json]]) 병합:
     statusLine, 훅 3종(SessionStart·UserPromptSubmit·PreToolUse Bash), `additionalDirectories`.
     기존 값은 지우지 않고, 같은 훅이 있으면 중복 추가하지 않는다.
   - `install-commands.sh`로 명령·스킬 설치, `doctor.sh`로 점검
4. Claude Code를 완전히 종료했다가 다시 시작한다 (설정은 시작 때 읽힌다).
5. 확인: 새 세션 시작 맥락에 하네스 요약이 보이고 상태줄이 나오면 된다.
   `sh ~/Brain/System/scripts/doctor.sh`에 `WARN`이 없는지 본다.

여러 번 실행해도 결과는 같다(멱등).

## 선택 도구 설정
bootstrap은 아래를 설치하거나 설정하지 않는다. 필요할 때 [[System/Environment]]의 해당 절을 따른다.
- Codex: [[System/Environment]] Codex 행, 샌드박스는 같은 문서의 "Codex 샌드박스"
- Orca: [[System/Environment]]의 도구와 설정 위치
- Headroom: [[System/Environment]]의 "Headroom"
- ECC: [[System/Environment]]의 "ECC" (채택·제외 목록, `ECC_DISABLED_HOOKS` 같은 env 값 포함).
  조각에는 ECC env를 넣지 않았다. ECC는 선택 항목이다.

## 되돌리기
bootstrap이 바꾼 파일은 실행 전에 `~/.brain-backups/YYYY-MM-DD/bootstrap/`에 복사된다
(`.claude-CLAUDE.md`, `.claude-settings.json`, `.codex-AGENTS.md` 형식 이름).
원래 위치로 복사하면 된다. 예: `cp ~/.brain-backups/2026-10-18/bootstrap/.claude-settings.json ~/.claude/settings.json`
같은 날 다시 실행해도 기존 백업은 덮어쓰지 않아 첫 실행 전 원본이 남는다.

## 문제 해결
- jq 없음: `brew install jq` 후 다시 실행한다. jq가 없으면 훅이 조용히 꺼져 세션 맥락이 안 뜬다.
- 훅·상태줄이 안 뜸: Claude Code를 완전히 재시작했는지 확인하고 `sh ~/Brain/System/scripts/doctor.sh`를 실행한다.
  `~/.claude/settings.json`에 하네스 훅이 있는지는 `bootstrap.sh --check`로 본다.
- `~/Brain이 없다`며 멈춤: 저장소를 `~/Brain`에 clone한다. 다른 위치는 지원하지 않는다.
- settings.json이 올바른 JSON이 아님: bootstrap이 원본을 건드리지 않고 중단한다. 직접 고친 뒤 다시 실행한다.
