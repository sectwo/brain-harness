---
project: intratnm
summary: "브랜드 로고·제품사진 생성 파이프라인(`scripts/brand-images.mjs`): 요청자 원본 위치·가공 규칙·사진 추가/교체 절차·NFD·EPIPE 함정"
source: intratnm 2026-10-18 sectwo/개발 세션 — [[Projects/intratnm/Sessions/2026-10-18-sectwo-개발-claude]]
tags: [intratnm, knowledge, images]
---
# 브랜드 이미지 파이프라인

<!-- 규칙: 60줄 이내, 한 주제 한 파일. 날짜별 경위는 Sessions, 결정 이유는 Decisions에 두고 여기엔 링크만. -->

## 언제 쓰나
- 요청자가 브랜드 로고·제품사진을 새로 보내거나 교체 요청에 따라 `public/brands/`를 다시 만들 때.
- `BrandLogo`·`ProductImage`가 쓰는 파일이 어디서 어떻게 생기는지 알아야 할 때.

## 방법
- 스크립트: 저장소 `scripts/brand-images.mjs` (`sharp` devDependency). 요청자 원본은 저장소 밖에 두고 환경 변수로 가리킨다.
  `BRAND_ASSETS_DIR=~/Brain/Projects/intratnm/INTRA_TNM_홈페이지_자료` (git 추적 제외, 원본은 절대 커밋하지 않는다).
- 원본 폴더는 **중첩 구조**다 — 스크립트 주석에도 명시.
  - 로고·브랜드 제품사진: `<dir>/INTRA_TNM_홈페이지_자료/02_브랜드자료/…`
  - URYU 제품군 사진: `<dir>/툴_photo/…`
- 제품사진 가공: 여백 trim → 4:3 흰 바탕 캔버스, 제품이 84% 차지, **원본 확대 없음**(작은 원본은 캔버스도 작아짐),
  최대 1200px, WebP q82.
- 로고 가공: trim(KTC·ECT는 색 바탕 유지), 높이 ≤240. 결과 크기를 `src/data/brand-logo-sizes.json`에 기록하고
  `BrandLogo`가 `next/image`의 width/height로 읽는다.
- 출력: `public/brands/<slug>/` (`logo.webp` + 모델별 파일).
- 안전장치: 실행 전 모든 원본 존재 여부를 먼저 확인하고, `public/brands.tmp`에 생성한 뒤 성공했을 때만 `public/brands`로 교체한다.
- 사진 추가·교체 절차:
  1. 스크립트 안의 목록에 항목 추가·수정 — 출력 경로, 원본 경로, (선택) 원본 픽셀 기준 crop 사각형.
  2. 스크립트 재실행(`BRAND_ASSETS_DIR=… node scripts/brand-images.mjs`).
  3. `src/data/brands.ts`의 해당 제품에 `image` 설정. `image`가 없으면 자리표시자(`BrandPhotoPlaceholder`)가 뜬다.

## 주의
- 한글 파일명 정규식 필터 → L1 [[System/Knowledge/macOS-Korean-Filename-NFD]].
- 스크립트 출력을 `head`로 파이프하면 도중에 EPIPE로 중단된다. 파일이나 `/dev/null`로 리다이렉트한다.
- 교체가 필요한 사진 목록(저해상도·배경 다름·묶음 이미지에서 잘라냄)은 [[Projects/intratnm/Handoff]] "막힌 점" 참고.

## 관련
- [[Projects/intratnm/Decisions#2026-10-18 — 요청자 최종 콘텐츠 기준안(10/16) 반영]] — 브랜드 10개, 시안은 배치 참고용·사진은 개별 파일
- [[Projects/intratnm/Sessions/2026-10-18-sectwo-개발-claude]] — 2단계 구현·교차 리뷰 경위
