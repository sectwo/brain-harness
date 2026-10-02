---
project: intratnm
agent: claude
tags: [intratnm, agent]
---
# Claude — intratnm (L3)

> 이 프로젝트에서 Claude Code의 역할, 설정, 알게 된 특이점. 공통 설정은 [[System/Environment]].

## 역할
- 계획·구조 설계, 구현, Codex 구현분 교차 리뷰, `/handoff` 실행

## 설정
- 프로젝트 `.claude/settings.json`: `ANTHROPIC_BASE_URL=http://localhost:8787`(Headroom), vault 접근
- 전역: `opusplan`, 상태줄·세션 훅 (적용 여부는 [[System/Environment]])

## 알게 된 점
- ECC GateGuard가 첫 Bash·첫 파일 수정·삭제 명령마다 사실 확인을 요구한다 → [[System/Knowledge/ECC-GateGuard]]
- Headroom이 Bash 출력을 압축한다. 정확한 원문은 Read로 → [[System/Knowledge/Headroom-Output-Compression]]
- auto mode 권한 검사가 `~/.claude/settings.json` 수정(자기 설정 변경)과 launchd 상주 작업 등록을 막는다. 전역 설정 변경은 사람이 직접 실행한다.
- **플러그인은 세션 중 설치해도 스킬 레지스트리에 안 잡힌다**(10-01). `claude plugin disable/enable` 토글도 소용없고,
  "이어서 진행"으로는 프로세스가 안 바뀐다 — `kill <pid>` 후 완전히 새 프로세스로 재실행해야 로드된다.
- Skill 도구에서 `design` 이름은 Claude 내장 "Design" 아티팩트 기능과 겹쳐 `disable-model-invocation`으로
  거부된다. ui-ux-pro-max는 네임스페이스 포함 전체 이름(`ui-ux-pro-max:ui-ux-pro-max`)으로 호출한다.
  DB 매치가 0건이면 "매치 없음"으로 명시하고 지어내지 않는다.
- Chrome DevTools MCP 특이점: `fullPage` 스크린샷은 리사이즈가 빨라 IntersectionObserver·sticky 요소가
  실제와 다르게 찍힌다(빈 섹션, 중복 렌더처럼 보임) — 실제 스크롤 시뮬레이션으로 재확인한다.
  `resize_page` 390px 요청이 실제로는 500px로 렌더된 적이 있다(10-03).
- 로컬에 ImageMagick·Pillow가 없다. 이미지 색 실측은 DevTools `evaluate_script`로 캔버스에 그려 `getImageData`로 했다(10-03).
- `codex review`/`codex exec` 출력은 `head -c`로 자르지 않는다 — Codex가 시작 시 세션 맥락을 읽는 양이 많아
  절단 지점이 깨진 JSON처럼 보인다. 파일로 리다이렉트해 끝까지 받는다(10-02).
- 세션 압축(compaction) 사이에 백그라운드 출력 임시 파일이 사라져 Codex 리뷰를 재실행한 적이 있다(10-01).
  리뷰 결과는 바로 세션 로그에 옮긴다.
- vault 기록·커밋은 Fable 하위 에이전트가 맡는다(10-03, [[System/Rules]] 5절). 메인 세션은 Opus 5.5.
