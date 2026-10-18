---
project: intratnm
tags: [intratnm, knowledge]
---
# Knowledge — intratnm (L2)

> 이 프로젝트에서만 쓰는 지식. 한 주제에 한 파일. 다른 프로젝트에도 쓸 만하면 `/handoff` 때 L1 승격 후보로 올린다.

| 파일 | 내용 |
|---|---|
| [[Projects/intratnm/Knowledge/Nextjs-Worktree-And-Build]] | intratnm 고유: dev 포트 3001, proxy.ts·Web Crypto, ESLint set-state-in-effect, 검증 루틴 (worktree 범용 내용은 L1 [[System/Knowledge/Nextjs-Worktree]]) |
| [[Projects/intratnm/Knowledge/Notice-Admin-Structure]] | NOTICE 파일 저장소(`.data/notices.json`, 직렬화·원자적 쓰기)와 HMAC 세션 관리자 로그인(해시 비교·쓰기 API Origin 검사) 구조, 배포 전 남은 보안 항목 |
| [[Projects/intratnm/Knowledge/Env-Vars-And-Fallbacks]] | `.env.example` 변수 5개와 미설정 시 자리표시 동작 |
| [[Projects/intratnm/Knowledge/Design-Tokens]] | 개편 A안 디자인 토큰·컴포넌트 요약과 결정 근거 (상세는 저장소 `design-system/intra-tnm/MASTER.md`) |
| [[Projects/intratnm/Knowledge/SEO-And-OG-Image]] | sitemap·robots·metadataBase·CONTACT layout metadata, OG 라우트 특이점(react-dom/server 금지·한글 어절 span·Node 런타임) |
| [[Projects/intratnm/Knowledge/Brand-Images-Pipeline]] | 브랜드 로고·제품사진·COMPANY 인사말 사진 생성 파이프라인(`scripts/brand-images.mjs`·`company-images.mjs`): 요청자 원본 위치·가공 규칙(`whiten` 배경 보정 포함)·사진 추가/교체 절차·NFD·EPIPE·dev 이미지 캐시 함정 |
| [[Projects/intratnm/Knowledge/Fonts-Pretendard-Subset]] | 본문 Pretendard 동적 서브셋·히어로 Chakra Petch가 어디서 어떻게 로드되는지. 서체를 바꾸거나, Lighthouse 성능 점수를 해석하거나, 오프라인 빌드·라이선스 고지를 다룰 때 연다 |
