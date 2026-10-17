# 브레인 하네스 사용자 가이드

> 브레인 하네스를 설치해 쓰는 사람을 위한 안내서다. 왜 이렇게 설계했는지는 [루트 README](../README.md),
> 설치 단계의 자세한 내용은 [setup.md](./setup.md), 규칙의 원문은 [Rules](../System/Rules.md)를 본다. 둘이 다르면 Rules가 맞다.

## 1. 최소조건

저장소 위치는 **`~/Brain` 고정**이다 (스크립트와 설정이 이 경로를 가정한다).

| 구분 | 도구 | 이유 |
|---|---|---|
| 필수 | macOS | 스크립트가 BSD `date -v`, `sed -i ''`를 쓴다 |
| 필수 | git | vault와 이력 관리 |
| 필수 | jq | 훅 4개가 jq가 없으면 조용히 꺼진다 (오류 없이 동작만 안 한다) |
| 필수 | Claude Code | 명령·스킬·훅이 Claude Code 기준이다 |
| 권장 | gh | push·PR |
| 권장 | Obsidian | 그래프 뷰. vault는 일반 마크다운이라 없어도 동작한다 |
| 선택 | Codex | 교차 리뷰 |
| 선택 | Orca | worktree 병렬 실행 |
| 선택 | Headroom | 토큰 압축 프록시 |
| 선택 | ECC 플러그인 | 품질 게이트 스킬 등 ([Environment](../System/Environment.md)) |
| 선택 | sqlite3 | `hippocampus-prune.sh` 등 실험 도구 |

## 2. 빠른 시작

```sh
git clone <brain-harness 저장소> ~/Brain
sh ~/Brain/System/scripts/bootstrap.sh --check   # 먼저 점검만
sh ~/Brain/System/scripts/bootstrap.sh           # 설치
```

그다음 Claude Code를 재시작한다. 세션 시작 때 하네스 맥락(L1 요약, worktree 상태 등)이 보이면 성공이다.
자세한 단계는 [setup.md](./setup.md)를 본다.

## 3. 하루 작업 흐름

기능 하나당 Orca worktree 하나. 순서는 [Rules 3절](../System/Rules.md)을 따른다.

1. **시작**: 세션 시작 맥락과 프로젝트 `Handoff.md`를 읽는다.
2. **계획**: 구현 전에 계획을 세우고 사람 확인을 받는다. 계획은 세션 로그에 남긴다.
3. **구현**: 해당 worktree 안에서만 작업한다.
4. **교차 리뷰**: 구현하지 않은 쪽 에이전트가 diff를 본다 (`/cross-review`).
5. **품질 게이트**: 빌드·타입·린트·테스트 등을 확인하고 결과를 세션 로그에 남긴다.
6. **핸드오프**: 세션 로그를 쓰고 종료한다. 기능을 master(main)에 병합하면 `/handoff` 후 **새 세션**을 시작한다.

### 세션이 시작할 때 읽는 것
- 시작 맥락: Claude Code는 SessionStart 훅이 `session-context.sh`로 자동 주입한다.
  Codex는 `sh ~/Brain/System/scripts/session-context.sh --handoff`를 직접 실행한다.
  내용은 L1 요약, 현재 worktree 상태, 색인(Overview 절 제목·결정·지식·세션 로그 요약), 마지막 `/handoff` 이후의 세션 로그다.
- 프로젝트 `Handoff.md`는 읽는다. `Overview.md`는 색인에서 필요한 절만 찾아 읽는다.
- Handoff와 세션 로그가 다르면 더 최근 로그를 따른다. 설계에 영향을 주는 작업이면 `Decisions.md`도 읽는다.

### 모델 선택 ([Rules 5절](../System/Rules.md))
| 작업 | Claude | Codex |
|---|---|---|
| 상세설계, 정말 중요한 설계 | Fable (쓰기 전에 사람에게 묻는다) | `gpt-5.6-sol`, 추론 high |
| 계획, 구조 설계, 심층 리뷰 | Opus | `gpt-5.6-sol`, 추론 high |
| 일반 구현, 표준 리뷰 | Sonnet | `gpt-5.6-terra`, 추론 medium |
| 단순 수정, 탐색, 가벼운 리뷰 | Haiku / Sonnet | `gpt-5.6-luna`, 추론 low |

에이전트가 위 표대로 직접 고르고, 모델을 바꿀 때마다 이유를 한 줄로 알린다. 메인 세션 모델 변경은 사람이 `/model`로 한다.
Codex 모델 이름은 바뀔 수 있다. 실행이 실패하면 `codex debug models`로 목록을 확인한다.

## 4. 명령·스킬

명령 원본은 [System/commands/](../System/commands/), 스킬 원본은 [System/skills/](../System/skills/)에 있다.

| 이름 | 언제 쓰나 | 주의 |
|---|---|---|
| `/new-project` | 새 프로젝트 vault(L2·L3)와 저장소 연결 파일을 만들 때 | 계획을 보여 주고 확인받는다. 이미 있는 프로젝트는 덮어쓰지 않는다 |
| `/handoff` | 세션 끝, 또는 기능 병합 후 | `Handoff.md`는 이 명령으로만 갱신한다. L1 승격 후보는 사람이 승인한 것만 올린다 |
| `/cross-review` | 구현을 마친 뒤 diff 리뷰 | 실행 전에 변경 규모와 추천 강도를 보여 주고 사람이 강도를 고른다. 재리뷰는 1회까지 |
| `/brain-sync` | 원격의 새 커밋을 받고 싶을 때 | 사람이 실행할 때만 fast-forward pull. push는 하지 않는다 |
| `step-choice` (스킬) | 사람이 고를 것이 있을 때 | 방향키 선택 창으로 한 번에 하나씩 묻고, 선택지마다 설명·추천을 붙인다 |

