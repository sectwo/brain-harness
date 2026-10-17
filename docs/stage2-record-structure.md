# 로드맵 2단계 설계안 — 기록 구조 단순화

> 설계 문서. 아직 아무것도 적용하지 않았다. 사람이 검토하고 10절의 질문에 답하면 7·8절 순서로 적용한다.
> 작성: 2026-10-18, Fable 하위 에이전트 (→ [[Projects/brain-harness/Decisions]] 2026-10-17 "2단계 상세 설계는 Fable").
> 로드맵 원문: [[Projects/brain-harness/Overview]] 2단계. 목표는 세 가지 — 문서마다 역할 하나, 템플릿 4종, 색인 방식.

## 1. 현재 상태 진단

측정일 2026-10-18, `wc -l -c` 기준. 바이트는 UTF-8이라 한글 1자 = 3B.

### 1.1 세션 시작 때 읽는 양

| 진입 | 자동으로 들어오는 문서 | 줄 / 바이트 |
|---|---|---|
| Claude Code, intra-tnm | `~/.claude/CLAUDE.md`(5) + `Rules.md`(169) + 저장소 `CLAUDE.md`(9) + `AGENTS.md`(27) + `Handoff.md`(91) + `Overview.md`(269) | **570줄 / 47.2KB** |
| + SessionStart 훅 출력 | `session-context.sh` | 63줄 / 3.9KB → 합계 **약 51KB** |
| Claude Code, brain-harness | 같은 구성 (Handoff 35, Overview 97) | 336줄 / 25.0KB + 훅 70줄 / 5.4KB → **약 30KB** |
| Codex (두 프로젝트 공통) | `Rules.md`(169) + `session-context.sh` 출력. Handoff·Overview는 Rules 2절에 따라 직접 읽음 | 13.8KB + 훅 |

- 가장 큰 덩어리는 intratnm `Overview.md`(22.5KB, 전체의 48%)다. 사람이 쓴 기준 문서라 매 세션 통째로 필요하지는 않다 — 회사 정보 대조나 페이지 구성 확인 때만 해당 절이 필요하다.
- 훅은 마지막 `/handoff` 이후 로그를 최대 5개 × 60줄 = **최대 300줄**까지 그대로 붙인다. 로그가 템플릿 7절을 다 채우면 60줄로는 잘리고, 잘린 뒤의 "다음 할 일"은 안 보인다.
- `Rules.md` 13.8KB는 이번 단계 범위 밖(규칙 본문). 단, 2절 "작업 시작 전" 절차는 색인 도입에 맞춰 문장 하나를 고쳐야 한다(5절·7절 참고).

### 1.2 Handoff가 변경 이력이 됐다

- intratnm `Handoff.md` 91줄 / 8.5KB. "현재 상태"가 12개 불릿·약 30줄이고 불릿 하나가 3~5줄이다.
- 내용 중 커밋 해시(`0d11f9d`, `312639d`, `0529059`), 날짜 표기("10-03", "10-17 push"), Lighthouse 수치, 교차 리뷰 이력, 세션 비용 경고, 하네스 push 상태 등은 **"지금 무엇이 동작하는가"가 아니라 "언제 무엇을 했는가"**다. 이건 세션 로그·Decisions·Knowledge에 이미 있다 (SEO 상세 → `Knowledge/SEO-And-OG-Image`, 디자인 → `Knowledge/Design-Tokens`, 비용 → `System/Decisions` 2026-10-17).
- "다음 할 일" 아래 "완료 처리(10-03 로그 근거)" 문단과 "최근 결정"의 "세션 로그에만 있고 Decisions에 없는 결정(기록 후보)" 목록은 Handoff가 아니라 `/handoff` 실행 보고에 속하는 내용이다.
- 원인: 템플릿 `Templates/Project/Handoff.md`의 "현재 상태"가 `- {{date}}: 프로젝트 생성`으로 시작해 **날짜 불릿 누적**을 유도한다. `/handoff` 명령(`System/commands/handoff.md`)에도 길이 상한·금지 내용이 없다.

### 1.3 세션 로그가 길고 Decisions와 겹친다

- intratnm 로그 9개 879줄 / 73.8KB. 그중 `2026-10-03-master-claude.md` 하나가 **349줄 / 30.5KB(전체의 41%)**, `##` 절 23개, "다음 할 일" 절이 6번, "추가 작업:" 절이 3번 나온다. 한 파일에 세션 여러 개가 이어 붙은 모양이다(10-03 → 10-17까지 이어진 세션).
- 중복 사례 (같은 내용이 두 곳 이상):
  - 10-03 로그 "운영 방침 변경"(8줄) + "L1·L2 문서 정리"(20줄) ≈ `System/Decisions` 2026-10-03 항목.
  - 10-03 로그 "L1 지식 승격"(23줄)은 만든 노트 5개의 내용을 다시 요약 — `System/Knowledge/README.md` 표와 같다.
  - brain-harness 10-17 로그 "로드맵 1단계 적용" 절과 `System/Decisions` 2026-10-17 "로드맵 1단계" 항목이 GateGuard 설정값, 비용 수치($251/$52/$303, 합산 시 $14,000)를 **둘 다** 적고 있다.
  - intratnm `Decisions.md`(217줄 / 23.4KB) 15개 항목 중 2026-09-25 항목 5개는 하네스 결정이라 `System/Decisions`·`Rules.md`와 겹친다(일부는 L1에 항목으로 없고 Rules 본문에만 녹아 있다 — 6절).
