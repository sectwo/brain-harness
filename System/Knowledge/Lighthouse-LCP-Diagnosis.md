---
level: 1
summary: "Lighthouse 성능이 낮을 때 LCP 요소·단계(TTFB/로드 지연/로드/렌더 지연)로 원인을 가르고, 바꾸지 않은 페이지·다른 측정 방식(simulate/devtools)과 비교해 진짜 원인인지 확인"
source: intratnm 2026-10-18
tags: [system, knowledge, lighthouse, performance, web]
---
# Lighthouse LCP 원인 가르기

## 언제 쓰나
- 변경 후 Lighthouse 성능 점수가 낮게 나와, 그게 이번 변경 탓인지 원래 있던 문제인지 판단해야 할 때.

## 방법
1. 운영 빌드로 띄우고(`next start` 등) CLI로 JSON을 받는다:
   `npx -y lighthouse@12 <url> --quiet --form-factor=mobile --only-categories=performance --output=json --output-path=lh.json --chrome-flags="--headless=new --user-data-dir=<임시>"`
2. JSON에서 본다:
   - `audits["largest-contentful-paint"].displayValue` — LCP 시간
   - `audits["largest-contentful-paint-element"].details.items[0]` — LCP 요소(selector)
   - 같은 곳 `items[1]` — 단계별 시간: TTFB / Load Delay / Load Time / Render Delay
3. 단계로 원인을 가른다:
   - **Load Delay** 큼 + LCP가 이미지 → 지연 로딩(`loading="lazy"`)된 첫 화면 이미지. 미리 불러오기(Next 16 `preload`, 구 `priority`).
   - **Render Delay**가 대부분 + LCP가 텍스트 → 렌더를 막는 큰 글꼴·CSS·JS. 글꼴 파일 크기부터 확인.
   - TTFB 큼 → 서버·데이터 조회.
4. **이번 변경을 건드리지 않은 페이지**도 같은 조건으로 잰다. 점수·LCP가 같으면 변경 탓이 아니라 공통 원인이다.
5. **측정 방식도 의심한다.** CLI 기본(`--throttling-method=simulate`, Lantern)은 실제로 느리게 돌리지 않고 받은 파일로 느린 회선을
   계산한다. 수 MB 글꼴이 있으면 렌더 차단으로 잡아 LCP·점수가 실제보다 크게 나빠질 수 있다.
   고치기 전에 `--throttling-method=devtools`로도 같은 조건에서 재서 비교한다. 둘 다 나쁘면 진짜 원인이다.

## 주의
- 첫 실행은 캐시가 비어 느리다. 같은 URL을 2번 돌려 두 번째 값을 쓴다.
- 이미지 preload로 Load Delay를 없애도 Render Delay가 남으면 점수는 그대로다 — 단계를 보고 판단한다.
- 접근성·SEO 점수와 달리 성능은 기기·부하에 따라 흔들린다. 수치는 조건(모바일, 운영 빌드, 로컬)과 함께 기록한다.

## 관련
- [[Projects/intratnm/Sessions/2026-10-18-sectwo-개발-claude]] — 성능 74, 원인이 이미지가 아닌 2MB 가변 한글 글꼴(전 페이지 Render Delay ~12s).
  메인 모바일 같은 빌드: simulate 74점·LCP 13.1s vs devtools 98점·LCP 2.3s. 글꼴을 동적 서브셋으로 바꾼 뒤 simulate 76점·LCP 4.7s,
  devtools 95점·LCP 2.8s — 전송량은 2MB→약 320KB로 줄었지만 실측 첫 표시는 조각 요청 수가 늘어 조금 늦어짐.
