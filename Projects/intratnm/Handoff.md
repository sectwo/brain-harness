---
project: intratnm
last_handoff: 2026-10-17
tags: [intratnm, handoff]
---
# Handoff — intratnm 홈페이지

> 새 세션은 이 노트부터 읽는다. `/handoff`로만 갱신한다.

## 현재 상태
- **홈페이지 1차 구현 + UI/UX 개편(A안) 1~4단계 완료, origin 반영** (`~/orca/projects/intra-tnm` `master`,
  최신 커밋 `0d11f9d`, origin/master와 동일 — 10-17 push). 스택: Next.js 16(App Router) + TypeScript +
  Tailwind CSS, 본문 글꼴 Pretendard, 히어로 배경 회사명만 Chakra Petch(`next/font/google`, 빌드 시 자체 호스팅).
- **동작하는 페이지** (`src/app/`): `/`(MAIN VISUAL → COMPANY 요약 → OUR BRANDS → TRUSTED EXPERIENCE → NOTICE
  최근 3건 → CONTACT), `/company`(회사소개·연혁·사업영역·오시는 길, 앵커 `#history` 등), `/brands`·
  `/brands/[slug]` 8개, `/notice`·`/notice/[id]`, `/contact`, `/admin/login`·`/admin/notice`. 회사 정보·브랜드
  문구는 `src/data/company.ts`·`src/data/brands.ts` 단일 출처(Overview.md 문구 그대로, 개편에서 변경 없음).
- **SEO 기본 완료**(10-03, `312639d`·`0529059`): `sitemap.ts`(공개 페이지+브랜드 8개+공지; 공지 저장소 손상 시
  공지만 제외), `robots.ts`(`/admin`·`/api` 차단), `opengraph-image.tsx`(기어 선화 정적 SVG + 로고 + 슬로건,
  `runtime = "nodejs"` 명시), `metadataBase`(`NEXT_PUBLIC_SITE_URL`, 비면 `https://www.intratnm.com`),
  관리자 페이지 noindex, CONTACT는 서버 `layout`으로 metadata 부여 → [[Knowledge/SEO-And-OG-Image]].
- **디자인 상태**(개편 A안 "정밀 산업 스위스 미니멀"): 흰 헤더 + 하단 헤어라인(문의 버튼 없음), 히어로 기어 2개 +
  눈금 링 선화 + 배경 회사명(스크롤 연동: 기어 반대 회전·회사명 이동), 섹션 제목 액센트 바 드로우, 브랜드 카드
  3단(core/major/standard), 버튼 6px·칩 4px, GSAP 미도입(CSS + IntersectionObserver). 풀페이지 스냅은 시험 후
  기각. 코드 기준 디자인 시스템 문서 `design-system/intra-tnm/MASTER.md`, vault 요약은 [[Knowledge/Design-Tokens]].
- **Lighthouse**(운영 빌드, 모바일, 10-03): `/`, `/company`, `/brands`, `/brands/uryu`, `/notice`, `/contact` 6개
  모두 접근성·모범 사례·SEO 100. 메인 LCP 129ms, CLS 0.
- **NOTICE**: 파일 기반 저장소(`.data/notices.json`, gitignore) + HMAC 세션 쿠키 최소 관리자 로그인(비밀번호 1개).
  배포 서버 Node.js 확인 전까지의 1차 구현 → [[Knowledge/Notice-Admin-Structure]].
- **CONTACT**: `resend`로 `intra@intratnm.com` 전송. 키 미설정 시 503 + 회사 이메일 안내. 개인정보 동의 문구는
  **TODO 자리표시자가 화면에 노출 중**. 환경 변수 목록은 [[Knowledge/Env-Vars-And-Fallbacks]].
- **카카오맵**: `NEXT_PUBLIC_KAKAO_MAP_KEY` 미발급 → 자리표시자 + 외부 링크.
- **브랜드 자산**: 회사 로고(`public/brand/intra-logo.png`)만 실제 파일. 브랜드 로고 8개는 텍스트 워드마크,
  제품사진은 `BrandPhotoPlaceholder` 자리표시자.
- **교차 리뷰 이력**: 초기 구현 4건(COMPANY·BRANDS·NOTICE·CONTACT·메인)은 사람 결정으로 리뷰 건너뜀. 이후
  디자인 리프레시·visual-refresh·SEO 기본·개편 1~3단계(표준), a11y·스크롤 리빌·히어로 카피·스크롤 연동·
  4단계(가벼움)는 Codex 리뷰 완료·지적 전부 반영.
- **세션 비용**: 10-17 비용 추적 훅이 세션 누적 약 $231(기준 $50)로 경고. 하위 작업 모델 하향(Fable → Sonnet/
  Haiku) 제안 — 사용자 결정 대기.
- 하네스: Headroom 프록시(8787) 경유 정상(10-17 재확인). 원격 `github.com/sectwo/intra-tnm`(private), vault
  `brain-harness` — 둘 다 10-17 push 완료.

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| - | - | - | master 하나뿐 (10-03에 시험 브랜치 포함 전부 정리) |

## 다음 할 일
1. [ ] (요청자) 배포 서버 상품·Node.js 실행 가능 여부 확인 → NOTICE 저장소(파일→DB)·배포 방식 확정 (최우선)
2. [ ] (요청자→개발자) 배포 시 **빌드 머신의 인터넷 연결 가능 여부** 확인 — Chakra Petch를 `next/font/google`로
   빌드 시 받아오므로 오프라인 빌드면 서체 파일 자체 포함으로 바꿔야 함(10-03 발견)
