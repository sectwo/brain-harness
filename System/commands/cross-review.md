---
description: 현재 변경을 다른 에이전트로 교차 리뷰한다 (강도는 사람이 고른다)
---
`~/Brain/System/Rules.md`의 "4. 교차 리뷰"와 "5. 모델 선택"을 따른다. 프로젝트 `AGENTS.md`에 추가 규칙이 있으면 그것이 우선한다.

1. **변경 파악**: 기준 브랜치(원격 기본 브랜치가 있으면 그것, 없으면 `main` 또는 `master`) 대비 diff 규모를 구한다.
   `git diff --stat <기준>...HEAD`와 커밋 안 된 변경(`git status --short`)을 함께 본다.
   이번 변경을 누가 구현했는지 세션 로그로 확인한다. (Claude 구현 → Codex 리뷰, Codex 구현 → Claude 리뷰)
2. **사람에게 묻기**: 리뷰를 실행하기 전에 멈추고 보여준다.
   - 변경 파일 수, 추가·삭제 줄 수, 리뷰어(Codex / Claude)
   - 강도 선택지: 건너뛰기 / 가벼움 / 표준 / 심층 — 규모에 맞는 추천 하나 표시
   - 가능하면 선택지 UI로 묻는다. 사람이 고르기 전에는 리뷰를 실행하지 않는다.
   - 사용량 경고(usage-check)가 떠 있으면 함께 알리고 한 단계 낮은 강도도 제시한다.
3. **실행** (고른 강도의 모델·추론 수준. 실행 전에 "어떤 모델로 돌리는지와 이유"를 한 줄로 알린다)
   - Codex 리뷰: 현재 Codex CLI는 `codex review`의 `--base <기준>`·`--uncommitted`를 커스텀 지시문(PROMPT)과
     함께 쓸 수 없다 (`the argument '--base <BRANCH>' cannot be used with '[PROMPT]'`, 2026-10-03 확인).
     그래서 지시문을 넣는 리뷰는 `codex exec` 읽기 전용으로 돌린다:
     1. 커밋 안 된 변경이 있으면 먼저 기능 브랜치에 로컬 커밋한다 (규칙상 로컬 커밋은 자유).
     2. `codex exec -m "<모델>" -c model_reasoning_effort="<low|medium|high>" -s read-only "<지시: 먼저 git diff <기준>...HEAD로 변경을 확인하라. 파일은 수정하지 말고 리뷰만 한다. …>"`
     지시에는 강도별 범위, 심각도 표기(치명/높음/참고), 프로젝트 품질 게이트, "사실 정보 지어내기 금지" 확인을 넣는다.
     지시문 없이 기본 리뷰만 할 때는 `codex review --base <기준> -c model="<모델>" -c model_reasoning_effort="<low|medium|high>"`도 가능하다.
   - Claude 리뷰: 강도에 맞는 모델(가벼움 Haiku, 표준 Sonnet, 심층 Opus)의 하위 에이전트로 diff를 리뷰하거나
     `/code-review`를 가벼움=low, 표준=medium, 심층=high로 실행한다.
4. **결과 정리**: 치명·높음은 전부, 참고는 가벼움·표준에서 5개 이내로 요약한다.
   각 지적에 대해 "고칠지 / 근거 있게 반박할지"를 제안하고 사람의 확인을 받는다.
5. **재리뷰**는 1회까지. 결과(강도, 모델, 주요 지적, 반영 여부)를 세션 로그에 적는다.

$ARGUMENTS
