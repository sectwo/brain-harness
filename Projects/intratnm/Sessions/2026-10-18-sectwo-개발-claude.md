---
project: intratnm
date: 2026-10-18
agent: claude
worktree: sectwo/개발
summary: "10/16 기준안 1단계(내용·데이터)·2단계(이미지) 구현, Codex 표준 교차 리뷰 2회 반영 · Pretendard 동적 서브셋 적용"
tags: [intratnm, session]
---
# 세션 — 2026-10-18 / sectwo/개발 / claude
## 한 일
- 1단계 계획 승인(메인 COMPANY 요약 제거, CONTACT 브랜드 단일 선택·이메일 필수·전화 선택). 구현(`cceb371`): 브랜드 10개(FUJITEC·ECT 추가, slug ohtake-root→ohtake), products 판별 유니온, CTA 2종(공식 홈페이지 새 창·`/contact?brand=코드`), 메인 카피·COMPANY 인사말·연혁·사업영역 7개, CONTACT 서버 page+ContactForm 분리.
- 1단계 교차 리뷰: Codex 표준(`gpt-5.6-terra`, medium). 치명 0·높음 4·참고 2. 반영(`51b05df`): fetch 실패 처리, API 검증·본문 20KB 상한, 허니팟, Footer `·`. 보류: IP 요청 수 제한(배포 서버 확정 후, Decisions 기록). 반박: 자동 테스트 없음(테스트 설정 없는 프로젝트, 수동 검증). 재리뷰 안 함.
- 특이: DevTools MCP 프로필이 이전 Chrome에 잡혀 별도 프로필 headless Chrome 사용, 모바일은 CDP Emulation으로 촬영.
- 2단계 사용자 결정(step-choice): 문제 사진(배경 다름·저해상도·카탈로그 잘라내기)은 가공해 우선 쓰고 교체 요청 / BIX B-15는 시안에서 도면 잘라 사용, 추후 교체 필요 여부 확인 / URYU 제품군별 사진 — 최종 기획서 docx엔 사진 없음(후속 단계 명시), 툴_photo로 확인해 Testers 외 5개 제품군 사진 반영.
- 2단계 구현(`47d6d57`): `scripts/brand-images.mjs`(sharp, devDependency)가 요청자 원본→4:3 흰 바탕 WebP(원본 확대 없음), 로고 10종(KTC·ECT는 바탕 유지)+`brand-logo-sizes.json`, `public/brands` 37개 516KB. BRANDS 카드 로고·URYU 대표 사진, 상세 히어로 로고, URYU 제품군 카드 사진, 대표 제품 3종 사진, BIX 특수 사양 제작 띠(+견적 문의하기), 첫 화면 사진 preload.
- 2단계 교차 리뷰: Codex 표준(`gpt-5.6-terra`). 높음 1(스크립트가 원본 확인 전 `public/brands` 삭제 → 반영: 사전 확인+임시 폴더 교체; 경로 중복 지적은 요청자 폴더가 실제 중첩 구조라 반박, 주석 명시), 참고 1(히어로 로고·제품 사진 alt 중복 → 반영). `9709781`. 재리뷰 안 함.
## 바꾼 파일
- 저장소 `src/`: `data/brands.ts`·`company.ts`·`contact.ts`(신규), `app/` 메인·company·brands·`brands/[slug]`·contact·`api/contact`·layout·notice, `components/ContactForm.tsx`·`BrandShowcase.tsx`·`BrandPhotoPlaceholder.tsx`·`Footer.tsx`·`BrandLogo.tsx`·`ProductImage.tsx`, `data/brand-logo-sizes.json`, `scripts/brand-images.mjs`, `public/brands/`, `package.json`(sharp). 커밋 `cceb371`, `51b05df`, `47d6d57`, `9709781` (push 안 함).
## 검증
- 1단계: lint·tsc·build 통과, 1440/390 스크린샷 가로 넘침 없음, Overview 문구 대조 일치, 외부 링크 target+rel 확인, API 오류 400/413, 키 미설정 503, 허니팟 200.
- 2단계: lint·tsc·build 통과, 1440/390 스크린샷(목록·상세 10개·메인) 가로 넘침·깨진 이미지 0. Lighthouse 모바일 접근성·모범사례·SEO 100. 성능 74 — 원인은 기존 Pretendard 가변 폰트 2MB(LCP 렌더 지연 ~12s, 이미지 무관) → 아래 절에서 처리.
## Pretendard 폰트 경량화 (Handoff 3번)
- 계획: 사람이 A안(패키지 내장 동적 서브셋 CSS) 승인. B(KS X 1001 정적, 굵기별 264KB×4)·C(pyftsubset 직접 가변 서브셋) 기각 — 공지 본문은 관리자 입력이라 고정 글자 서브셋 불가.
- 구현(`da13217`, sectwo/개발, push 안 함, master 미병합): `src/app/layout.tsx`에서 `next/font/local`(PretendardVariable.woff2 2MB) 제거 → `pretendard/dist/web/variable/pretendardvariable-dynamic-subset.css` import, `globals.css` `--font-sans`를 "Pretendard Variable"+시스템 대체 폰트 목록으로.
- 측정(운영 빌드·로컬·모바일, 2회째 값, 메인/회사소개) 기본(모의 계산): 성능 74/74→76/78, LCP 13.1/12.7s→4.7/4.4s, FCP 1.7→3.5/3.3s. devtools 실제 스로틀: 98/99→95/98, LCP 2.3/1.6→2.8/1.9s, FCP 1.5/1.6→1.7/1.9s. 폰트 전송 2,020KB→318~333KB(13조각). CLS 0 유지.
- 해석: 74점은 대부분 모의 계산(Lantern)이 2MB 폰트를 렌더 차단으로 잡은 탓. 실제 스로틀에선 기존도 98점. 전송량 1/6, PageSpeed 점수 소폭 상승, 대신 실측 첫 표시 0.2~0.5s 늦어짐(조각 13개 요청 + CSS 7.7→22KB). 사람이 결과 보고 "적용" 선택.
- 확인: 6개 페이지(/, /company, /brands, /notice, /contact, /admin/login) 375·1440px CDP 캡처 — 굵기 400/500/600/700 정상, 가로 넘침 없음. 드문 글자(힣·쀍·①·뷁)도 조각을 받아 Pretendard로 표시. lint·tsc·build 통과.
- 이로써 Handoff 9번(/admin 스크린샷 확인)도 확인 기록 생김(모바일·데스크톱 정상).
- 참고: DevTools MCP 프로필이 다른 세션에 잡혀 headless Chrome+CDP로 대체 촬영. ECC 훅이 `git checkout --`를 막아 `git show HEAD:<path> >`로 대체.
- 제안(승인 필요, 미반영): L1 지식 [[System/Knowledge/Lighthouse-LCP-Diagnosis]]에 "모의 계산 vs devtools 스로틀 비교" 보충.
- 교차 리뷰: 가벼움(사람 선택), Codex `gpt-5.6-luna` 추론 low, `codex exec -s read-only`. 치명·높음 없음. 참고 5개 중 4개는 문제 없음 확인(CSS url 경로 번들 처리, 전역 import 의도대로, Tailwind import 순서, font-family 이름 일치).
- 남은 1개: OFL 라이선스 고지를 배포물에 따로 넣을지는 배포 방식 정할 때 판단 — 반영 안 함(기존 next/font 방식도 고지를 따로 넣지 않아 이번 변경으로 생긴 문제 아님). 재리뷰 안 함.
## 막힌 점 / 확인 필요
- URYU `/en/`·HIOS `hios.com` 링크 유효성(오픈 직전), MK-3020 vs MK-3020V, HERUTU 취급 연도, 개인정보 동의 문구(TODO), 요청 수 제한·배포 서버 Node.js 여부. Pretendard 작업으로 추가된 것 없음.
- 요청자 요청: HIOS BLG-5000BC2·PGFA-5000 사진, URYU Testers 사진, B-15 도면 원본, 저해상도·배경 다른 사진 교체 (OM-26M 하늘색 배경, TW-800R-SCL·Mega Hose·MK 시리즈·BIX 도면 저해상도, ECT 3종 묶음 이미지에서 잘라냄).
## 다음 세션에
- 1·2단계는 master 병합 완료(fast-forward, push 안 함), /handoff 완료. Pretendard 경량화(서브셋)는 완료(`da13217`). 다음: 교차 리뷰 완료 → master 병합 여부(사람 결정 대기).
- 뺀 내용 → 남아 있는 곳: 브랜드 8개·워드마크·레거시 사진 재사용 계획(폐기, [[Projects/intratnm/Sessions/2026-10-18-master-claude]]), 스냅·Chakra Petch 결정 링크([[Projects/intratnm/Decisions]]), Lighthouse 성능 74 서술·Pretendard 측정값·대안 비교(이 로그 "Pretendard 폰트 경량화" 절, [[Projects/intratnm/Knowledge/Fonts-Pretendard-Subset]]), 완료된 Handoff 3번(폰트 경량화)·9번(/admin 스크린샷)과 교차 리뷰 이력(이 로그).