- 원인: 세션 로그 템플릿에 "계획", "결정 (→ Decisions에도 기록)" 절이 있어 **결정의 이유·대안을 로그에도 쓰게** 된다. 템플릿이 "짧게"를 강제하지 않는다. Decisions 항목 형식(결정/이유/대안)은 좋지만 10-17 항목처럼 백업 경로·바꾼 파일 목록·적용 절차까지 들어가 15~25줄이 된다.

### 1.4 링크가 모호하다

- vault 안 위키링크 중 `[[Decisions]]` 27회, `[[Overview]]` 5회, `[[Handoff]]` 2회, `[[Knowledge/…]]` 4회 — 모두 프로젝트 상대 짧은 링크다. 18개 파일에 들어 있다(intratnm Handoff 9, brain-harness Handoff 8, 템플릿 4, `commands/handoff.md` 1 등).
- 프로젝트가 둘이 되면서 `Decisions.md`·`Handoff.md`·`Overview.md`가 각각 2개씩 있다. `.obsidian/app.json`이 `{}`(기본값 = "가장 짧은 경로")이라 옵시디언이 새 링크를 짧게 만들고, 같은 이름이 둘이면 어느 파일로 풀리는지 보장되지 않는다. TODO(확인 필요): 옵시디언에서 `[[Decisions]]`가 실제로 어느 파일로 열리는지.
- 에이전트는 파일을 열 때 링크를 경로로 바꿔 읽으므로, 짧은 링크는 Claude·Codex에게도 "어느 프로젝트?"를 매번 추측하게 한다.

### 1.5 템플릿 현황

| 템플릿 | 있나 | 문제 |
|---|---|---|
| 세션 로그 `Sessions/_template.md` | 있음(22줄) | 절 7개, 길이 상한 없음, "계획"·"결정" 절이 중복 유도, `summary` 없음 |
| Handoff | 있음(25줄) | 날짜 불릿 유도, 상한 없음 |
| Decisions 항목 | 머리말만(8줄) | 항목 틀 없음 → 길이 제각각 |
| Knowledge 문서 | README만(7줄) | 문서 틀 없음, 요약 줄 없음 → 색인 재료가 없음 |

## 2. 문서별 역할·길이 상한·금지 내용

원칙: **한 문서에 역할 하나, 한 사실은 한 곳에.** 다른 곳에 있는 내용은 링크로만 가리킨다. 상한은 "넘으면 쪼개거나 다른 문서로 옮기라"는 신호이지 잘라 버리라는 뜻이 아니다.

| 문서 | 역할 (이것만) | 상한 | 쓰는 이 | 금지 내용 (→ 가야 할 곳) |
|---|---|---|---|---|
| 세션 로그 `Sessions/YYYY-MM-DD-<worktree>-<agent>.md` | 그날 한 일의 사실 기록 | **40줄**, 불릿 한 줄 ≤ 120자 | 각 에이전트 자신 (Sonnet) | 결정의 이유·대안(→ Decisions 링크), 설정값·수치 재서술(→ Knowledge 링크), 대화 재현, "추가 작업" 절 반복(같은 날은 "한 일"에 불릿 추가) |
| `Handoff.md` | **지금** 상태와 다음 할 일 | **60줄**; 현재 상태 ≤ 10불릿·불릿당 2줄, 다음 할 일 ≤ 10 | `/handoff`만 (Fable) | 날짜·커밋 해시·"~했다" 이력(→ Sessions), 리뷰 이력, 완료 항목 목록, 결정 본문(→ Decisions 링크 ≤ 3개) |
| `Decisions.md` 항목 | 결정과 이유 | 항목 **15줄** | 결정을 내린 에이전트 (Fable) | 적용 절차·백업 경로·바꾼 파일 목록(→ 세션 로그), 긴 수치 근거(→ Knowledge), 진행 상태 |
| `Knowledge/<주제>.md` | 다시 쓸 지식 (방법·주의점) | **60줄**, 한 주제 한 파일 | `/handoff` 또는 발견한 에이전트 | 날짜별 경위(→ Sessions), 결정 이유(→ Decisions), 프로젝트 상태 |
| `Overview.md` | 요구사항·구조 (사람 작성) | 상한 없음 | 사람 | 변경 없음 — 이번 단계 범위 밖. 단 자동 import는 중단(4절) |
| `Agents/<이름>.md` | 에이전트별 특이점 | 40줄 | 에이전트 | L1 Knowledge에 있는 내용 반복(링크만). 정리는 후속(범위 밖) |

세션 로그·Knowledge는 색인용 `summary:` 한 줄을 frontmatter에 **반드시** 둔다(4절).

## 3. 템플릿 4종 초안

