---
project: intratnm
summary: "브랜드 로고·제품사진·COMPANY 인사말 사진 생성 파이프라인(`scripts/brand-images.mjs`·`company-images.mjs`): 요청자 원본 위치·가공 규칙(`whiten` 배경 보정 포함)·사진 추가/교체 절차·NFD·EPIPE·dev 이미지 캐시 함정"
source: intratnm 2026-10-18·10-19 sectwo/개발 세션 — [[Projects/intratnm/Sessions/2026-10-18-sectwo-개발-claude]], [[Projects/intratnm/Sessions/2026-10-19-sectwo-개발-claude]]
tags: [intratnm, knowledge, images]
---
# 브랜드 이미지 파이프라인

<!-- 규칙: 60줄 이내, 한 주제 한 파일. 날짜별 경위는 Sessions, 결정 이유는 Decisions에 두고 여기엔 링크만. -->

## 언제 쓰나
- 요청자가 브랜드 로고·제품사진을 새로 보내거나 교체 요청에 따라 `public/brands/`를 다시 만들 때.
- `BrandLogo`·`ProductImage`가 쓰는 파일, COMPANY 인사말 사진(`public/company/greeting.webp`)이 어디서 어떻게 생기는지 알아야 할 때.

## 방법
- 스크립트: 저장소 `scripts/brand-images.mjs` (`sharp` devDependency). 요청자 원본은 저장소 밖에 두고 환경 변수로 가리킨다.
  `BRAND_ASSETS_DIR=~/Brain/Projects/intratnm/INTRA_TNM_홈페이지_자료` (git 추적 제외, 원본은 절대 커밋하지 않는다).
- 원본 폴더는 **중첩 구조**다 — 스크립트 주석에도 명시.
  - 로고·브랜드 제품사진: `<dir>/INTRA_TNM_홈페이지_자료/02_브랜드자료/…`
  - URYU 제품군 사진: `<dir>/툴_photo/…`
- 제품사진 가공: 여백 trim → 4:3 흰 바탕 캔버스, 제품이 84% 차지, **원본 확대 없음**(작은 원본은 캔버스도 작아짐),
  최대 1200px, WebP q82.
- 제품 항목 튜플: `[출력 경로, 원본 경로, (선택) 원본 픽셀 기준 crop 사각형, (선택) 옵션]`.
  - 옵션 `{ whiten: true }`: 회색빛 배경을 흰색으로 보정한다. 채도가 낮고 밝은 픽셀만 밝기에 비례해 흰색으로 밀고
    색이 있거나 어두운 제품 픽셀은 그대로 둔다. 가장자리 28px 띠는 흰색으로 서서히 흐려 잘린 경계가 보이지 않게 한다.
    CHIYODA 3종(제품 3종 시안 v1에서 crop)에 사용 중.
- 로고 가공: trim(KTC·ECT는 색 바탕 유지), 높이 ≤240. 결과 크기를 `src/data/brand-logo-sizes.json`에 기록하고
  `BrandLogo`가 `next/image`의 width/height로 읽는다(표시 높이 기준으로 srcset 축소). 카드 로고는 가로세로비 기준 면적을 맞춰 통일.
- 출력: `public/brands/<slug>/` (`logo.webp` + 모델별 파일).
- 안전장치: 실행 전 모든 원본 존재 여부를 먼저 확인하고, `public/brands.tmp`에 생성한 뒤 성공했을 때만 `public/brands`로 교체한다.
- 사진 추가·교체 절차:
  1. 스크립트 안의 목록에 항목 추가·수정 — 출력 경로, 원본 경로, (선택) crop 사각형, (선택) `{ whiten: true }`.
  2. 스크립트 재실행(`BRAND_ASSETS_DIR=… node scripts/brand-images.mjs`).
  3. `src/data/brands.ts`의 해당 제품에 `image` 설정. `image`가 없으면 자리표시자(`BrandPhotoPlaceholder`)가 뜬다.
- COMPANY 인사말 사진: `scripts/company-images.mjs`가 `01_회사자료/02_회사정보/232.png`의 흰 액자·반사를 잘라내고 2배 확대해
  `public/company/greeting.webp`로 만든다(같은 `BRAND_ASSETS_DIR`). 저해상도라 작게만 쓰고 모바일에서는 숨긴다.

## 주의
- 한글 파일명 정규식 필터 → L1 [[System/Knowledge/macOS-Korean-Filename-NFD]].
- 스크립트 출력을 `head`로 파이프하면 도중에 EPIPE로 중단된다. 파일이나 `/dev/null`로 리다이렉트한다.
- **같은 경로로 이미지를 다시 만들면** 떠 있는 `next dev`가 `.next/dev/cache/images`의 옛 최적화 이미지를 계속 낸다 → 그 폴더를 지운다.
  체크아웃마다 캐시가 따로 있다(master 체크아웃은 3000, worktree는 3001 — 3000을 보면 worktree 변경이 안 보인다).
- 교체가 필요한 사진 목록(저해상도·배경 다름·묶음 이미지에서 잘라냄)은 [[Projects/intratnm/Handoff]] "막힌 점" 참고.

## 관련
- [[Projects/intratnm/Decisions#2026-10-18 — 요청자 최종 콘텐츠 기준안(10/16) 반영]] — 브랜드 10개, 시안은 배치 참고용·사진은 개별 파일
- [[Projects/intratnm/Decisions#2026-10-19 — 02_회사정보 자료 활용: COMPANY 인사말 사진 · 주요 거래처 섹션]] — 인사말 사진 가공·배치 이유
- [[Projects/intratnm/Sessions/2026-10-18-sectwo-개발-claude]] — 2단계 구현·교차 리뷰 경위