3. [ ] (사용자) 세션 비용 관리 방침 결정 — 하위 작업 모델 하향 여부(Fable → Sonnet/Haiku). 하향 시 L1 Rules 5절의
   "vault 기록은 Fable" 운용도 같이 조정 (10-17 경고)
4. [ ] (요청자→Claude) 브랜드 로고 8개·OHTAKE-ROOT/KTC/HERUTU 제품사진 파일 수령 시 반영(워드마크·
   `BrandPhotoPlaceholder` 교체). URYU/BIX/HIOS/CHIYODA/GOOT는 레거시 사이트 사진 재사용 승인됨, 아직 미반영
5. [ ] (개발자) 카카오맵 앱키 발급(허용 도메인 `www.intratnm.com` + 로컬) → `NEXT_PUBLIC_KAKAO_MAP_KEY` 적용
6. [ ] (요청자) CONTACT 개인정보 수집·이용 동의 문구 작성·검토 → TODO 자리표시자 교체
7. [ ] (사람+Claude) 초기 구현 4개 기능(BRANDS/NOTICE/CONTACT/메인)에 대해 교차 리뷰를 사후에 돌릴지 여부·강도
   결정. 특히 NOTICE 관리자 인증은 배포 전 재검토 필요(최소 구현)
8. [ ] (Claude) `/admin/login`·`/admin/notice` 모바일·데스크톱 스크린샷 확인 — 개편 3단계에서 스타일은 적용됐으나
   로그에 확인 기록 없음(`/notice`는 Lighthouse 모바일 100으로 확인됨)
9. [ ] (사람) `02_회사정보` 폴더(주요협력사·주요거래선 이미지) 사용 여부 — 10-03 로고 작업 범위 밖, 미사용
10. [ ] (사람) `backup/pre-name-scrub` 로컬 브랜치(요청자 실명 포함 원본, vault 저장소) 삭제 여부 — 9/26부터 대기

완료 처리(10-03 로그 근거): sitemap/robots/OG(→ 현재 상태), `.env.example` 실명 → 역할명(SEO 기본 커밋에 포함),
`/notice` 화면 확인(Lighthouse), 홈페이지 리뉴얼 확장 여부 상의(→ 개편 A안으로 진행·완료).

## 막힌 점 / 확인 필요
- **배포 서버**: 호스팅사 나야나(NAYANA)까지 확인됨. 계약 상품·Node.js 실행 가능 여부 미확인 — NOTICE(관리자
  로그인+저장소)와 CONTACT API 구현이 여기 걸림. 확인 전까지 Node 서버 배포 가정 유지. 빌드 머신 인터넷 연결
  여부도 같이 확인.
- **HERUTU 취급 시작 연도** — 계약일자 확인 후. BRANDS>HERUTU 소개문 한 줄용(연혁 표 아님).
- **OHTAKE-ROOT / KTC / HERUTU 대표 제품사진** + **브랜드 로고 8개** — 요청자가 별도 파일로 전달 예정(10-01), 미수령.
- **CONTACT 개인정보 동의 문구 / 개인정보처리방침** — 회사에 기존 문구 없음, 사람이 작성·검토. 에이전트가 짓지 않음.
- **TRUSTED EXPERIENCE 고객사 실명** — 잠정 승인(추후 변경 가능). 변경 통보 오면 `src/data/company.ts` 반영.
- **카카오맵 앱키** — 개발자 발급 예정, 아직 미발급.
- **세션 비용 방침** — 누적 $231 경고. 하위 작업 모델 하향 여부는 사용자 결정.

## 최근 결정
- 프로젝트(L2), 2026-10-03 이후 새 항목:
  - [[Decisions#2026-10-03 — UI/UX 개편 A안: 정밀 산업 스위스 미니멀]] (외부 템플릿 구조 보류·시각만 리파인, GSAP 미도입 포함)
  - [[Decisions#2026-10-03 — 풀페이지 스냅 기각, 자유 스크롤 + 히어로 스크롤 연동]]
  - [[Decisions#2026-10-03 — 히어로 회사명 서체 Chakra Petch]]
- 이전 항목: [[Decisions#2026-10-02 — 메인 비주얼 카피 어순 수정 + 히어로 배경 리프레시]] 및 2026-09-26 결정 6건.
- 전역(L1, 이 프로젝트에서 비롯됨):
  - [[System/Decisions#2026-10-01 — 서드파티 Claude Code 플러그인 2종 L1 설치 (karpathy-skills, ui-ux-pro-max)]]
  - [[System/Decisions#2026-10-03 — 모델 운용 변경(Opus 5.5 기본·Fable 기록)과 /cross-review Codex 실행 방식 변경]]
- 세션 로그에만 있고 Decisions에 없는 결정(기록 후보, 남은 것): 브랜드 3단 배치(`tier`)·연혁 분류 칩(`historyKind`)은
  UI 파생값이며 새 사실 아님(09-26 design-refresh); `.bg-aurora` 무한 루프 → 1회 3초 정착 모션(10-02);
  포인트 블루 `#0369a1` 채택(10-03, 근거는 [[Knowledge/Design-Tokens]]에 있음).
  — 외부 템플릿 보류·시각 리파인은 개편 A안 결정에 흡수됨.