적용 위치: `System/Templates/Project/`(새 프로젝트용 원본)와, 같은 내용으로 두 프로젝트의 `Sessions/_template.md`를 교체한다. `{{project}}`·`{{date}}`는 `/new-project`가 치환한다. Decisions 항목·Knowledge 문서 틀은 파일이 아니라 각 문서 머리말 아래 주석 블록으로 두어 에이전트가 복사해 쓴다.

### 3.1 세션 로그 — `Sessions/_template.md`

```markdown
---
project: {{project}}
date: YYYY-MM-DD
agent: claude | codex
worktree: <브랜치명>
summary: <한 줄. 무엇을 했고 어디까지 됐는지. 색인에 그대로 나온다>
tags: [{{project}}, session]
---
# 세션 — YYYY-MM-DD / <worktree> / <agent>

## 한 일
- <사실만. 결과 중심. 5~10불릿, 불릿당 한 줄>
- 결정을 내렸으면 여기엔 제목만: 결정 "<제목>" → [[Projects/{{project}}/Decisions#YYYY-MM-DD — <제목>]]

## 바꾼 파일
- <경로> — <한 줄>

## 검증
- <빌드/린트/타입/테스트/리뷰 결과 한 줄씩. 교차 리뷰는 강도·모델·지적 수·반영 여부>

## 막힌 점 / 확인 필요
- <사람이 답해야 하는 것. 없으면 "없음">

## 다음 세션에
- <이어서 할 일. Handoff에 올릴 후보. 3개 이내>
```

규칙: 전체 40줄 이내. 같은 날 같은 worktree에서 세션이 이어지면 "한 일"에 불릿을 **추가**한다(새 절을 만들지 않는다). 날짜가 바뀌면 새 파일. `summary:`는 세션을 마칠 때 마지막으로 고쳐 쓴다.

### 3.2 Handoff — `Handoff.md`

```markdown
---
project: {{project}}
last_handoff: {{date}}
tags: [{{project}}, handoff]
---
# Handoff — {{project}}

> 새 세션은 이 노트부터 읽는다. `/handoff`로만 갱신한다. 이력은 쓰지 않는다 — 언제 무엇을 했는지는 Sessions/, 왜는 Decisions.

## 현재 상태
- <지금 동작하는 것·안 되는 것. 10불릿 이내, 불릿당 2줄 이내. 날짜·커밋 해시 없음>
- 저장소: `<경로>` `<브랜치>` (origin과 같음 / 로컬 n커밋 앞섬)

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| - | - | - | - |

## 다음 할 일
1. [ ] (<담당>) <할 일> — <막힌 이유나 선행 조건이 있으면 한 줄>

## 막힌 점 / 확인 필요
- <사람이 답해야 하는 것만. 답이 나오면 지운다>

## 관련 결정
- [[Projects/{{project}}/Decisions#YYYY-MM-DD — <제목>]] — <아직 영향 중인 결정 3개 이내. 전체는 Decisions 색인>
```

규칙: 60줄 이내. "현재 상태"는 매번 **다시 쓴다**(누적 금지). 완료된 "다음 할 일"은 지운다 — 완료 사실은 세션 로그에 있다.

### 3.3 Decisions 항목 — `Decisions.md` 머리말 + 항목 틀

```markdown
---
project: {{project}}
tags: [{{project}}, decisions]
---
# Decisions — {{project}}

> 이 프로젝트의 결정. 모든 프로젝트에 영향을 주는 결정은 [[System/Decisions]]에 쓴다.
> 새 항목은 맨 아래에. 제목 형식 `## YYYY-MM-DD — 제목`은 링크 앵커라 **나중에 바꾸지 않는다**.
> 항목은 15줄 이내. 적용 절차·백업 경로·바꾼 파일은 세션 로그에, 긴 근거는 Knowledge에 두고 링크한다.

<!-- 항목 틀 (복사해서 쓴다)
## YYYY-MM-DD — 제목
- **결정**: 무엇을 어떻게 하기로 했는가. 사용자 결정이면 "(사용자 결정)".
- **이유**: 왜. 근거 수치가 길면 [[…Knowledge/…]] 링크.
- **대안**: 검토한 다른 안과 기각 이유. 한 안에 한 줄.
- **기록**: 세션 로그 [[Projects/{{project}}/Sessions/YYYY-MM-DD-<worktree>-<agent>]] (적용·백업·파일 목록은 거기)
-->
```

`System/Decisions.md` 머리말도 같은 규칙으로 바꾼다("기록" 줄의 링크 대상만 `Projects/<프로젝트>/Sessions/…`).

### 3.4 Knowledge 문서 — `Knowledge/_template.md` (새 파일)

```markdown
---
project: {{project}}          # L1이면 level: 1
summary: <한 줄. 언제 이 문서를 열어야 하는지. 색인에 그대로 나온다>
source: <어느 프로젝트·날짜 세션에서 알게 됐는지. 예: intratnm 2026-10-03>
tags: [{{project}}, knowledge]
---
# <주제>

## 언제 쓰나
- <이 지식이 필요한 상황. 1~3불릿>

## 방법
- <순서대로. 명령·설정값은 여기 한 번만>

## 주의
- <함정, 확인된 반례>