`/cross-review`, `/handoff`, `/new-project`, `/brain-sync`는 Claude Code에서만 실행한다.

**교차 리뷰 강도** ([Rules 4절](../System/Rules.md))

| 강도 | 추천 상황 | 보는 범위 |
|---|---|---|
| 건너뛰기 | 문구·스타일 등 동작이 안 바뀌는 수정 | - |
| 가벼움 | diff 100줄 미만 | diff만, 치명적 문제만 |
| 표준 | diff 100~500줄, 새 섹션·페이지 | diff + 직접 관련 파일 |
| 심층 | 500줄 이상, 구조 변경, 배포 직전 | 기능 전체 맥락 |

표준·심층은 6관점 점검표(버그, 보안, 부하, 테스트, 속도, 비대함)로 본다. 지적에는 심각도(치명 / 높음 / 참고)가 붙는다.

명령·스킬 원본을 고쳤으면 `sh ~/Brain/System/scripts/install-commands.sh`를 실행해야 Claude Code가 읽는
`~/.claude/commands/`·`~/.claude/skills/`에 반영된다 (`~/.claude/` 쪽을 직접 고치면 덮어써진다).

## 5. 기억과 기록 규칙 요약

- **옵시디언 vault가 기준**이다. ECC·Headroom 등 다른 도구의 기억과 다르면 vault가 우선한다.
- **문서별 상한**: 세션 로그 40줄, Handoff 60줄, Decisions 항목 15줄, Knowledge 60줄. 한 문서에 역할 하나, 한 사실은 한 곳에.
- **링크 규칙**: 위키링크는 항상 vault 루트 기준 전체 경로 (`[[Projects/<이름>/Decisions#YYYY-MM-DD — 제목]]`, `[[System/Knowledge/<주제>]]`).
  Decisions 항목 제목은 앵커라 만든 뒤 바꾸지 않는다.
- **세션 로그**: `Sessions/YYYY-MM-DD-<브랜치명>-<claude|codex>.md`. 각 에이전트는 자기 파일만 쓴다.
- **Handoff는 `/handoff`로만** 갱신한다 (여러 worktree가 동시에 덮어쓰는 것을 막기 위해).
- 설계 결정은 해당 계층의 `Decisions.md` 맨 아래에 `## YYYY-MM-DD — 제목` 형식으로 추가한다 (결정 / 이유 / 대안).
- 사실 정보는 지어내지 않는다. 모르면 `TODO(확인 필요)`로 표시한다.
- 비밀 값은 코드에 쓰지 않고 환경 변수로 관리한다. `.env`는 커밋하지 않는다.
- **실험 트랙**: 검증이 덜 된 도구는 격리 범위(별도 설정 폴더 또는 프로젝트 하나)에서만, 시작 전에 사람 확인과 Decisions 기록을 거쳐 시험한다
  ([Rules 1절](../System/Rules.md)).

## 6. 자동 점검과 안전장치

| 장치 | 동작 |
|---|---|
| `doctor.sh` | 하네스 상태를 확인만 한다(고치지 않음). 세션 시작 때 `--quiet`로 돌아 경고(WARN)가 시작 맥락에 보인다. 직접 실행: `sh ~/Brain/System/scripts/doctor.sh` |
| `precommit-check.sh` | Claude의 `git commit` 직전에 큰 파일(파일당 5MB 초과)·빌드 산출물·대량 새 파일(300개 초과)을 차단한다. 사람이 직접 하는 커밋에는 걸리지 않는다. 우회는 `BRAIN_PRECOMMIT_OK=1 git commit ...` |
| `usage-check.sh` | 5시간·7일 사용량이 기준(기본 80%)을 넘으면 프롬프트마다 경고를 넣어, 에이전트가 모델 하향을 먼저 제안하게 한다 |
| push 승인 | `git push`는 매번 사람이 명시적으로 승인한 뒤에만 한다. 로컬 커밋은 자유다 |
| L1 변경 절차 | `System/`·`~/.claude`·`~/.codex` 변경은 계획 → 사람 확인 → 백업 → 변경 → `System/Decisions.md` 기록 |
| 정기 점검 | [Reviews](../System/Reviews.md)의 주기(`review_interval_days`)가 지나면 시작 맥락에 알림이 뜬다. 에이전트는 점검을 제안만 하고 바로 진행하지 않는다 |

precommit 회귀 시험은 `System/scripts/tests/precommit-check.test.sh`에 있다. 스크립트를 고치면 `sh -n <파일>`과 `doctor.sh`를 통과시킨다.
TODO(확인 필요): Codex 커밋 차단은 [Handoff](../Projects/brain-harness/Handoff.md) 기준 아직 연결되지 않았다.

## 7. 문제 해결

| 증상 | 확인 |
|---|---|
| 시작 맥락이 안 뜬다 | `sh ~/Brain/System/scripts/doctor.sh`로 점검한다. jq가 없으면 훅이 조용히 꺼지니 `jq --version`도 확인한다 |
| 명령이나 스킬이 안 보인다 | `sh ~/Brain/System/scripts/install-commands.sh` 실행 후 Claude Code 재시작. doctor가 vault와 `~/.claude/` 불일치를 알려 준다 |
| 커밋이 막혔다 | 출력된 이유(큰 파일, 산출물, 대량 새 파일)를 확인한다. 정말 의도한 것이면 `BRAIN_PRECOMMIT_OK=1 git commit ...` |
| 원격 변경을 받고 싶다 | Claude Code에서 `/brain-sync` (명령·스킬이 바뀌었으면 `install-commands.sh`도 실행) |
