---
project: intratnm
last_handoff: 2026-10-03
tags: [intratnm, handoff]
---
# Handoff — intratnm 홈페이지

> 새 세션은 이 노트부터 읽는다. `/handoff`로만 갱신한다.

## 현재 상태
- **홈페이지 1차 구현 완료 + 디자인 리프레시 반영** (`~/orca/projects/intra-tnm` `master`, 최신 커밋 `909bddc`,
  origin/master와 동일). 스택: Next.js 16(App Router) + TypeScript + Tailwind CSS, 한글 글꼴 Pretendard.
- **동작하는 페이지** (`src/app/`): `/`(메인: MAIN VISUAL → COMPANY 요약 → OUR BRANDS → TRUSTED EXPERIENCE →
  NOTICE 최근 3건 → CONTACT), `/company`(회사소개·연혁 타임라인·사업영역·오시는 길, 앵커 `#history` 등),
  `/brands`·`/brands/[slug]` 8개, `/notice`·`/notice/[id]`, `/contact`, `/admin/login`·`/admin/notice`.
  빌드 시 20개 라우트 생성. 회사 정보·브랜드 문구는 `src/data/company.ts`·`src/data/brands.ts` 단일 출처
  (Overview.md 문구 그대로).
- **NOTICE**: 파일 기반 저장소(`.data/notices.json`, gitignore) + HMAC 세션 쿠키 최소 관리자 로그인(비밀번호 1개).
  배포 서버 Node.js 확인 전까지의 1차 구현 → [[Knowledge/Notice-Admin-Structure]].
- **CONTACT**: `resend`로 `intra@intratnm.com` 전송. 키 미설정 시 503 + 회사 이메일 안내. 개인정보 동의
  문구는 **TODO 자리표시자가 화면에 노출 중**. 제출 실패 시 `role="alert"` + 포커스 이동(접근성).
- **카카오맵**: `NEXT_PUBLIC_KAKAO_MAP_KEY` 미발급 → 자리표시자 + 외부 링크. 환경 변수 목록은
  [[Knowledge/Env-Vars-And-Fallbacks]].
- **디자인 상태**: 실제 회사 로고(기어 A 심볼, `public/brand/intra-logo.png`)를 Header·Footer에 흰 chip 위로
  반영. 포인트 블루를 로고 실측에 맞춰 `#0369a1`(네이비 위 `#38bdf8`)로 통일. 히어로 배경은 오로라
  그라디언트(진입 시 3초 1회), 브랜드 3단 배치(core/major/standard), 연혁 타임라인, 섹션 스크롤 리빌 +
  브랜드·공지 스태거. 토큰·컴포넌트 요약은 [[Knowledge/Design-Tokens]].
- **교차 리뷰 이력**: COMPANY·BRANDS·NOTICE·CONTACT·메인페이지 초기 구현은 사람 결정으로 **리뷰 건너뜀**.
  이후 디자인 리프레시(표준), a11y·스크롤 리빌(가벼움), 히어로 카피·배경(가벼움), visual-refresh(표준)는
  Codex 리뷰 완료·지적 반영됨.
- **품질 게이트 미이행 부분**: BRANDS 목록/NOTICE 목록·상세/admin 페이지는 2026-09-26 이후 스크린샷 확인이
  일부만 됐음(`/brands`·`/contact`는 10-03 visual-refresh에서 1440/375px 확인, `/notice`·`/admin/*`은 미확인).
- 하네스: Headroom 프록시(8787) 경유 정상, ECC·karpathy-skills·ui-ux-pro-max 플러그인 설치됨(L1).
  원격: `github.com/sectwo/intra-tnm`(private), vault `brain-harness` — 둘 다 2026-10-03 push 완료.

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| - | - | - | master 하나뿐 (10-03에 나머지 worktree·병합 브랜치 전부 정리) |

## 다음 할 일
1. [ ] (요청자) 배포 서버 상품·Node.js 실행 가능 여부 확인 → 결과에 따라 NOTICE 저장소(파일→DB)·배포 방식 확정 (최우선)
2. [ ] (요청자→Claude) 브랜드 로고 8개·OHTAKE-ROOT/KTC/HERUTU 제품사진 파일 수령 시 반영
   (현재 텍스트 워드마크·`BrandPhotoPlaceholder`). URYU/BIX/HIOS/CHIYODA/GOOT는 레거시 사이트 사진 재사용 승인됨, 아직 미반영.