## 관련
- [[…]] — <관련 결정·다른 지식. 이유는 여기 적지 않는다>
```

규칙: 60줄 이내. `Knowledge/README.md` 표는 유지하되 `summary:`와 같은 문장을 쓴다(둘이 다르면 `summary:`가 기준이고 `/handoff`가 README를 맞춘다). L1 `System/Knowledge/`에도 같은 틀을 `_template.md`로 둔다.

## 4. 색인 설계

### 4.1 방식: 저장하지 않고 스크립트가 세션 시작 때 만든다 (권장)

- **색인 파일을 따로 두지 않는다.** `session-context.sh`가 매번 frontmatter `summary:`와 Decisions 제목(`## YYYY-MM-DD — …`), Overview 절 제목을 긁어 출력한다.
- 이유: 색인 파일(`Index.md`)을 두면 `/handoff` 사이에 낡고, 두 프로젝트 × 두 에이전트가 갱신 책임을 나눠 가져야 한다. 스크립트 생성은 항상 최신이고 갱신 주체가 없다. 비용은 각 문서에 `summary:` 한 줄을 쓰는 것뿐이다.
- 옵시디언 안에서 사람이 볼 색인이 필요하면 `Knowledge/README.md`(이미 있음)와 Decisions 제목 목록으로 충분하다. Dataview 같은 플러그인은 넣지 않는다(에이전트가 못 읽는다).

### 4.2 세션 시작 맥락의 새 구성

Claude Code(훅)와 Codex(직접 실행) 모두 같은 출력을 본다. 목표 길이 **80줄 이내**.

```
# 세션 이어가기 맥락 (자동 생성)
## L1
- 공통 규칙/환경/지식 경로 (현행 유지)
- 지식 목록: 이름만 쉼표로 (현행 유지)
- 최근 전역 결정: System/Decisions 마지막 3개 제목            ← 추가
- 사용량·정기 점검 (현행 유지)
## L2 프로젝트: <이름>
- 현재 worktree: 브랜치·변경·최근 커밋·이번 로그 파일명 (현행 유지)
## 색인                                                       ← 추가
- Overview 절: <## 제목들을 쉼표로> → 필요한 절만 Read
- 결정(최근 5): `YYYY-MM-DD — 제목` 한 줄씩
- 지식: `파일명 — summary` 한 줄씩
- 세션 로그(최근 5): `파일명 — summary` 한 줄씩
## 마지막 /handoff(날짜) 이후 세션 로그                         ← 축약
- 로그마다: summary + "## 막힌 점" + "## 다음 세션에" 절만 (로그당 25줄 상한)
```

### 4.3 `session-context.sh` 변경안 (diff 수준)

파일: `System/scripts/session-context.sh` (L1). POSIX sh 유지, `jq` 외 의존성 추가 없음.

1. 상수 추가: `MAX_LOG_LINES=25`, `MAX_DECISIONS=5`, `MAX_KNOWLEDGE=15`.
2. 공통 함수 추가:
   - `fm_summary <파일>`: frontmatter(첫 `---`~다음 `---`) 안의 `summary:` 값을 출력. 없으면 `(summary 없음)`.
   - `decision_titles <파일> <n>`: `grep '^## [0-9]\{4\}-' | tail -n n`.
   - `section <파일> <절 제목>`: 해당 `## 절`부터 다음 `## ` 전까지 출력.
3. L1 블록: `지식 목록` 줄 아래에 `- 최근 전역 결정:` + `decision_titles "$SYSTEM/Decisions.md" 3` 추가.
4. L2 블록, "현재 worktree" 뒤에 `## 색인` 추가:
   - Overview: `grep '^## ' "$VAULT/Overview.md" | sed 's/^## //' | paste -sd, -` → `- Overview 절: …`.
   - Decisions: `decision_titles "$VAULT/Decisions.md" $MAX_DECISIONS` → 한 줄씩 `- `.
   - Knowledge: `ls Knowledge/*.md`(README·_template 제외) 각각 `- 이름 — $(fm_summary)`.
   - Sessions: 최근 `MAX_LOGS`개 파일명 + summary.
5. "마지막 /handoff 이후 세션 로그" 블록: 지금의 `awk … | head -60`을 다음으로 교체.
   `echo "- summary: $(fm_summary "$f")"; section "$f" "막힌 점 / 확인 필요"; section "$f" "다음 세션에"` 를 합쳐 `head -n $MAX_LOG_LINES`.
   `summary`가 없는 옛 로그는 기존처럼 본문 앞 25줄을 보여 준다(하위 호환).
6. 옵션 `--handoff`: 주어지면 마지막에 `Handoff.md` 본문을 그대로 출력한다. Codex용 — Claude는 `CLAUDE.md`가 `@`로 불러오므로 훅에서는 쓰지 않는다. `~/.codex/AGENTS.md` 2번 항목을 `sh … session-context.sh --handoff`로 바꾼다.
7. 헤더 주석의 "Handoff.md / Overview.md는 프로젝트 CLAUDE.md가 따로 불러오므로" 문장을 "Handoff.md는 CLAUDE.md가 불러오고(Codex는 `--handoff`), Overview는 색인만 보여 준다"로 고친다.
8. 품질 게이트(AGENTS.md): `sh -n`, `doctor.sh`, 그리고 두 저장소(`~/Brain`, `~/orca/projects/intra-tnm`)에서 실제 실행해 80줄 이내인지 `wc -l`로 확인.

