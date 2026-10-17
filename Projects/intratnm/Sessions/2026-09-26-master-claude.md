---
project: intratnm
date: 2026-09-26
agent: claude
worktree: master
summary: "Next.js 스캐폴딩, 요청자 인터뷰 반영, COMPANY 페이지·NOTICE 1차 구현, 실명 제거, Fable 문서 정합성 리뷰"
tags: [intratnm, session]
---
# 세션 — 2026-09-26 / master / claude

## 목표
Next.js 스캐폴딩 완료 + 홈페이지 제작요청자(요청자) 인터뷰로 Overview.md의 남은 확인 사항 채우기

## 완료한 일
- Next.js(App Router) + TypeScript + Tailwind CSS 스캐폴딩을 `~/orca/projects/intra-tnm`에 생성,
  기존 harness `AGENTS.md`/`CLAUDE.md`는 건드리지 않고 병합. `npm install`·`npm run build`·`npm run lint`
  모두 통과 확인 후 커밋(`0f6013f`).
- 기술 스택 결정(Next.js+TS+Tailwind) vault 커밋 (`80751ce`).
- 요청자 1차 인터뷰 진행 (하나씩 순서대로 질문하는 방식으로 전환, 상세는 [[Projects/intratnm/Decisions#2026-09-26 —
  요청자 1차 인터뷰: 남은 확인 사항 정리]]):
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
- HERUTU 취급 시작 연도 — 계약일자 확인 필요 (요청자가 확인 예정)
- OHTAKE-ROOT / KTC / HERUTU 대표 제품사진 — 신규 확보 필요
- 배포 서버가 Node.js 실행 가능한지 정적 호스팅인지 — 요청자가 확인 예정. 확인 전까지 Node 서버
  배포를 기본 가정으로 개발 진행.

## 다음 할 일 (1차 마무리 시점 — 아래 "이어서" 참고)
- 위 3개 확인 사항 회신 오면 Overview.md 반영
- 실제 페이지 구현 시작 (COMPANY/BRANDS/NOTICE/CONTACT), 카카오맵 API 키 발급, Resend 연동 준비
- `/cross-review`는 아직 실행 안 함 — 스캐폴딩 diff가 작아서 필요성 낮다고 판단, 실제 페이지 구현이
  쌓이면 사람에게 강도 추천과 함께 제안

## 이어서 (같은 세션, 압축 후 재개)

### 완료한 일
- Fable(리뷰 전용 서브에이전트)로 설계 문서(Overview·Decisions·README) 정합성 리뷰 → 발견된 모순
  직접 수정, 사실 확인이 필요한 항목은 요청자에게 하나씩 순서대로 질문 (→ [[Projects/intratnm/Decisions#2026-09-26 —
  Fable 리뷰 반영: 문서 정합성 정리]], [[Projects/intratnm/Decisions#2026-09-26 — 요청자 2차 인터뷰: Fable 리뷰 남은
  확인 사항 정리]]). NOTICE가 회사 직원 직접 작성으로 정해지며 배포 서버 Node.js 지원 여부 확인이
  최우선 과제로 올라감.
- **요청자 실명 제거**: 사람이 "이시영이라는 이름이 커밋에 대놓고 드러난다"고 지적 → Overview·
  Decisions·세션 로그 본문 38곳을 "요청자"로 치환(커밋), 이미 push된 커밋 메시지 3개(콘텐츠 기획서
  반영/1차 인터뷰/2차 인터뷰)는 `git filter-branch --msg-filter`로 재작성 후
  `git push --force-with-lease`로 원격에 반영. 원본은 로컬 전용 `backup/pre-name-scrub` 브랜치에 보존
  (삭제 여부 확인 대기). 이후로는 커밋/문서에 실명 대신 역할명만 쓰기로 함 (에이전트 메모리에 기록).
