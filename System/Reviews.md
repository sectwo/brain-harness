---
level: 1
tags: [system, review]
review_interval_days: 30
last_review: 2026-09-25
---
# Reviews — 브레인 정기 점검

> 최상위 브레인 레벨에서 주기(`review_interval_days`)마다 진행한다. 절차는 [[System/Rules#1. 하네스 트리]]의 "정기 점검".
> 주기가 지나면 세션 시작 맥락에 알림이 뜬다. 끝나면 `last_review`를 갱신하고 아래에 기록을 추가한다.

## 점검 절차
1. **현황**: `/harness-audit`, `/cost-report`, `headroom perf`, 최근 세션 로그의 막힌 점 훑기
2. **조사**: 에이전트 하네스·기억 구조·모델 운용·도구의 최신 방법 (공식 문서, 재현 가능한 결과, 실사용 사례가 있는 것만)
3. **후보 정리**: 효과 / 비용(토큰·시간) / 위험 / 적용 계층(L1·L2·L3) / 되돌리기 방법
4. **상의**: 사람과 채택·보류·제외를 정한다. 채택분만 적용하고 [[System/Decisions]]에 기록
5. **기록**: 아래에 날짜별로 남기고 `last_review` 갱신

## 기록
### 2026-09-25 — 브레인 하네스 첫 구성
- 트리 구조(L1/L2/L3), 모델 자동 설정(opusplan, 사용량 경고), ECC 스킬 채택 범위 결정 → [[System/Decisions]]
- `/harness-audit`(intratnm repo): 14/39. 코드·CI 전 단계라 테스트·CI·GitHub 항목 실패는 예상된 것. 스캐폴딩 후 재점검