### 4.4 `CLAUDE.md` import 축소

- 저장소 `CLAUDE.md`에서 `@…/Overview.md` 줄을 **뺀다**. `@AGENTS.md`와 `@…/Handoff.md`는 유지.
- `Rules.md` 2절 "작업 시작 전" 2번을 "프로젝트 `Handoff.md`를 읽는다. `Overview.md`는 세션 맥락의 색인에서 필요한 절만 찾아 읽는다(회사 정보 대조처럼 전체가 필요하면 전체를 읽는다)"로 고친다.
- `System/commands/new-project.md` 3단계의 `CLAUDE.md` 설명에서 Overview import를 뺀다.
- intra-tnm 저장소의 `CLAUDE.md`는 intratnm 프로젝트(L2) 파일이라 brain-harness AGENTS.md 규칙대로 **사람 확인 후** 고친다(7절).
- 예상 효과(추정): intra-tnm 세션 시작 약 51KB → Rules 13.8 + CLAUDE/AGENTS 2.1 + Handoff(60줄 이내) 약 4 + 훅(80줄 이내) 약 5 = **약 25KB, 절반**. brain-harness는 Overview가 97줄이라 효과가 작다(약 30 → 약 22KB).

### 4.5 누가 언제 갱신하나

| 재료 | 쓰는 이 | 때 |
|---|---|---|
| 세션 로그 `summary:` | 로그를 쓴 에이전트 (Sonnet) | 세션 마칠 때 |
| Knowledge `summary:` | 문서를 만든 에이전트 / `/handoff` | 문서 생성 때 |
| Decisions 제목 | 결정을 쓴 에이전트 (Fable) | 결정 때 (형식만 지키면 됨) |
| Overview 절 제목 | 사람 | 해당 없음 |
| 색인 출력 | `session-context.sh` | 세션 시작마다 자동 |

`/handoff`(`System/commands/handoff.md`)에 두 항목을 더한다: (a) 읽은 로그에 `summary:`가 없으면 한 줄 채운다, (b) Handoff는 3.2 틀대로 **다시 쓰고** 60줄을 넘기지 않는다, 완료 항목은 지운다. "최근 결정" 절 이름을 "관련 결정"으로 바꾸고 3개 이내로 제한한다.

## 5. 링크 규칙

1. **위키링크는 항상 vault 루트 기준 전체 경로**로 쓴다. 같은 프로젝트 안이라도 예외 없다.
   - `[[Projects/intratnm/Decisions#2026-10-03 — UI/UX 개편 A안: 정밀 산업 스위스 미니멀]]`
   - `[[Projects/brain-harness/Handoff]]`, `[[System/Knowledge/ECC-GateGuard]]`, `[[System/Decisions#2026-10-17 — …]]`
   - 이유: 에이전트가 링크를 바로 경로로 바꿔 읽을 수 있고, 프로젝트가 늘어도 모호하지 않다. "같은 프로젝트면 짧게" 같은 예외를 두면 규칙을 외워야 해서 뺐다.
2. Decisions 항목 제목은 앵커다. `## YYYY-MM-DD — 제목`을 만든 뒤 바꾸지 않는다. 바꿔야 하면 새 항목을 만들고 옛 항목에 "→ 새 항목" 한 줄을 남긴다.
3. 옵시디언 설정 `.obsidian/app.json`(git 추적 중)에 `"newLinkFormat": "absolute"`를 넣어 사람이 만드는 링크도 전체 경로가 되게 한다. TODO(확인 필요): 키 이름은 적용 때 옵시디언 설정 화면("새 링크 형식 → vault 기준 절대 경로")에서 확인.
4. 템플릿은 `[[Projects/{{project}}/Decisions]]`처럼 치환자를 넣어 두고 `/new-project`가 바꾼다.
5. 기존 짧은 링크 정리: 18개 파일의 `[[Decisions`, `[[Handoff`, `[[Overview`, `[[Knowledge/`, `[[Sessions/`를 파일이 속한 프로젝트 경로로 바꾼다. 기계적으로 `sed`(프로젝트별로 접두어 하나)로 하고, 바꾼 뒤 `grep -rn '\[\[\(Decisions\|Handoff\|Overview\|Knowledge/\|Sessions/\)' System Projects`가 0건인지 확인한다. `System/Knowledge/README.md`의 `[[Orca-Codex-Headroom]]`류(같은 폴더 안 링크)도 `[[System/Knowledge/…]]`로 맞춘다.
6. `doctor.sh`에 점검 항목 추가: 위 grep이 0건이 아니면 WARN.

## 6. 기존 문서 정리 계획

원칙: **지우는 내용은 모두 git 이력과 다른 문서에 남아 있어야 한다.** 옛 세션 로그 본문은 고치지 않는다(사실 기록이고 git에 있다). 고치는 것은 Handoff(역할 복원), Decisions(위치 교정), frontmatter(색인 재료)뿐이다.

