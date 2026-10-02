---
project: intratnm
tags: [intratnm, knowledge, design]
source: Sessions 2026-09-26-design-refresh, 2026-10-01-master, 2026-10-02-master, 2026-10-03-master
---
# 디자인 토큰·공통 컴포넌트 현황

> 디자인 브리프 자체는 Overview "디자인" 절. 2026-10-03 UI/UX 개편(A안) 이후 **기준 문서는 저장소의
> `design-system/intra-tnm/MASTER.md`**(`/Users/isaac/orca/projects/intra-tnm/design-system/intra-tnm/MASTER.md`)다.
> 값의 원천은 `src/app/globals.css`와 `src/components/*`이며, 문서와 코드가 다르면 코드가 맞다.
> 여기는 vault에서 빨리 찾을 요약과 결정 근거만 적고, 표·수치 상세는 MASTER.md와 중복해서 적지 않는다.

## 방향 (2026-10-03 개편, 사용자 결정)
- **정밀 산업 스위스 미니멀** 한 가지. 다크 네이비 + 블루 단일 액센트, 화이트/라이트그레이 교차(Overview 확정 톤).
  "정밀"은 색이 아니라 디테일(눈금·헤어라인·인덱스 번호·tabular 숫자·기어 선화)로 표현.
- 쓰지 않는 것: 알약 모양 버튼·칩, 큰 그림자·hover 들썩임, 제3의 강조색, 그라디언트 글자, 이모지 아이콘,
  글래스모피즘, 무한 반복 장식 애니메이션, 풀페이지 스냅(시험 후 기각), 모션 라이브러리(GSAP 미도입).
  근거는 [[Decisions#2026-10-03 — UI/UX 개편 A안: 정밀 산업 스위스 미니멀]].

## 색 (`src/app/globals.css`)
- 토큰: `navy`(`#0b1830`) / `navy-deep`(Footer) / `navy-soft` / `blue-accent`(`#0369a1`) / `blue-accent-hover` /
  `blue-accent-on-navy`(`#38bdf8`) / `light-gray` / `ink`·`ink-secondary`·`ink-muted` / `line`·`line-strong` / `danger`.
  값·대비 전수는 MASTER.md 2절.
- `blue-accent` `#0369a1`의 근거(10-03 오전): 회사 로고 기어 심볼 실측 `rgb(0,97,184)`≈`#0061b8`과 같은 계열,
  ui-ux-pro-max "B2B Service" 팔레트 Accent 값. 화이트 위 5.93:1.
- `blue-accent-on-navy`: 네이비 위 전용 밝은 블루(10-01 교차 리뷰로 신설, 10-03 `#38bdf8`). 네이비 위에서
  `blue-accent`는 4.5:1 미달이라 쓰지 않는다. 대비는 MASTER.md 기준 8.25:1(네이비 `#0b1830` 기준; 개편 전
  세션 로그의 8.44:1은 이전 네이비 값 기준으로 보임 — 코드 기준 문서를 따른다).
- 주의: `ink-muted`는 라이트그레이 위에서 4.3:1이라 사용 금지(MASTER.md).
- 전역이 Tailwind 토큰만 참조하므로 색은 `globals.css` 한 곳에서 바뀐다.

## 타이포·간격
- Pretendard Variable 전체. 예외는 히어로 배경 회사명 한 곳 — **Chakra Petch 700**(`next/font/google`, 빌드 시
  자체 호스팅 → 빌드 머신 인터넷 필요). 서체 선정 경위는 [[Decisions#2026-10-03 — 히어로 회사명 서체 Chakra Petch]].
- 유틸 `text-display / h1 / h2 / h3 / lead / eyebrow`, 숫자 `tabular-nums`, 한글 `keep-all`, 제목 `text-wrap: balance`.
- 모서리: 칩 4px(`rounded-chip`), 버튼·입력 6px(`rounded-control`), 카드 8px(`rounded-card`). 그림자 없음,
  hover는 테두리 `blue-accent` + 1px 위로.

## 그래픽·모션
- 메인 히어로: 오로라(진입 시 3초 1회 정착, 10-02) + 기어 2개·눈금 링 선화(`GearLineArt`) + 배경 회사명
  "INTRA T&M"(채움 4~12%·외곽선 20%). 스크롤 연동: 큰 기어 40°·작은 기어 24:14 비율 반대 회전, 회사명
  왼쪽으로 밀리며 옅어짐(`ScrollProgressVar`). 자유 스크롤 유지 —
  [[Decisions#2026-10-03 — 풀페이지 스냅 기각, 자유 스크롤 + 히어로 스크롤 연동]].
- `ScrollReveal`(CSS + IntersectionObserver, 신규 의존성 없음): variant로 섹션별 효과(페이드·그리드 50ms·
  리스트 30ms 스태거·헤어라인 드로우). JS 미동작·IO 미지원 환경에서도 콘텐츠가 보인다. RAF 취소·정리 타이머
  처리는 10-03 교차 리뷰 반영(`909bddc`).
- OG 이미지(`src/app/opengraph-image.tsx`): `gearLineArtSvg()` 정적 SVG(Next가 OG 라우트에서
  `react-dom/server`를 막아 분리) + 로고 + 슬로건. `runtime = "nodejs"` 명시(10-03 리뷰 반영). OG 렌더러는
  한글 어절 줄바꿈을 못 해 어절 단위 `span`으로 넣는다.
- `prefers-reduced-motion`이면 모든 효과를 끄고 최종 상태.

## 레이아웃·컴포넌트 (요약)
- `Button`(variant primary/secondary/ghost, tone light/dark, 외부 링크 시 새 창 + `rel` + 아이콘 + sr-only 문구),
  `SectionHeading`(액센트 바 그어짐 + 영문 라벨 + 제목), `PageHero`(서브페이지, 눈금 격자), `BrandShowcase`
  (`Brand.tier` core/major/standard 3단, 인덱스 01~08 = 노출 순서), `BrandPhotoPlaceholder`(사진 확보 전 자리),
  `icons.tsx`(인라인 SVG, 외부 패키지 없음).
- Header: **흰 배경** + 하단 헤어라인, 로고 원본 그대로(배경판 없음), 문의 버튼 없음(사용자 결정). 개편 전의
  "네이비 헤더 + 흰 chip 위 로고"는 폐기. Footer: `navy-deep` 3열, 웹 주소 미표시.
- 로고 파일 `public/brand/intra-logo.png`(기어 A 심볼, 2172×724 PNG)는 수정하지 않는다.
- 연혁(`/company#history`): 분류 칩은 `historyKind()` 파생값(새 사실 아님). 앵커 `scroll-mt`는 헤더 높이에 맞춤.

## 원칙 (사용자·요청자 확인)
- 팔레트와 메인페이지 섹션 순서·4메뉴 구조는 Overview 확정 사항 — 스킬 제안이 와도 고정. 스킬은 타이포·
  레이아웃·모션·접근성 디테일에만 쓴다("하이브리드", 10-01). 외부 템플릿 구조 도입은 보류(10-03).
- AI 생성 이미지: 자사용 장식(히어로 그래픽, OG, 텍스처)은 허용, 취급 브랜드 제품 묘사는 금지(10-03). 도구 미연결.
- 디자인 변경 시 검증 순서(lint → tsc → build → 1440/375px → 대비 전수 → 회사 정보 대조)는 MASTER.md 8절.
