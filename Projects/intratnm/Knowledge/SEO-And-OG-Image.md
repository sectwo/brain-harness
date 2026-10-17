---
project: intratnm
tags: [intratnm, knowledge, seo, nextjs]
source: Sessions 2026-10-03-master
---
# SEO 기본·OG 이미지 구현 (intratnm)

> 2026-10-03 `feat/seo-basics`(`312639d`, `0529059`)와 개편 4단계(`13b810b`, `0d11f9d`)에서 구현한 것.
> 파일: `src/app/sitemap.ts`, `src/app/robots.ts`, `src/app/opengraph-image.tsx`, `src/app/layout.tsx`.

## 구성
- **sitemap**: 공개 페이지 + 브랜드 8개 + 공지. 공지 저장소(`.data/notices.json`)가 손상돼 있으면 공지만 빼고
  응답한다(교차 리뷰 반영 — 전체 sitemap이 500으로 죽지 않게).
- **robots**: `/admin`·`/api` 차단. 관리자 페이지는 metadata에서도 noindex.
- **metadataBase**: `NEXT_PUBLIC_SITE_URL`. 빈 값·잘못된 값이면 `https://www.intratnm.com`으로 대체(교차 리뷰 반영).
- **CONTACT metadata**: 폼이 클라이언트 페이지라 `metadata`를 export할 수 없었음 → `src/app/contact/layout.tsx`
  서버 레이아웃을 두어 title·description을 부여(AGENTS.md SEO 게이트 충족).
- **한글 줄바꿈**: 전역 `word-break: keep-all`. 리뷰 반영으로 적용 범위를 완화함(`0529059`).

## OG 이미지 (`opengraph-image.tsx`) 특이점
- Next.js OG 라우트에서는 `react-dom/server`(renderToStaticMarkup 등)를 import할 수 없다 → 기어 선화를
  `gearLineArtSvg()`가 반환하는 **정적 SVG 문자열**로 분리해 넣는다. 화면용 `GearLineArt` React 컴포넌트와 별도.
- OG 렌더러(Satori)는 한글 어절 단위 줄바꿈을 지원하지 않는다 → 슬로건을 **어절마다 `span`**으로 쪼개 넣는다.
- `export const runtime = "nodejs"`를 명시한다 — 생략하면 Edge 런타임을 가정할 수 있다는 교차 리뷰 지적(`0d11f9d`).
- 디자인: 기어 선화 + 회사 로고 + 슬로건, 개편 A안 톤(네이비 + 블루 액센트).

## 검증 (10-03, 운영 빌드·모바일 Lighthouse)
`/`, `/company`, `/brands`, `/brands/uryu`, `/notice`, `/contact` — 접근성·모범 사례·SEO 100. 메인 LCP 129ms, CLS 0.
Lighthouse 지적 2건(링크 문구에 sr-only 맥락, 오시는 길 `dl` 구조)은 4단계에서 수정.

## 출처
- [[Sessions/2026-10-03-master-claude]] — "SEO 기본 + 정리", "4단계 — 마무리"