### 6.1 intratnm `Handoff.md` (91줄 → 60줄 이내, Fable)
- "현재 상태" 12불릿을 3.2 틀로 다시 쓴다. 남기는 것: 구현 범위(페이지 목록), 스택, 배포 전 상태(NOTICE 파일 저장소·CONTACT 키 미설정·카카오맵 미발급·브랜드 자산 자리표시자·동의 문구 TODO 노출), 저장소 상태(한 줄). 빼는 것과 그 내용이 남아 있는 곳:
  - SEO 상세·커밋 해시 → `Knowledge/SEO-And-OG-Image`, 10-03 로그
  - 디자인 상세 → `Knowledge/Design-Tokens`, 저장소 `design-system/intra-tnm/MASTER.md`
  - Lighthouse 수치 → 10-03 로그 (상태로는 "6개 페이지 a11y/SEO 100 확인됨" 한 줄만)
  - 교차 리뷰 이력 → 각 세션 로그
  - 세션 비용 경고, 하네스 push 상태 → brain-harness로 이관됨(`System/Decisions` 2026-10-17, brain-harness 10-17 로그)
- "다음 할 일"의 "완료 처리(10-03 로그 근거)" 문단 삭제(10-03 로그에 있음). 3번(세션 비용 방침)은 로드맵 1단계로 해결됐으니 삭제. 나머지 9개는 유지.
- "최근 결정" → "관련 결정" 3개(A안, 풀페이지 스냅 기각, Chakra Petch). "세션 로그에만 있고 Decisions에 없는 결정(기록 후보)" 목록은 삭제 — 셋 다 Knowledge/Design-Tokens 또는 로그에 근거가 있고 Decisions 항목으로 올릴 만큼의 결정이 아니다(판단: 사용자 확인 질문 Q4).

### 6.2 intratnm `Sessions/` (본문 수정 없음, Sonnet)
- 9개 로그 모두 frontmatter에 `summary:` 한 줄 추가. `2026-10-03-master-claude.md`는 frontmatter 자체가 없으니(첫 줄이 `# 세션`) 다른 로그와 같은 frontmatter를 붙인다.
- 10-03 로그(349줄)는 쪼개지 않는다. 색인에서는 "파일명 — summary" 한 줄로만 보이고, 이미 `last_handoff`(10-17) 이전이라 본문이 훅에 실리지 않는다. 쪼개면 날짜·링크 앵커가 깨지고 이득이 없다.
- `Sessions/_template.md`를 3.1로 교체.

### 6.3 intratnm `Decisions.md` (217줄, Fable, L1 변경 포함)
- 2026-09-25 항목 5개(하네스 구성, 기억 파일 쓰기 규칙, 세션 시작 맥락 자동 주입, 교차 리뷰 방식과 모델 선택, L1/L2/L3 분리)는 하네스 결정이다. 이 중 "L1/L2/L3 분리"는 이미 `System/Decisions` 항목을 가리키고, 나머지 4개는 `Rules.md` 본문에만 녹아 있고 `System/Decisions`에 항목이 없다.
- 안: `System/Decisions.md`에 **`## 2026-09-25 — intratnm에서 이관: 하네스 초기 결정 4건`** 항목 하나를 만들어 네 항목의 결정·이유·대안 본문을 **그대로** 옮기고(내용 손실 없음, 날짜는 원래 날짜 유지), intratnm 쪽 다섯 항목은 각각 제목 + "→ [[System/Decisions#…]]로 이관" 한 줄로 줄인다. 제목을 남기는 이유는 기존 앵커 링크를 깨지 않기 위해서다(적용 전 `grep -rn '2026-09-25 — 하네스 구성'` 등으로 참조 여부 확인).
- 2026-09-26 이후 항목은 그대로 둔다(프로젝트 결정이 맞다). 길이 상한은 **새 항목부터** 적용한다.

### 6.4 `System/Decisions.md` (155줄)
- 과거 항목은 고치지 않는다. 머리말을 3.3으로 바꾸고, 6.3의 이관 항목만 추가한다.
- 10-17 항목 두 개가 백업 경로·설정값까지 담고 있는 것은 그대로 둔다 — 이미 링크된 기록이고, 옮길 곳(당시 세션 로그)에도 같은 내용이 있어 중복이지만 **줄이는 작업이 줄어드는 양보다 비싸다**.

### 6.5 brain-harness
- `Handoff.md`: 이미 짧다. 링크 전체 경로화, "최근 결정" → "관련 결정"만.
- `Sessions/2026-10-17-main-claude.md`: `summary:` 추가만. `Sessions/_template.md` 교체.
- `Knowledge/README.md`: `_template.md` 추가.

### 6.6 L1 `System/Knowledge/` 8개 + intratnm `Knowledge/` 5개
- 각 파일 frontmatter에 `summary:`(README 표의 설명 문장을 그대로)와 `source:`(본문의 출처 줄이 있으면 그것) 추가. 본문은 고치지 않는다. Sonnet.

## 7. 바꿔야 할 파일 목록

