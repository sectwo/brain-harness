---
level: 1
summary: "`fullPage`/`resize_page` 캡처 artifact — 실제 스크롤·실측으로 재확인"
tags: [knowledge, chrome-devtools, mcp, screenshot]
source: intratnm 2026-09-26, 2026-10-01, 2026-10-03
---
# Chrome DevTools MCP 스크린샷 캡처 주의점

## 상황
Chrome DevTools MCP로 페이지를 스크린샷 찍어 레이아웃을 검증할 때, 캡처 결과가 실제 사용자가 보는
화면과 다르게 나와 버그로 오해할 수 있다.

## 원인과 해결

### 1. `fullPage` 캡처 — sticky 요소가 중복돼 보임
- sticky 라벨과 sticky Header가 `fullPage` 스크린샷에서 중복 렌더된 것처럼 보였다.
- 실제 스크롤 상태 스크린샷으로 재확인한 결과 **캡처 방식의 artifact**일 뿐 실제 버그가 아니었다.

### 2. `fullPage` 캡처 — IntersectionObserver 리빌 섹션이 비어 보임
- 스크롤 리빌(CSS + IntersectionObserver)을 적용한 섹션이 `fullPage` 캡처에서 비어 보였다.
- 캡처 시 리사이즈가 너무 빨라 IntersectionObserver가 발동하기 전에 찍히는 **캡처 도구의 타이밍
  artifact**였다. 실제 스크롤 시뮬레이션으로는 정상 동작을 재확인했다.
- 실제 사용자는 항상 스크롤로 접근하므로 문제 없음 — 단, 판정은 반드시 실제 스크롤로 한다.

### 3. `resize_page` — 요청 폭과 실제 렌더 폭이 다름
- 모바일 390px로 `resize_page`했는데 실제 렌더 폭은 500px로 나온 사례가 있다.
- 모바일 검증 결과를 기록할 때 요청 폭이 아니라 **실제 렌더 폭**을 적고, 가로 스크롤 유무 등은
  그 폭 기준으로 판단한다.

## 절차
1. `fullPage` 캡처는 전체 배치를 빠르게 훑는 용도로만 쓴다.
2. sticky·스크롤 리빌·애니메이션이 있는 영역은 **실제 스크롤 상태**에서 다시 찍어 판정한다.
3. 색·치수처럼 수치가 필요한 것은 스크린샷 대신 `evaluate_script`로 실측한다
   (예: `getComputedStyle`로 실제 렌더 색 확인, 캔버스 `getImageData`로 이미지 색 평균).

## 출처
- [[Projects/intratnm/Sessions/2026-09-26-design-refresh-claude]] — sticky 중복 artifact
- [[Projects/intratnm/Sessions/2026-10-01-master-claude]] — IntersectionObserver 타이밍 artifact, `getComputedStyle` 확인
- [[Projects/intratnm/Sessions/2026-10-03-master-claude]] — `resize_page` 폭 차이, 캔버스 실측
