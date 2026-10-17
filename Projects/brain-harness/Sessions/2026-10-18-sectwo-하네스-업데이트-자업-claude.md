---
project: brain-harness
date: 2026-10-18
agent: claude
worktree: sectwo/하네스-업데이트-자업
summary: /cross-review 6관점·3단계① 자동 점검(둘 다 main 병합·push 완료) + 외부 저장소 3종 분석, Rules 실험 트랙, claude-mem 해마 실험(~11-01) 설치, 3단계 ② 유지보수 체계 추가
tags: [brain-harness, session]
---
# 세션 — 2026-10-18 / sectwo/하네스-업데이트-자업 / claude
## 한 일
**1) 즉시 작업 ③ /cross-review 6관점** — 표준·심층 점검표에 6관점(버그·보안·부하·테스트·속도·비대함) 추가, 가벼움은 그대로. 백업 ~/.brain-backups/2026-10-18/cross-review.*. 결정 [[System/Decisions#2026-10-18 — /cross-review 표준·심층 점검표에 6관점 추가]]. 커밋 main 병합·push 완료(사람 승인, 94ba706..481abc5)
**2) 3단계 ① 자동 점검** — doctor.sh `--quiet`·스킬 동기화 절, session-context.sh는 WARN 최대 3줄 표시, 새 precommit-check.sh(5MB 초과·산출물·새 파일 300개 초과 차단, 우회 `BRAIN_PRECOMMIT_OK=1`)를 ~/.claude/settings.json PreToolUse(Bash)에 등록. 백업 stage3-autocheck/. 결정 [[System/Decisions#2026-10-18 — 3단계① 자동 점검: 세션 시작 doctor·스킬 동기화·커밋 전 차단]]. main 병합·push 완료
**3) 외부 저장소 3종 분석** — OmniRoute·claude-mem·one-skill-to-rule-them-all을 Sonnet 하위 에이전트 3개로 읽기 전용 분석. 통째 설치는 기각 추천 → 사용자 "claude-mem 시험 설치". 사용자 지적 "발전을 막는 방침" → Rules에 실험 트랙 추가, 기억·자동 수집 문구 정리 [[System/Decisions#2026-10-18 — 실험 트랙 추가: 검증 전 도구를 격리해 시험, 기억·학습 방침 문구 정리]] (백업 ~/.brain-backups/2026-10-18/Rules.before-experiment-track.md). one-skill은 시험 적용 추천·미확정, OmniRoute는 보류 추천·미확정
**4) 해마 실험** (사용자 비유: 옵시디언=대뇌피질, claude-mem=해마) — [[Projects/brain-harness/Decisions#2026-10-18 — 실험: claude-mem을 해마(임시 일화 기억)로 — brain-harness만, 2주]], 기간 ~2026-11-01
- 조사: 태그 v14.0.1=88ebc94, main 4d99979와 관련 파일 차이 없음. brew는 Command Line Tools 14.3이 낡아 실패 → bun 1.4.3을 공식 릴리스 SHASUMS256·서명 확인 후 설치
- 플러그인 project scope(`.claude/settings.json`, ref v14.0.1, env로 텔레메트리 끔), `~/.claude-mem/settings.json`·`telemetry.json`. 스킬 27개(claude-mem:handoff 이름 겹침), 상시 약 2,500토큰
- `System/scripts/hippocampus-prune.sh`(30일, 일화 단위 CASCADE, 백업 3개) — 가짜 DB 시험 통과
**5) 유지보수 질문** → 3단계 ②로 유지보수 체계(Upstreams.md·upstream-check.sh·정기 점검 순서) 당김, Overview 3단계 순서 갱신. 결정 [[Projects/brain-harness/Decisions#2026-10-18 — 3단계에 유지보수 체계를 ②로 추가: 원본 목록·upstream-check·정기 점검 순서]]
## 바꾼 파일
- System/: commands/cross-review.md, Decisions.md, Rules.md, Environment.md, scripts/(doctor.sh, session-context.sh, precommit-check.sh·hippocampus-prune.sh·tests/precommit-check.test.sh 새)
- Projects/brain-harness/Decisions.md·Overview.md, .claude/settings.json(새), 이 세션 로그
- vault 밖: ~/.claude/settings.json(훅), ~/.bun, ~/.local/bin/bun·claude-mem, ~/.claude-mem/
## 검증
- 1): 문서 수정이라 빌드·린트 해당 없음. install-commands.sh로 반영. 2): `sh -n` 통과, 시험 저장소 13가지 기대대로, 실제 세션에서 차단·통과 확인
- 4): ~/Brain `claude -p`에서 worker·훅 동작, 바깥 폴더 세션은 미기록, ~/.zshrc·~/.claude/settings.json 그대로, doctor 경고 기존 2개(Codex)
- 교차 리뷰 표준(Codex gpt-5.6-terra, medium): 높음1 git 전역 옵션(-C·-c·--no-pager) 커밋 미감지 → 정규식 확장 반영. 참고 — 우회 문자열 위치 무관 통과 → 명령 앞 할당만 허용 반영. 참고 — 회귀 시험 없음 → precommit-check.test.sh 추가 반영. 직접 발견: `commit -C HEAD`의 -C 오인 → 수정. 16건 통과
## 막힌 점 / 확인 필요
- 한계(참고): 훅은 실행 전 상태를 봐서 `git reset … && git commit` 한 명령은 막힘 — 나눠 실행. Codex에는 아직 연결 안 됨
## 다음 세션에
- 해마 실험 측정: 주간 관찰 수·사용량·검색 비교·비밀 패턴 0건 → 11-01 판정
- 3단계 ② 유지보수 체계는 새 worktree에서. one-skill·OmniRoute 결정
- Codex hooks.json에 precommit-check 연결, 이후 ③ 비용 집계. push는 사람 승인
