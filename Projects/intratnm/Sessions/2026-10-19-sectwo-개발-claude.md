---
project: intratnm
date: 2026-10-19
agent: claude
worktree: sectwo/개발
summary: "사후 보안 리뷰 ③⑤⑥ 반영 · BRANDS 로고 통일·CHIYODA 사진·문구 다듬기·COMPANY 인사말 사진·주요 거래처 구현 · 표준 교차 리뷰 후 master 병합·push"
tags: [intratnm, session]
---
# 세션 — 2026-10-19 / sectwo/개발 / claude
(2026-10-18 늦은 밤 ~ 10-19)
## 한 일
- 사후 보안 교차 리뷰: Codex 표준(`gpt-5.6-terra`, medium, read-only). 대상 NOTICE 인증·notice-store·proxy·CONTACT API. 치명 0·높음 3·참고 3.
  - 높음: ① 관리자 로그인 시도 제한 없음 ② CONTACT 요청 수 제한 없음 ③ notice-store 읽기-수정-쓰기 경쟁·비원자적 쓰기.
  - 참고: ④ 무상태 토큰이라 로그아웃 후에도 12h 유효 ⑤ 상태 변경 API Origin 검사 없음 ⑥ 비밀번호 비교가 길이 다르면 조기 반환.
- 보안 ③⑤⑥ 반영(`a7670dc`): notice-store 쓰기 직렬화 + 임시파일 rename 원자적 쓰기(단일 프로세스 한정, 다중 프로세스면 DB),
  관리자 로그인·로그아웃·공지 쓰기 API `isSameOrigin` 검사, `checkPassword` SHA-256 해시 비교(async), `admin-auth` 주석 → proxy.ts.
  - 검증: 테스트 자격증명으로 `next start` 3002 — 다른/없는 Origin 403, 20건 동시 작성 보존, JSON 정상, 테스트 데이터 삭제.
  - Codex 가벼운 리뷰(`gpt-5.6-luna`, low) 치명·높음 0.
- 남은 보안(배포 서버 확정 후): ①로그인 시도 제한 ②CONTACT 요청 수 제한 ④토큰 무효화·비밀키 회전 절차.
- UI·콘텐츠 구현 5커밋:
  - `848ef39` BRANDS 로고 크기 통일(가로세로비 기준 면적 맞춤) + CHIYODA 사진 교체. `b7d2646` CHIYODA 배경 흰색 보정(`whiten` 옵션).
  - `f3d1c18` 브랜드 소개 문구 문법 15곳 다듬기(카플링 표기 유지) + 줄맞춤. `8a2e551` COMPANY 인사말에 요청자 사진(232.png).
  - `f275bda` COMPANY '주요 거래처' 섹션(`clientGroups`를 `company.ts`로 이동해 메인과 공유).
- Codex 표준 교차 리뷰(`gpt-5.6-terra`, medium) 위 5커밋: 치명·높음 0, 참고 2.
  - (a) BrandLogo `next/image` sizes — 반영: width/height를 표시 높이 56px 기준으로 넘겨 srcset 축소(`04f046b`).
  - (b) 자동 테스트 없음 — 사용자 결정으로 보류(테스트 도입은 배포 방식 정할 때 판단).
- 추가: 메인 NOTICE 폭 max-w-6xl 정렬(`2691c2e`). /handoff 뒤 CONTACT 2열(안내 카드+폼, 문의 유형 선택 칸, `195da78`) — Codex 가벼움(luna low) 치명 0, master 병합, push 대기.
- master fast-forward 병합 완료(master = `a7670dc`), 사용자 승인 후 push 완료(origin = master).  vault: Overview 브랜드 문구 동기화, Decisions에 문구 다듬기·`02_회사정보` 활용 항목 추가.
## 검증
- eslint·tsc·next build 통과. 데스크톱은 headless Chrome 캡처로 확인. 모바일은 headless 최소 창 너비 문제로 확인 불가.
## 함정 (지식 후보)
- dev 서버 두 개: 3000은 master 체크아웃, 3001은 worktree. 3000을 보면 변경이 안 보인다.
- 같은 경로로 이미지를 다시 만들면 next dev 이미지 캐시(`.next/dev/cache/images`)가 옛 이미지를 낸다 → 캐시 삭제.
- ScrollReveal 섹션은 headless 캡처에 안 보임 → Chrome `--force-prefers-reduced-motion`. chrome-devtools MCP는 다른 세션이 프로필을 잡으면 실패 → headless `--screenshot`.
- `codex exec`를 백그라운드/파이프로 돌리면 "Reading additional input from stdin"에서 멈춤 → `< /dev/null` 필요.
## 막힌 점 / 확인 필요
- 모바일 실제 확인, 관리자 화면 실제 로그인 확인(사람). 이전 막힌 점(배포 서버, 개인정보 동의 문구 등)은 [[Projects/intratnm/Handoff]] 그대로.
## 다음 할 일
- 모바일·관리자 로그인 실제 확인. 요청자에게 다듬은 문구 공유.
- `/handoff` 때: Handoff 8번(`02_회사정보`)은 결정 완료로 정리, 9번(push) 완료로 정리. [[Projects/intratnm/Knowledge/Brand-Images-Pipeline]]에 whiten·이미지 캐시 함정 추가 후보. codex stdin 함정은 L1 `Knowledge/Codex-Review-Output` 승격 후보.
