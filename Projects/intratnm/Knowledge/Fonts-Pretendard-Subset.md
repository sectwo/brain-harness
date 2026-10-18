---
project: intratnm
summary: 본문 Pretendard 동적 서브셋·히어로 Chakra Petch가 어디서 어떻게 로드되는지. 서체를 바꾸거나, Lighthouse 성능 점수를 해석하거나, 오프라인 빌드·라이선스 고지를 다룰 때 연다
source: intratnm 2026-10-18 sectwo/개발 세션 (Pretendard 경량화)
tags: [intratnm, knowledge]
---
# 폰트 — Pretendard 동적 서브셋 · Chakra Petch

## 언제 쓰나
- 본문·히어로 서체나 폰트 로딩 방식을 손댈 때
- Lighthouse 성능 점수가 낮게 나와 폰트가 원인인지 볼 때
- 빌드 머신이 오프라인이거나, 배포물에 폰트 라이선스 고지를 넣어야 할 때

## 방법
- 본문: `src/app/layout.tsx`가 npm 패키지 `pretendard`의 `dist/web/variable/pretendardvariable-dynamic-subset.css`를 import한다.
  저장소에 woff2 파일은 없다(통짜 `PretendardVariable.woff2` 2MB는 제거). 글자 범위(unicode-range)별 조각을 브라우저가 필요한 것만 받는다.
- `src/app/globals.css`의 `--font-sans`는 `"Pretendard Variable", Pretendard, 시스템 대체 폰트…`. 첫 이름은 패키지 CSS의 font-family와 같아야 한다.
- 히어로 회사명: `src/app/page.tsx`에서 `next/font/google`의 `Chakra_Petch`(weight 700, latin, preload 없음). 빌드 때 Google에서 받아
  자체 호스팅하므로 **빌드 머신에 인터넷이 필요**하다. 오프라인 빌드면 서체 파일을 저장소에 넣고 `next/font/local`로 바꾼다.
- 바꾼 뒤 확인: 운영 빌드(`npm run build && npm start`)에서 폰트 전송량(동적 서브셋은 수백 KB, 조각 10여 개), 굵기 400/500/600/700 표시,
  드문 글자(①·뷁 등)가 Pretendard로 나오는지, 6개 페이지 375·1440px 가로 넘침 없음.

## 주의
- 정적 서브셋(KS X 1001 2,350자)은 쓰지 않는다 — NOTICE 본문이 관리자 입력이라 글자 집합을 고정할 수 없다.
- Lighthouse 기본(모의 계산, Lantern)은 큰 폰트 파일을 렌더 차단으로 잡아 성능 점수를 크게 깎는다. 실제 스로틀(devtools)로 재면
  통짜 폰트도 98점이었다. 점수 비교는 두 방식을 다 재서 판단한다 → [[System/Knowledge/Lighthouse-LCP-Diagnosis]].
- 동적 서브셋은 전송량이 약 1/6로 줄지만 조각 요청이 많아 실측 첫 표시가 0.2~0.5s 늦어진다. 측정값은 세션 로그.
- Pretendard는 OFL. 배포물에 고지를 따로 넣을지는 배포 방식을 정할 때 판단한다(미결, Handoff 다음 할 일 1번).

## 관련
- [[Projects/intratnm/Sessions/2026-10-18-sectwo-개발-claude]] — "Pretendard 폰트 경량화" 절: 대안 비교·측정값·교차 리뷰
- [[Projects/intratnm/Decisions#2026-10-03 — 히어로 회사명 서체 Chakra Petch]]
