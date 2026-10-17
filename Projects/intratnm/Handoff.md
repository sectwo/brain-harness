---
project: intratnm
last_handoff: 2026-10-17
tags: [intratnm, handoff]
---
# Handoff — intratnm 홈페이지

> 새 세션은 이 노트부터 읽는다. `/handoff`로만 갱신한다. 이력은 쓰지 않는다 — 언제 무엇을 했는지는 Sessions/, 왜는 Decisions.

## 현재 상태
- 홈페이지 1차 구현 + UI/UX 개편(A안 "정밀 산업 스위스 미니멀") 1~4단계 완료. 배포 전 단계.
- 스택: Next.js 16(App Router) + TypeScript + Tailwind CSS. 본문 글꼴 Pretendard, 히어로 배경 회사명만 Chakra Petch
  (`next/font/google`, 빌드 시 자체 호스팅 → 빌드 머신에 인터넷 필요).
- 동작하는 페이지(`src/app/`): `/`, `/company`(앵커 `#history` 등), `/brands`·`/brands/[slug]` 8개, `/notice`·`/notice/[id]`,
  `/contact`, `/admin/login`·`/admin/notice`. 회사 정보·브랜드 문구는 `src/data/company.ts`·`brands.ts` 단일 출처(Overview 문구 그대로).
- SEO 기본 갖춤(sitemap·robots·OG 이미지·metadataBase·관리자 noindex) → [[Projects/intratnm/Knowledge/SEO-And-OG-Image]].
  운영 빌드 모바일 Lighthouse: 공개 페이지 6개 접근성·모범 사례·SEO 100 확인됨.
- 디자인: 코드 기준 문서는 저장소 `design-system/intra-tnm/MASTER.md`, vault 요약은 [[Projects/intratnm/Knowledge/Design-Tokens]]. GSAP 미도입.
- NOTICE: 파일 저장소(`.data/notices.json`, gitignore) + HMAC 세션 쿠키 관리자 로그인(비밀번호 1개). 배포 서버 확인 전 1차 구현
  → [[Projects/intratnm/Knowledge/Notice-Admin-Structure]].
- CONTACT: `resend`로 `intra@intratnm.com` 전송, 키 미설정 시 503 + 회사 이메일 안내. 개인정보 동의 문구는 TODO 자리표시자가
  화면에 노출 중. 환경 변수 → [[Projects/intratnm/Knowledge/Env-Vars-And-Fallbacks]].
- 카카오맵: `NEXT_PUBLIC_KAKAO_MAP_KEY` 미발급 → 자리표시자 + 외부 링크.
- 브랜드 자산: 회사 로고(`public/brand/intra-logo.png`)만 실제 파일. 브랜드 로고 8개는 텍스트 워드마크, 제품사진은 `BrandPhotoPlaceholder`.
- 저장소: `~/orca/projects/intra-tnm` `master` (origin과 같음). 원격 `github.com/sectwo/intra-tnm`(private).

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| - | - | - | master 하나뿐 |

## 다음 할 일
1. [ ] (요청자) 배포 서버 상품·Node.js 실행 가능 여부 확인 → NOTICE 저장소(파일→DB)·배포 방식 확정 (최우선)
2. [ ] (요청자→개발자) 빌드 머신의 인터넷 연결 가능 여부 확인 — 오프라인 빌드면 Chakra Petch를 서체 파일 포함으로 바꿔야 함
3. [ ] (요청자→Claude) 브랜드 로고 8개·OHTAKE-ROOT/KTC/HERUTU 제품사진 수령 시 반영(워드마크·`BrandPhotoPlaceholder` 교체).
   URYU/BIX/HIOS/CHIYODA/GOOT는 레거시 사이트 사진 재사용 승인됨, 아직 미반영
4. [ ] (개발자) 카카오맵 앱키 발급(허용 도메인 `www.intratnm.com` + 로컬) → `NEXT_PUBLIC_KAKAO_MAP_KEY` 적용
5. [ ] (요청자) CONTACT 개인정보 수집·이용 동의 문구 작성·검토 → TODO 자리표시자 교체
6. [ ] (사람+Claude) 초기 구현 4개 기능(BRANDS/NOTICE/CONTACT/메인)의 사후 교차 리뷰 여부·강도 결정.
   NOTICE 관리자 인증은 배포 전 재검토 필요(최소 구현)
7. [ ] (Claude) `/admin/login`·`/admin/notice` 모바일·데스크톱 스크린샷 확인 — 스타일은 적용됐으나 확인 기록 없음
8. [ ] (사람) `02_회사정보` 폴더(주요협력사·주요거래선 이미지) 사용 여부 — 로고 작업 범위 밖, 미사용
9. [ ] (사람) `backup/pre-name-scrub` 로컬 브랜치(요청자 실명 포함 원본, vault 저장소) 삭제 여부

## 막힌 점 / 확인 필요
- 배포 서버: 호스팅사 나야나(NAYANA)까지 확인됨. 계약 상품·Node.js 실행 가능 여부 미확인 — NOTICE(관리자 로그인+저장소)와
  CONTACT API가 여기 걸림. 확인 전까지 Node 서버 배포 가정 유지. 빌드 머신 인터넷 연결 여부도 같이 확인.
- HERUTU 취급 시작 연도 — 계약일자 확인 후. BRANDS>HERUTU 소개문 한 줄용(연혁 표 아님).
- OHTAKE-ROOT / KTC / HERUTU 대표 제품사진 + 브랜드 로고 8개 — 요청자가 별도 파일로 전달 예정, 미수령.
- CONTACT 개인정보 동의 문구 / 개인정보처리방침 — 회사에 기존 문구 없음, 사람이 작성·검토. 에이전트가 짓지 않음.
- TRUSTED EXPERIENCE 고객사 실명 — 잠정 승인(추후 변경 가능). 변경 통보 오면 `src/data/company.ts` 반영.
- 카카오맵 앱키 — 개발자 발급 예정, 아직 미발급.

## 관련 결정
- [[Projects/intratnm/Decisions#2026-10-03 — UI/UX 개편 A안: 정밀 산업 스위스 미니멀]] — 구조·문구는 그대로, 화면만 개편. GSAP 미도입
- [[Projects/intratnm/Decisions#2026-10-03 — 풀페이지 스냅 기각, 자유 스크롤 + 히어로 스크롤 연동]]
- [[Projects/intratnm/Decisions#2026-10-03 — 히어로 회사명 서체 Chakra Petch]] — 빌드 시 인터넷 필요
