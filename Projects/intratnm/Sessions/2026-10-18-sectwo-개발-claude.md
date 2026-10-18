---
project: intratnm
date: 2026-10-18
agent: claude
worktree: sectwo/개발
summary: "10/16 기준안 1단계(내용·데이터) 구현, Codex 표준 교차 리뷰 반영"
tags: [intratnm, session]
---
# 세션 — 2026-10-18 / sectwo/개발 / claude

## 한 일
- 계획: 1단계(내용·데이터) 계획을 보여 주고 사용자 승인. 사전 질문 결과 메인 COMPANY 요약 섹션은 빼기(기준안 순서).
  기본값은 CONTACT 브랜드 단일 선택, 이메일 필수·전화 선택.
- 구현(커밋 `cceb371`):
  - 브랜드 10개(FUJITEC·ECT 추가, slug ohtake-root→ohtake, 이름 URYU SEISAKU→URYU). products 판별 유니온
    (URYU 제품군·시리즈 / KTC 제품군 / 나머지 대표 제품 3종 카드). 공통 CTA "공식 홈페이지 바로가기"(새 창)·
    "제품·견적 문의"(`/contact?brand=코드`), 영문 홈페이지 버튼 제거.
  - 메인: 카피 "산업 현장을 위한 전문 공구와 기술", 기준안 설명문, 버튼 [회사소개][취급 브랜드],
    COMPANY 요약 섹션 삭제, 고객사 "삼성전자서비스 · LG전자".
  - COMPANY: 인사말, 연혁 기준안 표(분류 칩 "설립·거점"→"법인·시설"), 사업영역 7개 분야.
  - CONTACT: 서버 page + 클라이언트 ContactForm 분리, 문의 유형·브랜드 select 자동 선택·제품/모델·전화/이메일.
  - Footer 슬로건 제거·고객문의 시간 추가. 루트 메타·NOTICE 설명 갱신(NOTICE는 사용자 피드백으로 Overview 문구
    "…공식 자료 업데이트, 신제품 안내를 게시합니다").
- 교차 리뷰: Codex 표준(`gpt-5.6-terra`, 추론 medium). 치명 0·높음 4·참고 2.
  - 반영(커밋 `51b05df`): fetch 네트워크 실패 처리, API 타입·길이 검증·본문 20KB 상한·메일 제목 줄바꿈 제거,
    허니팟, Footer 구분자 `·`.
  - 보류: IP 요청 수 제한(배포 서버 확정 후, Decisions 기록).
  - 반박: 자동 테스트 없음 — 테스트 설정 없는 프로젝트라 curl·스크린샷으로 수동 검증. 재리뷰 안 함.
- 특이사항: Chrome DevTools MCP 프로필이 이전 세션 Chrome 프로세스에 잡혀 있어 MCP 대신 별도 프로필 headless
  Chrome 사용(기존 프로세스는 건드리지 않음). headless `--window-size 390`은 데스크톱 최소 폭 때문에 잘려 CDP Emulation으로 재촬영.

## 바꾼 파일
- 저장소 `src/`: `data/brands.ts`, `data/company.ts`, `data/contact.ts`(신규), `app/page.tsx`, `app/company/page.tsx`,
  `app/brands/page.tsx`, `app/brands/[slug]/page.tsx`, `app/contact/page.tsx`(서버), `app/api/contact/route.ts`,
  `app/layout.tsx`, `app/notice/page.tsx`, `components/ContactForm.tsx`(구 contact/page), `BrandShowcase.tsx`,
  `BrandPhotoPlaceholder.tsx`, `Footer.tsx`. 커밋 `cceb371`, `51b05df` (push 안 함).

## 검증
- lint·tsc·build 통과. headless Chrome 1440px + CDP 모바일 390px 스크린샷(메인·COMPANY·브랜드 상세 URYU/BIX/KTC·CONTACT):
  가로 넘침 없음, `?brand=HIOS` 자동 선택 확인.
- Overview 문구 대조 스크립트: 데이터 문자열 전부 일치(UI 라벨 제외). 외부 링크 10개 모두 target=_blank+rel.
- `/brands/ohtake-root` 404(배포 전이라 리다이렉트 안 둠). API: 형식 오류·길이 초과·동의 누락 400/413,
  정상 요청은 503 대체 안내(키 미설정), 허니팟 200.

## 막힌 점 / 확인 필요
- URYU `/en/`·HIOS `hios.com` 링크 유효성(오픈 직전), FUJITEC MK-3020 vs MK-3020V(기준안대로 MK-3020 표기),
  HERUTU 취급 연도(미기재), 개인정보 동의 문구(TODO 자리표시자 유지), CONTACT 요청 수 제한과 배포 서버 Node.js 여부.

## 다음 세션에
- 2단계 이미지: 브랜드 로고 10종, 제품사진 선별·최적화, 대표 제품 카드 사진 교체, BIX 도면형.
- master 병합 여부 사람 확인, `/handoff`.
