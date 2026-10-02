---
project: intratnm
agent: codex
tags: [intratnm, agent]
---
# Codex — intratnm (L3)

> 이 프로젝트에서 Codex의 역할, 설정, 알게 된 특이점. 공통 설정은 [[System/Environment]].

## 역할
- Claude 구현분 교차 리뷰, 필요 시 병렬 worktree 구현. 실행 방식은 L1 `/cross-review` 명령
  (`~/Brain/System/commands/cross-review.md`)을 따른다 — 지시문을 넣을 때는 `codex exec -s read-only`,
  지시문 없는 기본 리뷰는 `codex review --commit <해시>` 또는 `--base`
  (→ [[System/Decisions#2026-10-03 — 모델 운용 변경(Opus 5.5 기본·Fable 기록)과 /cross-review Codex 실행 방식 변경]]).
- 이 프로젝트에서 실제로 쓴 조합: 가벼움 `gpt-5.6-luna`/low (`codex review --commit`, 10-01·10-02),
  표준 `gpt-5.6-terra`/medium (`codex exec`, 10-01·10-03). 모두 지적 반영됨.

## 설정
- Orca가 띄우는 Codex는 `CODEX_HOME=~/Library/Application Support/orca/codex-runtime-home/home`
- vault 쓰기: 두 config.toml의 `writable_roots`에 `~/Brain/Projects/intratnm` (L1 System은 쓰기 불가)
- Headroom 경유: Orca `agentCmdOverrides.codex` 적용 대기 → [[System/Knowledge/Orca-Codex-Headroom]]

## 알게 된 점
- (확인 필요) Orca가 `~/.codex`에서 설정을 다시 동기화할 때 `writable_roots`가 유지되는지 — 2026-10-01 Codex 리뷰
  로그(`Sessions/2026-10-01-master-codex.md`)가 vault에 작성되긴 했으나, Orca 재동기화 뒤에도 유지되는지는 미확인.
- Codex 샌드박스에서는 Turbopack `npm run build`가 포트 바인딩 제한으로 실패한다. 리뷰 지시문에
  `npm run build -- --webpack`을 쓰게 하고, Turbopack 실패는 코드 판정에 반영하지 않는다(10-01 Codex 로그).
- 리뷰 범위를 지시할 때 `git diff <기준>...HEAD`로 범위를 못 박으면 Codex가 같은 명령으로 직접 확인하고
  회사 정보 변경 여부(`src/data/*`)까지 대조해 준다 — 지시문에 "새 회사 정보 생성 여부 확인"을 넣는다.