3. [ ] (개발자) 카카오맵 앱키 발급(허용 도메인 `www.intratnm.com` + 로컬) → `NEXT_PUBLIC_KAKAO_MAP_KEY` 적용
4. [ ] (요청자) CONTACT 개인정보 수집·이용 동의 문구 작성·검토 → TODO 자리표시자 교체
5. [ ] (Claude) `/notice`·`/notice/[id]`·`/admin/*` 모바일·데스크톱 스크린샷 확인 (AGENTS.md 게이트 잔여분)
6. [ ] (사람+Claude) 초기 구현 4개 기능(BRANDS/NOTICE/CONTACT/메인)에 대해 교차 리뷰를 사후에 돌릴지 여부·강도 결정.
   특히 NOTICE 관리자 인증은 배포 전 재검토 필요(최소 구현)
7. [ ] (Claude) `.env.example` 2행의 카카오 앱키 발급자 실명 → 역할명으로 정리 (`/handoff` 점검 중 발견, 저장소 파일)
8. [ ] (사람+Claude) 홈페이지 리뉴얼을 더 확장할지(타이포·레이아웃 등) 상의. 확장 시 새 worktree에서 계획→확인→구현.
   AI 생성 이미지는 자사 장식 용도(히어로 그래픽·OG·텍스처)만 허용, 취급 브랜드 제품 묘사는 금지(사용자 정정 10-03) — 생성 도구는 아직 미연결
9. [ ] (Claude) sitemap.xml·robots.txt·OG 이미지 — Overview "라우트" 절에서 구현 단계에 챙기기로 한 항목, 아직 미착수(로그에 작업 기록 없음)
10. [ ] (사람) `02_회사정보` 폴더(주요협력사·주요거래선 이미지) 사용 여부 — 10-03 로고 작업 범위 밖, 미사용
11. [ ] (사람) `backup/pre-name-scrub` 로컬 브랜치(요청자 실명 포함 원본, vault 저장소) 삭제 여부 — 9/26부터 대기

## 막힌 점 / 확인 필요
- **배포 서버**: 호스팅사 나야나(NAYANA)까지 확인됨. 계약 상품·Node.js 실행 가능 여부 미확인 — NOTICE(관리자
  로그인+저장소)와 CONTACT API 구현 자체가 여기 걸림. 확인 전까지 Node 서버 배포 가정 유지.
- **HERUTU 취급 시작 연도** — 계약일자 확인 후. BRANDS>HERUTU 소개문 한 줄용(연혁 표 아님).
- **OHTAKE-ROOT / KTC / HERUTU 대표 제품사진** + **브랜드 로고 8개** — 요청자가 별도 파일로 전달 예정(10-01), 미수령.
- **CONTACT 개인정보 동의 문구 / 개인정보처리방침** — 회사에 기존 문구 없음, 사람이 작성·검토. 에이전트가 짓지 않음.
- **TRUSTED EXPERIENCE 고객사 실명** — 잠정 승인(추후 변경 가능). 변경 통보 오면 `src/data/company.ts` 반영.
- **카카오맵 앱키** — 개발자 발급 예정, 아직 미발급.

## 최근 결정
- 프로젝트(L2):
  - [[Decisions#2026-09-26 — 요청자 콘텐츠 기획서 반영]]
  - [[Decisions#2026-09-26 — 기술 스택: Next.js + TypeScript + Tailwind CSS]]
  - [[Decisions#2026-09-26 — 요청자 1차 인터뷰: 남은 확인 사항 정리]]
  - [[Decisions#2026-09-26 — Fable 리뷰 반영: 문서 정합성 정리]]
  - [[Decisions#2026-09-26 — 요청자 2차 인터뷰: Fable 리뷰 남은 확인 사항 정리]]
  - [[Decisions#2026-09-26 — 웹호스팅사 확인: 나야나(NAYANA)]]
  - [[Decisions#2026-10-02 — 메인 비주얼 카피 어순 수정 + 히어로 배경 리프레시]]
- 전역(L1, 이 프로젝트에서 비롯됨):
  - [[System/Decisions#2026-10-01 — 서드파티 Claude Code 플러그인 2종 L1 설치 (karpathy-skills, ui-ux-pro-max)]]
  - [[System/Decisions#2026-10-03 — 모델 운용 변경(Opus 5.5 기본·Fable 기록)과 /cross-review Codex 실행 방식 변경]]
- 세션 로그에만 있고 Decisions에 아직 없는 결정(기록 후보): 브랜드 3단 배치(`tier`)·연혁 분류 칩(`historyKind`)은
  UI 파생값이며 새 사실 아님(09-26 design-refresh); `.bg-aurora` 무한 루프 → 1회 3초 정착 모션(10-02);
  포인트 블루 `#0369a1` 채택(10-03); 외부 템플릿 구조 도입 보류·시각 스타일만 리파인(10-03).
