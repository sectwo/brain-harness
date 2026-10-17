---
level: 1
tags: [system, projects]
---
# Projects — 프로젝트 지도

> `/new-project`가 행을 추가한다. 상태가 크게 바뀌면 `/handoff` 때 갱신한다.

| 프로젝트 | vault | 저장소 | 상태 | 비고 |
|---|---|---|---|---|
| brain-harness | [[Projects/brain-harness/Handoff]] | `~/Brain` | 로드맵 3단계 진행 중 — ① 자동 점검 완료, 실험 2개(claude-mem 해마·task-observer) 진행, 다음 ② 유지보수 체계 (2026-10-18) | 브레인 하네스 자체(vault·`~/.claude`·`~/.codex` 설정·스크립트). intratnm에서 분리. 로드맵은 [[Projects/brain-harness/Overview]], 2단계 설계는 [[docs/stage2-record-structure]], 방향 결정은 [[Projects/brain-harness/Decisions#2026-10-18 — 플랫폼 방향 회의: 종류별 팩·지식 후보함·기반 우선 로드맵]] |
| intratnm | [[Projects/intratnm/Handoff]] | `~/orca/projects/intra-tnm` | 1차 구현 + UI/UX 개편 완료 (배포 전 확인 대기) | 회사 intratnm 홈페이지. Next.js 16+TS+Tailwind, 전 페이지 구현·개편 A안·SEO 기본·Lighthouse 100(a11y/SEO) 반영, origin 동기화. 배포 서버 Node.js·빌드 머신 인터넷·로고/사진·동의 문구 대기 (2026-10-17) |
