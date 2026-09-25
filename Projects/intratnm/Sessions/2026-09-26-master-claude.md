# 세션 — 2026-09-26 / master / claude

## 목표
Next.js 스캐폴딩 완료 + 홈페이지 제작요청자(이시영) 인터뷰로 Overview.md의 남은 확인 사항 채우기

## 완료한 일
- Next.js(App Router) + TypeScript + Tailwind CSS 스캐폴딩을 `~/orca/projects/intra-tnm`에 생성,
  기존 harness `AGENTS.md`/`CLAUDE.md`는 건드리지 않고 병합. `npm install`·`npm run build`·`npm run lint`
  모두 통과 확인 후 커밋(`0f6013f`).
- 기술 스택 결정(Next.js+TS+Tailwind) vault 커밋 (`80751ce`).
- 이시영 1차 인터뷰 진행 (하나씩 순서대로 질문하는 방식으로 전환, 상세는 [[Decisions#2026-09-26 —
  이시영 1차 인터뷰: 남은 확인 사항 정리]]):
  - 회사 연혁 2019년 확정(추가 없음), HERUTU 시작 연도 보류
  - 디자인 목업 없음 확인 → 콘텐츠 기획서의 구조·색상 설명을 디자인 브리프로 채택
  - 브랜드 로고 8개 전부 제조사 홈페이지에서 확보 필요, 카탈로그 URL 8개 전부 확정(HIOS: hios.com)
  - 레거시 사이트(`www.intratnm.com`) 직접 크롤링 → URYU/BIX/HIOS/CHIYODA/GOOT 5개 브랜드는 기존
    제품사진 재사용 승인, OHTAKE-ROOT/KTC/HERUTU 3개는 신규 확보 필요
  - NOTICE 자체 구현, CONTACT는 이메일 API(Resend 등), 지도는 카카오맵, 배포는 회사 자체 서버+기존
    도메인(`www.intratnm.com`) 유지, 모바일 반응형은 전체 페이지 적용
- `Overview.md`/`Decisions.md`에 위 내용 전부 반영.

## 바꾼 파일
- 저장소(`intra-tnm`): Next.js 스캐폴딩 17개 파일 (커밋 `0f6013f`)
- vault: `Overview.md`, `Decisions.md` 다수 수정 — 아직 커밋 전(이 세션 로그와 함께 커밋 예정)

## 막힌 점 / 확인 필요
- HERUTU 취급 시작 연도 — 계약일자 확인 필요 (이시영이 확인 예정)
- OHTAKE-ROOT / KTC / HERUTU 대표 제품사진 — 신규 확보 필요
- 배포 서버가 Node.js 실행 가능한지 정적 호스팅인지 — 이시영이 확인 예정. 확인 전까지 Node 서버
  배포를 기본 가정으로 개발 진행.

## 다음 할 일
- 위 3개 확인 사항 회신 오면 Overview.md 반영
- 실제 페이지 구현 시작 (COMPANY/BRANDS/NOTICE/CONTACT), 카카오맵 API 키 발급, Resend 연동 준비
- `/cross-review`는 아직 실행 안 함 — 스캐폴딩 diff가 작아서 필요성 낮다고 판단, 실제 페이지 구현이
  쌓이면 사람에게 강도 추천과 함께 제안
