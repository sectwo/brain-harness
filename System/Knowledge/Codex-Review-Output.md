---
level: 1
summary: "`codex review`/`exec` 출력은 `head`로 자르지 말고 파일로 끝까지 받기 · 비대화형 실행은 `< /dev/null`로 stdin을 닫기"
tags: [knowledge, codex, cross-review]
source: intratnm 2026-10-02, 2026-10-19
---
# Codex 리뷰 출력은 잘라 보지 말고 파일로 끝까지 받기

## 상황
`codex review` / `codex exec`를 Bash로 돌리고 출력을 `head -c 3000` 같은 방식으로 잘라 확인했더니,
결과가 깨진 JSON처럼 보여 `model_reasoning_effort` 옵션이 잘못된 것으로 오해했다.

## 원인
Codex는 시작할 때마다 세션 맥락(`Rules.md` 등)을 `cat`해서 읽기 때문에 출력 앞부분이 길다.
3000자 안에서는 실제 리뷰 본문에 도달하지 못하고 그 중간에서 잘린 것이 깨진 JSON처럼 보였을 뿐,
Codex 쪽 버그가 아니라 `head` 절단이 원인이었다. 옵션 자체는 문제없다.

## 해결
- `codex review` / `codex exec` 출력은 **절대 `head -c`로 자르지 않는다.**
- 출력을 파일로 리다이렉트해 끝까지 받은 뒤 그 파일을 읽는다. 이렇게 하면 정상 동작한다.
- 최종 답만 필요하면 `codex exec -o <파일>`로 마지막 메시지만 따로 받는다.

## 함정: stdin을 열어 두면 멈춘다 (2026-10-19)
- 에이전트 Bash·백그라운드·파이프에서 `codex exec "<지시>"`를 돌리면 로그에 `Reading additional input from stdin...`만 찍히고
  리뷰를 시작하지 않은 채 멈춘다(10분 타임아웃까지 대기). 지시문을 인자로 줘도 stdin이 열려 있으면 추가 입력을 기다린다.
- 해결: 항상 `< /dev/null`을 붙인다 — `codex exec … "<지시>" < /dev/null > log.txt 2>&1`.

## 출처
- [[Projects/intratnm/Sessions/2026-10-02-master-claude]] — "교차 리뷰 (Codex, 가벼움 강도)" 디버깅 메모
- [[Projects/intratnm/Sessions/2026-10-19-sectwo-개발-claude]] — stdin 대기로 표준 리뷰가 멈춘 사례