- **COMPANY 페이지 구현** (`~/orca/workspaces/intra-tnm/company-page`, 브랜치 `feat/company-page`,
  커밋 `2f4aa3f`):
  - `src/data/company.ts`: 회사 정보 단일 출처, Overview.md 문구 그대로
  - 공통 `Header`/`Footer`/`MobileNavToggle`(모바일 햄버거), `nav-links.ts`
  - `/company`: 회사소개·연혁·사업영역(브랜드 카드, `/brands/<slug>` 링크)·오시는 길 + `KakaoMap`
    컴포넌트(앱키 `NEXT_PUBLIC_KAKAO_MAP_KEY` 미발급 상태라 자리표시자 + 외부 링크로 대체)
  - `globals.css`에 다크 네이비/블루 포인트/라이트그레이 고정 팔레트, OS 다크모드 미디어쿼리 제거
  - `layout.tsx`: `lang="ko"`, 기본 메타데이터(title 템플릿)
  - 미사용 기본 svg 5개 삭제, `.env.example`에 카카오 키 이름 문서화
  - **발견**: Next 16 `next dev`가 `AGENTS.md`에 "agent rules" 안내 블록을 자동으로 덧붙임 → 우리
    하네스 규칙 문서 보호를 위해 `next.config.ts`에 `agentRules: false` 추가
  - 검증: `npm run build`·`lint`·`tsc --noEmit` 통과, Chrome DevTools MCP로 375px/1280px 스크린샷 확인,
    모바일 햄버거 메뉴 클릭 동작(a11y 트리로 `aria-expanded` 등) 확인

### 바꾼 파일
- vault: `Overview.md`/`Decisions.md`/이 세션 로그 실명 치환 커밋, Decisions에 항목 2개 추가
- Brain 저장소 커밋 메시지 3개 재작성 + force-push (히스토리 재작성, 원격 반영)
- `intra-tnm` worktree `company-page`: 17개 파일 변경 (커밋 `2f4aa3f`, 아직 병합 전)

### 막힌 점 / 확인 필요
- (이전과 동일) HERUTU 취급 시작 연도, OHTAKE-ROOT/KTC/HERUTU 제품사진, 배포 서버 Node.js 지원 여부,
  개인정보 동의 문구, TRUSTED EXPERIENCE 고객사 실명 노출 최종 확인
- `backup/pre-name-scrub` 브랜치(로컬 전용, 실명 포함 원본) 삭제 여부 — 사람 확인 대기

### 다음 할 일 (아래 "더 이어서" 참고)
- `feat/company-page` 교차 리뷰 강도 추천(표준) 제시 → 사람이 고른 강도로 `/cross-review` 진행
- 리뷰 반영 후 `master`에 병합
- BRANDS → 메인페이지 → NOTICE(Node.js 확인 후) → CONTACT 순으로 이어서 구현 (각각 별도 worktree)
- `/handoff` 실행해 Handoff.md 갱신 (현재 Handoff.md는 2026-09-25 시점 그대로 정체)

## 더 이어서 (같은 세션, 압축 후 재개 — 홈페이지 1차 완료)

### 완료한 일
- **사람 지시(그대로 인용)**: "우선 그대로두자 크로스리뷰는 일단 건너띄고 홈페이지를 일차적으로
  완료해줘" → `backup/pre-name-scrub` 브랜치는 그대로 두고, 교차 리뷰는 전부 건너뛴 채 남은 페이지를
  이어서 구현·병합함 (COMPANY는 이미 병합 완료 상태에서 시작).
- **BRANDS** (`feat/brands`, 커밋 `ad2e211`, 병합 `775f0c1`): `src/data/brands.ts`(8개 브랜드 데이터,
  Overview.md 문구 그대로), `/brands` 목록, `/brands/[slug]` 상세(`generateStaticParams`+
  `generateMetadata`, 공식 링크 `target="_blank" rel="noopener noreferrer"`), 레거시 사진 유무에 따른
  `BrandPhotoPlaceholder` 컴포넌트.
- **NOTICE** (`feat/notice`, 커밋 `80e7d82`, 병합 `88f4276`): 파일 기반 저장소(`.data/notices.json`,
  배포 서버 Node.js 확인 전까지의 1차 구현) + HMAC 서명 세션 쿠키로 최소 관리자 로그인(`/admin/login`,
  `/admin/notice` CRUD). Next 16이 `middleware.ts`를 폐기 예고해 `@next/codemod`로 `proxy.ts`로 전환,
  Edge Runtime에서 `node:crypto`를 못 써서 `admin-auth.ts`를 Web Crypto(`crypto.subtle`) 기반으로 재작성.
  curl로 로그인 성공/실패, 인증 없는 API 차단, CRUD 전체를 직접 확인함.
