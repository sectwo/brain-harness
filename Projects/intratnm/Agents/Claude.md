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