L1 변경은 모두 `~/.brain-backups/2026-10-18/`(또는 적용일)에 원본 복사 후 진행. 모델은 Rules 5절대로.

| # | 파일 | 계층 | 변경 | 백업 | 모델 |
|---|---|---|---|---|---|
| 1 | `System/Templates/Project/Sessions/_template.md` | L1 | 3.1로 교체 | 예 | Fable |
| 2 | `System/Templates/Project/Handoff.md` | L1 | 3.2로 교체 | 예 | Fable |
| 3 | `System/Templates/Project/Decisions.md` | L1 | 3.3 머리말+틀 | 예 | Fable |
| 4 | `System/Templates/Project/Knowledge/_template.md` | L1 | 신규 3.4 | - | Fable |
| 5 | `System/Templates/Project/Overview.md`, `Agents/*.md` | L1 | 링크 전체 경로화만 | 예 | Sonnet |
| 6 | `System/Knowledge/_template.md` | L1 | 신규 3.4(level: 1판) | - | Fable |
| 7 | `System/Knowledge/*.md` 8개 + `README.md` | L1 | `summary:`/`source:` 추가, 링크 | 예(폴더째) | Sonnet |
| 8 | `System/scripts/session-context.sh` | L1 | 4.3 | 예 | Fable |
| 9 | `System/scripts/doctor.sh` | L1 | 5절 6번 점검 추가 | 예 | Sonnet |
| 10 | `System/commands/handoff.md` | L1 | 4.5 항목, 링크 | 예 | Fable |
| 11 | `System/commands/new-project.md` | L1 | Overview import 제거 | 예 | Sonnet |
| 12 | `System/Rules.md` | L1 | 2절 "작업 시작 전" 2번 문장, 2절에 링크 규칙 한 줄, 1절 표에 `Knowledge/_template.md` 언급 | 예 | Fable |
| 13 | `System/Decisions.md` | L1 | 머리말, 2단계 결정 항목, 6.3 이관 항목 | 예 | Fable |
| 14 | `~/.codex/AGENTS.md` | L1 | `--handoff` 옵션 | 예 | 사람 실행 권장 (auto mode가 `~/.codex` 수정을 막을 수 있음, TODO(확인 필요)) |
| 15 | `.obsidian/app.json` | L1(vault 설정) | `newLinkFormat` | 예 | 사람 또는 Sonnet |
| 16 | `CLAUDE.md` (vault 루트) | L2 brain-harness | Overview import 제거 | - | Sonnet |
| 17 | `Projects/brain-harness/{Handoff,Sessions/*,Sessions/_template,Knowledge/README}.md` | L2/L3 | 6.5 | - | Handoff는 Fable, 나머지 Sonnet |
| 18 | `Projects/intratnm/Handoff.md` | L2 intratnm | 6.1 | 예 | Fable |
| 19 | `Projects/intratnm/Decisions.md` | L2 intratnm | 6.3 | 예 | Fable |
| 20 | `Projects/intratnm/Sessions/*.md`(9) + `_template.md` | L3 intratnm | 6.2 | - (git) | Sonnet |
| 21 | `Projects/intratnm/{Overview,Knowledge/*,Agents/*}.md` | L2/L3 intratnm | 링크·`summary:`만 | - (git) | Sonnet |
| 22 | `~/orca/projects/intra-tnm/CLAUDE.md` | L2 intratnm (다른 저장소) | Overview import 제거 | 예 | 사람 확인 후 Sonnet |
| 23 | `docs/README.md` | - | 이 문서와 템플릿 링크 추가 | - | Sonnet |

intratnm 쪽(18~22)은 brain-harness `AGENTS.md` 규칙("다른 프로젝트 vault는 확인 후")에 따라 사람 확인이 필요하다(Q1).

## 8. 적용 순서와 되돌리기

커밋은 단계마다 하나. 각 단계가 끝나면 다음으로 넘어가기 전에 확인할 것을 적었다.

