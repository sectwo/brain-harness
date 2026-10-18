---
project: intratnm
last_handoff: 2026-10-19
tags: [intratnm, handoff]
---
# Handoff — intratnm 홈페이지

> 새 세션은 이 노트부터 읽는다. `/handoff`로만 갱신한다. 이력은 쓰지 않는다 — 언제 무엇을 했는지는 Sessions/, 왜는 Decisions.

## 현재 상태
- 홈페이지 전체 구현 + UI/UX 개편 A안 + 요청자 최종 콘텐츠 기준안(10/16) 내용·이미지 + Pretendard 경량화 + 사후 보안 리뷰 반영까지
  master에 병합·push됨. 배포 전 확인 대기 단계(배포 서버 미확정).
- 스택: Next.js 16(App Router)+TypeScript+Tailwind. 본문 Pretendard는 npm 패키지의 동적 서브셋 CSS, 히어로 배경 회사명만 Chakra Petch
  (`next/font/google` → 빌드 머신 인터넷 필요) → [[Projects/intratnm/Knowledge/Fonts-Pretendard-Subset]].
- 동작하는 페이지(`src/app/`): `/`, `/company`(인사말 사진·연혁·사업영역 7개·주요 거래처·오시는 길), `/brands`·`/brands/[slug]` 10개,
  `/notice`·`/notice/[id]`, `/contact`, `/admin/login`·`/admin/notice`. 회사 정보·브랜드 문구는 `src/data/company.ts`·`brands.ts`·`contact.ts`
  단일 출처(Overview와 동일). 고객사 실명은 `company.ts` `clientGroups` 하나로 메인 TRUSTED EXPERIENCE·COMPANY 주요 거래처가 공유(잠정 승인).
- 이미지: 요청자 원본(저장소 밖)을 `scripts/brand-images.mjs`(브랜드, `whiten` 옵션 포함)·`scripts/company-images.mjs`(인사말 사진)로 가공해
  `public/brands/<slug>/`·`public/company/`에 생성 → [[Projects/intratnm/Knowledge/Brand-Images-Pipeline]]. `image` 없는 제품은 자리표시자.
- CONTACT: 2열(왼쪽 연락처·문의 절차 안내, 오른쪽 폼), 문의 유형 선택 칸, `?brand=코드` 자동 선택, 허니팟·입력 검증·본문 크기 상한. `resend` 전송, 키 미설정 시 503 + 회사 이메일 안내.
  IP 요청 수 제한은 보류. 개인정보 동의 문구는 TODO 자리표시자가 화면에 노출 중 → [[Projects/intratnm/Knowledge/Env-Vars-And-Fallbacks]].
- NOTICE: 파일 저장소(`.data/notices.json`, 직렬화·원자적 쓰기, 단일 프로세스 전제) + HMAC 세션 쿠키 관리자 로그인(비밀번호 1개, 해시 비교,
  쓰기 API Origin 검사). 다중 프로세스 배포면 DB로 전환 필요 → [[Projects/intratnm/Knowledge/Notice-Admin-Structure]].
- SEO 기본 갖춤 → [[Projects/intratnm/Knowledge/SEO-And-OG-Image]]. Lighthouse 성능 점수는 모의 계산과 실측이 크게 달라 기본 점수만으로
  판단하지 않는다(Fonts 지식 "주의"). 디자인 기준은 저장소 `design-system/intra-tnm/MASTER.md`(요약 [[Projects/intratnm/Knowledge/Design-Tokens]]), GSAP 미도입.
- 카카오맵: `NEXT_PUBLIC_KAKAO_MAP_KEY` 미발급 → 자리표시자 + 외부 링크. 자동 테스트 없음(도입 여부는 배포 방식 정할 때 판단).
- 저장소: `~/orca/projects/intra-tnm` `master` (origin과 같음). 원격 `github.com/sectwo/intra-tnm`(private).

## 진행 중인 worktree
| worktree | 담당 | 작업 | 상태 |
|---|---|---|---|
| `sectwo/개발` | Claude | - | master와 같은 커밋, 진행 중 작업 없음 |

