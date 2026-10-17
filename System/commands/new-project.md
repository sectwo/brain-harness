---
description: 하네스 트리에 새 프로젝트(L2)를 만든다 — vault 폴더, 저장소 연결 파일, 프로젝트 AGENTS.md 틀
---
`~/Brain/System/Rules.md` 1절(하네스 트리)을 따른다. 인수: 프로젝트 이름(vault 폴더명, 영문 소문자·하이픈 권장). 없으면 묻는다.

1. **계획을 먼저 보여 주고 확인을 받는다.** 만들 파일 목록, 저장소 경로, 프로젝트 이름.
   `~/Brain/Projects/<이름>/`이 이미 있으면 덮어쓰지 않고 멈춘다.
2. **vault (L2·L3)**: `~/Brain/System/Templates/Project/`를 `~/Brain/Projects/<이름>/`로 복사하고
   파일 안의 `{{project}}`, `{{repo}}`(저장소 절대 경로), `{{date}}`(오늘)를 바꾼다.
3. **저장소 연결**
   - 루트에 `.harness-project` (내용: `<이름>` 한 줄)
   - `AGENTS.md`: 맨 위에 "L1 공통 규칙 `~/Brain/System/Rules.md`를 먼저 읽고 따른다. 이 파일은 프로젝트 고유 규칙만 담는다."
     그 아래 프로젝트 목적, vault 경로, 추가 품질 게이트, 고유 규칙만 쓴다. 공통 규칙은 반복하지 않는다.
   - `CLAUDE.md`: `@AGENTS.md`와 `@~/Brain/Projects/<이름>/Handoff.md`만 import. `Overview.md`는 import하지 않는다 —
     세션 시작 맥락의 색인에 절 제목이 나오고, 필요한 절만 찾아 읽는다 (Rules 2절)
   - `.claude/settings.json`: `permissions.additionalDirectories`에 vault 경로. 전역에 있는 훅·명령은 넣지 않는다.
4. **L1 갱신**: `~/Brain/System/Projects.md`에 행 추가.
5. **Codex 쓰기 권한 안내**: `~/.codex/config.toml`과 Orca `codex-runtime-home/home/config.toml`의
   `writable_roots`에 vault 경로 추가가 필요하다고 알린다 (전역 설정이므로 사람 확인 후, 백업하고 수정).
6. 결과를 요약하고, 다음 단계로 사람이 `Overview.md`를 채우도록 안내한다.

$ARGUMENTS
