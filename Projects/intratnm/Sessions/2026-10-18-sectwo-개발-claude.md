---
project: intratnm
date: 2026-10-18
agent: claude
worktree: sectwo/개발
summary: "10/16 기준안 1단계(내용·데이터)·2단계(이미지) 구현, Codex 표준 교차 리뷰 2회 반영"
tags: [intratnm, session]
---
# 세션 — 2026-10-18 / sectwo/개발 / claude
## 한 일
- 1단계 계획 사용자 승인. 메인 COMPANY 요약 섹션 제거(기준안 순서). 기본값: CONTACT 브랜드 단일 선택, 이메일 필수·전화 선택.
- 1단계 구현(`cceb371`): 브랜드 10개(FUJITEC·ECT 추가, slug ohtake-root→ohtake), products 판별 유니온, CTA 2종
  (공식 홈페이지 새 창·`/contact?brand=코드`), 메인 카피·COMPANY 인사말·연혁·사업영역 7개, CONTACT 서버 page+ContactForm 분리.
- 1단계 교차 리뷰: Codex 표준(`gpt-5.6-terra`, medium). 치명 0·높음 4·참고 2. 반영(`51b05df`): fetch 실패 처리,
  API 검증·본문 20KB 상한, 허니팟, Footer `·`. 보류: IP 요청 수 제한(배포 서버 확정 후, Decisions 기록).
  반박: 자동 테스트 없음(테스트 설정 없는 프로젝트, 수동 검증). 재리뷰 안 함.
- 특이: DevTools MCP 프로필이 이전 Chrome에 잡혀 별도 프로필 headless Chrome 사용, 모바일은 CDP Emulation으로 촬영.
- 2단계 사용자 결정(step-choice): 문제 사진(배경 다름·저해상도·카탈로그 잘라내기)은 가공해 우선 쓰고 교체 요청 /
  BIX B-15는 시안에서 도면 잘라 사용, 추후 교체 필요 여부 확인 / URYU 제품군별 사진 — 최종 기획서 docx엔 사진 없음
  (후속 단계 명시), 툴_photo로 확인해 Testers 외 5개 제품군 사진 반영.
- 2단계 구현(`47d6d57`): `scripts/brand-images.mjs`(sharp, devDependency 추가)가 요청자 원본→4:3 흰 바탕 WebP(원본 확대 없음),
  로고 10종(KTC·ECT는 바탕 유지)+`brand-logo-sizes.json`, `public/brands` 37개 516KB. BRANDS 카드 로고·URYU 대표 사진,
  상세 히어로 로고, URYU 제품군 카드 사진, 대표 제품 3종 사진, BIX 특수 사양 제작 띠(+견적 문의하기), 첫 화면 사진 preload.
- 2단계 교차 리뷰: Codex 표준(`gpt-5.6-terra`). 높음 1(스크립트가 원본 확인 전 `public/brands` 삭제 → 반영: 사전 확인+임시 폴더 교체;
  경로 중복 지적은 요청자 폴더가 실제 중첩 구조라 반박, 주석 명시), 참고 1(히어로 로고·제품 사진 alt 중복 → 반영). `9709781`. 재리뷰 안 함.
## 바꾼 파일
- 저장소 `src/`: `data/brands.ts`·`company.ts`·`contact.ts`(신규), `app/` 메인·company·brands·`brands/[slug]`·contact·`api/contact`·layout·notice,
  `components/ContactForm.tsx`·`BrandShowcase.tsx`·`BrandPhotoPlaceholder.tsx`·`Footer.tsx`·`BrandLogo.tsx`·`ProductImage.tsx`,
  `data/brand-logo-sizes.json`, `scripts/brand-images.mjs`, `public/brands/`, `package.json`(sharp). 커밋 `cceb371`, `51b05df`, `47d6d57`, `9709781` (push 안 함).
## 검증
- 1단계: lint·tsc·build 통과, 1440/390 스크린샷 가로 넘침 없음, Overview 문구 대조 일치, 외부 링크 target+rel 확인, API 오류 400/413, 키 미설정 503, 허니팟 200.
- 2단계: lint·tsc·build 통과, 1440/390 스크린샷(목록·상세 10개·메인) 가로 넘침·깨진 이미지 0. Lighthouse 모바일 접근성·모범사례·SEO 100.
  성능 74 — 원인은 기존 Pretendard 가변 폰트 2MB(모든 페이지 LCP 렌더 지연 ~12s, 이미지 무관), 별도 과제.
## 막힌 점 / 확인 필요
- URYU `/en/`·HIOS `hios.com` 링크 유효성(오픈 직전), MK-3020 vs MK-3020V, HERUTU 취급 연도, 개인정보 동의 문구(TODO), 요청 수 제한·배포 서버 Node.js 여부.
- 요청자 요청: HIOS BLG-5000BC2·PGFA-5000 사진, URYU Testers 사진, B-15 도면 원본, 저해상도·배경 다른 사진 교체
  (OM-26M 하늘색 배경, TW-800R-SCL·Mega Hose·MK 시리즈·BIX 도면 저해상도, ECT 3종 묶음 이미지에서 잘라냄).
## 다음 세션에
- Pretendard 폰트 경량화(서브셋) 검토, master 병합 여부 사람 확인, `/handoff`.