## 다음 할 일
1. [ ] (요청자) 배포 서버 상품·Node.js 실행 가능 여부 확인 → NOTICE 저장소(파일→DB)·CONTACT API·배포 방식 확정 (최우선). 확정 후 배포 전
   보안 작업(관리자 로그인 시도 제한, CONTACT 요청 수 제한, 세션 토큰 무효화·비밀키 회전 절차)과 폰트 OFL 고지·자동 테스트 도입 여부를 함께 판단
2. [ ] (요청자→개발자) 빌드 머신의 인터넷 연결 가능 여부 확인 — 오프라인 빌드면 Chakra Petch를 서체 파일 포함으로 바꿔야 함
3. [ ] (사람) 모바일 실제 화면 확인 — 브랜드 로고 크기·인사말 사진·주요 거래처·브랜드 상세 줄맞춤·CONTACT 2열(headless 캡처로는 모바일 확인 불가)
4. [ ] (사람) 실제 관리자 화면에서 로그인·공지 작성 확인 — 쓰기 API Origin 검사 추가 후 미확인
5. [ ] (사람→요청자) 다듬은 브랜드 소개 문구 공유·확인 — [[Projects/intratnm/Decisions#2026-10-19 — 브랜드 소개 문구 문법 다듬기]]
6. [ ] (요청자) 사진·도면 교체/보충 요청 전달 — 목록은 아래 "막힌 점". 수령 시 Claude가 파이프라인으로 반영
7. [ ] (개발자) 카카오맵 앱키 발급(허용 도메인 `www.intratnm.com` + 로컬) → `NEXT_PUBLIC_KAKAO_MAP_KEY` 적용
8. [ ] (요청자) CONTACT 개인정보 수집·이용 동의 문구 작성·검토 → TODO 자리표시자 교체
9. [ ] (Claude) 브랜드 공식 홈페이지 링크 10개 오픈 직전 재확인(URYU `/en/`, HIOS `hios.com` 포함)
10. [ ] (사람) `backup/pre-name-scrub` 로컬 브랜치(vault, 요청자 실명 원본) 삭제 여부

## 막힌 점 / 확인 필요
- 배포 서버: 호스팅사 나야나(NAYANA)까지 확인됨. 계약 상품·Node.js 실행 가능 여부 미확인 — NOTICE·CONTACT API·배포 전 보안 작업이 여기 걸림.
  확인 전까지 Node 서버 배포 가정 유지. 빌드 머신 인터넷 연결 여부도 같이 확인.
- HERUTU 취급 시작 연도 — 계약일자 확인 후. BRANDS>HERUTU 소개문 한 줄용(연혁 표 아님).
- 요청자 사진·도면: HIOS BLG-5000BC2·PGFA-5000 실제 사진, URYU Testers 사진, BIX B-15 도면 원본, 저해상도·배경 다른 사진 교체
  (OM-26M 하늘색 배경, TW-800R-SCL·Mega Hose·MK 시리즈·BIX 도면 저해상도, ECT 3종 묶음에서 잘라낸 사진). CHIYODA 3종은 현재 시안 잘라낸 사진.
- FUJITEC 모델명 `MK-3020` vs 파일명 `MK-3020V` 불일치 — 요청자 확인. 공식 링크 URYU `/en/`·HIOS `hios.com` 유효성 — 오픈 직전 재확인.
- CONTACT 개인정보 동의 문구 / 개인정보처리방침 — 회사에 기존 문구 없음, 사람이 작성·검토. 에이전트가 짓지 않음.
- TRUSTED EXPERIENCE·COMPANY 주요 거래처 고객사 실명 — 잠정 승인(추후 변경 가능). 변경 통보 오면 `src/data/company.ts` `clientGroups`만 반영.

## 관련 결정
- [[Projects/intratnm/Decisions#2026-10-18 — 요청자 최종 콘텐츠 기준안(10/16) 반영]] — 브랜드 10개·연혁·사업영역·메인 카피 기준, 디자인은 A안 유지
- [[Projects/intratnm/Decisions#2026-10-19 — 02_회사정보 자료 활용: COMPANY 인사말 사진 · 주요 거래처 섹션]] — 인사말 사진·주요 거래처 구성, 고객사 목록 단일 출처
- [[Projects/intratnm/Decisions#2026-10-18 — 메인 COMPANY 요약 섹션 제거 · CONTACT 요청 수 제한 보류]] — 요청 수 제한은 배포 서버 확정 후