1. **백업** — `~/.brain-backups/<날짜>/`에 7절 "예" 파일 복사. `git status` 깨끗한지 확인(현재 `.obsidian/graph.json` 수정과 intratnm 자료 폴더 untracked가 있다 — 자료 폴더는 이 단계와 무관, 그대로 둔다).
2. **템플릿·틀** (#1~6) — 커밋 "docs: 기록 템플릿 4종". 확인: `/new-project`가 치환하는 `{{…}}`가 모두 남아 있는지.
3. **`summary:` 추가와 링크 전체 경로화** (#5, 7, 17, 20, 21, 15) — 커밋. 확인: 5절 6번 grep 0건, 옵시디언에서 링크 몇 개 클릭해 열리는지.
4. **스크립트** (#8, 9) — 커밋. 확인: `sh -n`, `doctor.sh`, 두 저장소에서 실행해 80줄 이내·`summary` 표시·`--handoff` 동작.
5. **명령·규칙·결정** (#10~13, 16, 23) — 커밋. 확인: `install-commands.sh` 후 `~/.claude/commands/` diff 없음.
6. **Codex·intratnm** (#14, 18, 19, 22) — 사람 확인 후. 커밋(Brain), intra-tnm 저장소는 별도 커밋.
7. **검증** — 새 Claude 세션(intra-tnm)과 Codex 세션을 한 번씩 열어 세션 시작 출력 길이와 색인이 맞는지 본다. 결과를 brain-harness 세션 로그에 수치로 남긴다(1단계와 같은 방식).
8. `/handoff`로 brain-harness Handoff 갱신, 로드맵 2단계 완료 표시(`Overview.md`는 사람 문서라 진행 상태 한 줄만).

되돌리기: 단계별 커밋이라 `git revert <커밋>`으로 그 단계만 되돌린다. 스크립트·설정은 백업 폴더에서 복사해도 된다. `~/.codex/AGENTS.md`·intra-tnm `CLAUDE.md`는 vault 밖이라 백업 복사로만 되돌린다. 옛 로그 본문을 안 고치므로 세션 로그 쪽은 되돌릴 것이 frontmatter뿐이다.

## 9. 위험과 대안

| 위험 | 대응 |
|---|---|
| `summary:`를 안 쓰거나 대충 써서 색인이 쓸모없어짐 | 스크립트가 `(summary 없음)`을 그대로 보여 주고, `/handoff`가 빠진 것을 채운다. 템플릿이 첫 줄에 둬서 빼먹기 어렵다 |
| Handoff를 다시 쓰다 상태를 잃음 | 옛 Handoff는 git에 있고, 6.1에서 빠지는 내용마다 남아 있는 곳을 적어 두었다. 적용 때 Fable이 "뺀 내용 → 있는 곳" 표를 세션 로그에 남긴다 |
| Overview import를 빼서 회사 정보 대조를 빠뜨림 | intratnm AGENTS.md 품질 게이트("Overview와 대조")가 그대로 있고, 색인에 Overview 절 제목이 보인다. 그래도 걱정되면 Q3에서 유지 선택 |
| 전체 경로 링크가 길어 읽기 불편 | 옵시디언은 표시 이름을 `[[경로|별칭]]`으로 줄일 수 있다. 에이전트 가독성보다 모호성 제거가 우선 |
| Codex가 `--handoff`를 안 붙여 Handoff를 못 봄 | `~/.codex/AGENTS.md`에 명령을 그대로 적는다. 옵션 없이 실행해도 색인에 Handoff 경로가 나온다 |

기각한 대안:
- **`Index.md` 파일을 `/handoff`가 유지** — `/handoff` 사이에 낡고, 갱신 책임이 생긴다. 스크립트 생성이 더 단순해 기각.
- **Dataview 등 옵시디언 플러그인 색인** — Codex·Claude가 못 읽는다. 기각.
- **옛 세션 로그를 템플릿대로 다시 쓰기** — 349줄 로그 재작성에 드는 토큰 대비 이득이 없고 사실 기록을 고치는 셈. 색인이 옛 로그를 가볍게 만들어 주므로 기각.
- **Decisions를 항목별 파일로 분리** — 색인하기는 좋지만 파일이 늘고 기존 앵커 링크 27+24개가 깨진다. 제목 규칙과 grep 색인으로 충분. 기각.
- **같은 프로젝트 안은 짧은 링크 허용** — 규칙이 둘이 되면 틀린다. 기각.
- **세션 로그 상한 20줄** — 교차 리뷰 결과(강도·지적·반영)를 적으면 넘친다. 40줄로.

## 10. 사람이 정할 질문

- **Q1. intratnm 문서(Handoff 재작성, Decisions 5건 이관, 로그 frontmatter, intra-tnm `CLAUDE.md`)를 이번 단계에서 같이 고쳐도 되나?** 권장: 예. 아니면 템플릿·스크립트·brain-harness만 먼저 하고 intratnm은 다음 `/handoff` 때 적용한다.
- **Q2. 길이 상한(세션 로그 40줄, Handoff 60줄, Decisions 항목 15줄, Knowledge 60줄)을 이대로 둘까?** 권장: 이대로 시작하고 4단계(측정) 때 조정.
- **Q3. `CLAUDE.md`에서 `@Overview.md` import를 뺄까?** 권장: 뺀다(intra-tnm 세션 시작 약 절반 절감). 회사 정보 대조가 걱정되면 intra-tnm만 유지하고 brain-harness만 뺀다.
- **Q4. intratnm Handoff "기록 후보" 3건(브랜드 tier·historyKind, aurora 모션, 포인트 블루)을 Decisions 항목으로 올릴까, 지울까?** 권장: 지운다(Knowledge/Design-Tokens와 로그에 근거가 있음).
- **Q5. 옵시디언 링크 설정(`.obsidian/app.json`)을 에이전트가 고쳐도 되나, 사람이 앱에서 바꿀까?** 권장: 사람이 앱 설정에서 바꾸고 커밋은 에이전트가.
- **Q6. `~/.codex/AGENTS.md`와 intra-tnm `CLAUDE.md`(vault 밖 파일)는 사람이 직접 고칠까?** 권장: 에이전트가 고친 내용을 보여 주고 사람이 붙여넣는다(auto mode 권한 문제 회피).
