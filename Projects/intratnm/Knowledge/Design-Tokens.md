---
project: intratnm
tags: [intratnm, knowledge, design]
source: Sessions 2026-09-26-design-refresh, 2026-10-01-master, 2026-10-02-master, 2026-10-03-master
---
# 디자인 토큰·공통 컴포넌트 현황

> 디자인 브리프 자체는 Overview "디자인" 절. 여기는 구현된 값과 그 근거만 적는다.

## 색 (`src/app/globals.css`)
- 팔레트: 다크 네이비(`--color-navy`) + 블루 포인트 + 화이트/라이트그레이. OS 다크모드 미디어쿼리는 제거(고정 팔레트).
- `--color-blue-accent`: `#2f6fed` → **`#0369a1`** (10-03). 회사 로고 기어 심볼 실측 `rgb(0,97,184)`≈`#0061b8`와
  같은 계열, ui-ux-pro-max "B2B Service" 팔레트 Accent 값 채택. 화이트 위 대비 약 5.93:1.
- `--color-blue-accent-on-navy`: 네이비 배경 전용 밝은 블루. `#60a5fa`(10-01 교차 리뷰로 신설, WCAG 4.5:1 미달
  해결) → **`#38bdf8`**(10-03, 대비 약 8.44:1). 네이비 위 eyebrow 텍스트 4곳(히어로·TRUSTED EXPERIENCE·CONTACT
  배너·PageHero)에 사용.
- 전역 13개 파일이 Tailwind `blue-accent` 토큰만 참조하므로 색은 `globals.css` 한 곳에서 바뀐다.

## 배경·모션
- `.bg-aurora`: 다중 radial-gradient 오로라 메시. 처음 18초 무한 루프였으나 ui-ux-pro-max UX 가이드("장식 요소에
  무한 애니메이션 금지")에 따라 **진입 시 3초 1회 정착**(`aurora-drift 3s ease-out 1 forwards`)으로 변경(10-02).
  `prefers-reduced-motion`이면 전역 규칙으로 정지. 구 `.bg-blueprint`/`.bg-glow`는 제거됨.
- `GearLineArt`: 장식 기어 선화 SVG(`aria-hidden`), 히어로 배경에 `opacity-40 blur-[1px]`.
- `ScrollReveal`(`src/components/ScrollReveal.tsx`): CSS + IntersectionObserver, 신규 의존성 없음. 기본 마크업에
  숨김 클래스가 없어 JS 미동작·IO 미지원 환경에서도 콘텐츠가 보인다. `stagger` prop을 켜면 내부
  `[data-reveal-item]`을 40ms 간격으로 순차 노출(OUR BRANDS·NOTICE). RAF ID 보관·취소, 정리 타이머는 RAF
  콜백 안에서 시작(10-03 교차 리뷰 반영, `909bddc`).

## 레이아웃·컴포넌트
- 글꼴: Pretendard(`next/font/local`). Geist는 라틴 전용이라 교체(09-26).
- `SectionHeading`(영문 eyebrow + accent bar + 큰 제목), `PageHero`(서브페이지 공통 히어로),
  `BrandShowcase`(브랜드 3단 배치: `Brand.tier` = `core`(URYU) / `major`(BIX·HIOS) / `standard`(나머지 5개);
  메인과 `/brands` 양쪽 재사용. 매출 비중 수치는 화면에 넣지 않음).
- 연혁(`/company#history`): 왼쪽 sticky 라벨 + 연도별 타임라인, 분류 칩은 `historyKind()`가 기존 문구를 키워드로
  분류한 파생값(새 사실 아님). 앵커 섹션에 `scroll-mt-[120px]`(sticky 헤더 65px + 서브내비 53px, 10-01).
- 로고: `public/brand/intra-logo.png`(기어 A 심볼, 2172×724 PNG). 검정+블루 배색이라 네이비 위에서는 흰 chip
  (`rounded-md bg-white`)에 얹어 사용. 로고 파일 자체는 수정하지 않는다.
- Header sticky + 활성 메뉴 표시, 모바일 햄버거(`MobileNavToggle`, `aria-expanded`). Footer 3열 그리드.
- 카드: `shadow-sm` + hover `-translate-y` + `shadow-lg/xl`, 링크 화살표 `group-hover:translate-x-1`(10-03).
  근거: ui-ux-pro-max "Minimalism & Swiss Style", "Bento Grid Showcase".

## 원칙 (사용자·요청자 확인)
- 팔레트와 메인페이지 섹션 순서·4메뉴 구조는 Overview 확정 사항 — 스킬 제안이 와도 고정. 스킬은 타이포·
  레이아웃·모션·접근성 디테일에만 쓴다("하이브리드", 10-01). 외부 템플릿 구조 도입은 보류(10-03).
- AI 생성 이미지: 자사용 장식(히어로 그래픽, OG, 텍스처)은 허용, 취급 브랜드 제품 묘사는 금지(10-03). 도구 미연결.