- **CONTACT** (`feat/contact`, 커밋 `b19dc06`, 병합 `9c2a708`): `resend` 패키지로 이메일 발송 API +
  회사명/담당자명/연락처/문의내용/관심 브랜드/동의 체크박스 폼. Resend 키 미설정 시 503 + 회사 이메일
  안내로 대체(COMPANY 카카오맵 자리표시 패턴과 동일). **개인정보 동의 문구는 실제 법적 문구를 지어내지
  않고 화면에 그대로 보이는 TODO 자리표시자로 둠** (Overview.md 확정 사항).
- **메인페이지** (`feat/homepage`, 커밋 `00e1ce8`, 병합 `4979878`): Overview.md "메인페이지 흐름" 절
  순서 그대로 — MAIN VISUAL(기어 모티프 장식 SVG, 실제 제품 사진 아님) → COMPANY 요약(자세히 보기
  링크만, 연혁·오시는 길 미노출) → OUR BRANDS(8개 카드) → TRUSTED EXPERIENCE(로고 없이 텍스트만,
  고객사 실명 잠정 승인 상태) → NOTICE 최근 3건(빈 상태 처리) → CONTACT 요약+CTA. NOTICE를 직접 읽어
  `force-dynamic`으로 전환.
- 매 기능마다 `npm run build`/`eslint`/`tsc --noEmit` 통과 확인, `package-lock.json`은 실제 의존성
  추가(예: `resend`)가 아니면 되돌려서 diff를 깨끗하게 유지. Chrome DevTools MCP로 메인페이지를
  1280px/375px 스크린샷 확인(BRANDS/NOTICE/CONTACT는 이번 세션엔 스크린샷 재확인 못 함 — 아래 "막힌
  점" 참고). 마지막에 `master`에서 전체 `npm install`+`npm run build`로 병합 결과가 실제로 빌드되는지
  최종 확인함 (최초 시도 시 `resend`가 `master` worktree `node_modules`에 없어 빌드 실패 → `npm
  install`로 해결, 코드 문제 아님).

### 바꾼 파일
- `intra-tnm` `master`: BRANDS/NOTICE/CONTACT/메인페이지 4개 기능 각각 `feat/*` 브랜치에서 구현 후
  `--no-ff` 병합 (`775f0c1`, `88f4276`, `9c2a708`, `4979878`). 커밋 메시지에 모두 "교차 리뷰 건너뜀 —
  사람 결정" 명시.
- `.gitignore`: `/.data/`(NOTICE 런타임 데이터) 추가.
- `.env.example`: `ADMIN_PASSWORD`, `ADMIN_SESSION_SECRET`, `RESEND_API_KEY`, `CONTACT_FROM_EMAIL` 추가.

### 막힌 점 / 확인 필요 (기존 항목 + 이번 세션에서 새로 확인된 것)
- (기존 그대로) HERUTU 취급 시작 연도, OHTAKE-ROOT/KTC/HERUTU 제품사진, 배포 서버 Node.js 지원 여부,
  개인정보 동의 문구(TODO 자리표시자로 화면에 노출 중), TRUSTED EXPERIENCE 고객사 실명 노출 최종 확인.
- `backup/pre-name-scrub` 브랜치 삭제 여부 — 여전히 사람 확인 대기(이번 세션 지시로 그대로 둠).
- **교차 리뷰 전체 미실시**: BRANDS/NOTICE/CONTACT/메인페이지 4개 기능 모두 사람 지시로 교차 리뷰를
  건너뛰고 병합했다. 다음 세션에서 전체 diff 기준으로 교차 리뷰 여부·강도를 다시 물어야 한다.
- **접근성·반응형 재확인 범위 제한**: 이번 세션에서 Chrome DevTools MCP 스크린샷 확인은 메인페이지만
  했다. BRANDS/NOTICE/CONTACT는 빌드·린트·타입체크만 통과 확인했고 시각적 회귀는 아직 안 봤다
  (AGENTS.md 품질 게이트 중 "모바일·데스크톱 레이아웃 확인" 항목 일부 미이행).
- NOTICE 관리자 인증은 최소 구현(비밀번호 1개 + HMAC 세션 쿠키)이라 실제 배포 전 재검토 필요.

### 다음 할 일
- 사람에게 전체 4개 기능 diff 규모를 보여주고 교차 리뷰 진행 여부·강도를 물어본다.
- BRANDS/NOTICE/CONTACT도 Chrome DevTools MCP로 모바일/데스크톱 스크린샷 확인.
- `/handoff` 실행해 Handoff.md를 "홈페이지 1차 완료" 상태로 갱신.
- 남은 확인 사항(위 "막힌 점") 회신 오는 대로 반영.
