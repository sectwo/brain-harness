---
project: intratnm
date: 2026-09-26
agent: claude
worktree: design-refresh
tags: [intratnm, session]
---
# 세션 — 2026-09-26 / design-refresh / claude

## 목표
사용자 요청("배경디자인이 너무투박해 조금더 회사 이미지에맞게 변경해주고 연혁표도 표현이 좋지않아
최근 트렌드에 맞는 ui/ux를 분석하고 회사 브랜드와 어울리게 변경해줘" + "기타 제품군 브랜드들의
배치도생각해줘")에 따라 전체 페이지 배경·연혁 표현·브랜드 배치를 리디자인.

## 계획 (사람 확인 여부: 승인됨, `/Users/isaac/.claude/plans/eager-discovering-glacier.md`)
- 브랜드 배치는 사용자가 `AskUserQuestion`으로 **비중별 3단 배치**(URYU 대표 카드 → BIX·HIOS 중간
  카드 → 나머지 5개 작은 카드)를 직접 선택.
- worktree `~/orca/workspaces/intra-tnm/design-refresh`, 브랜치 `feat/design-refresh`,
  `node_modules`는 master worktree에 심볼릭 링크.

## 완료한 일
- **한글 글꼴**: Pretendard(`next/font/local`)로 교체. 기존 Geist는 라틴 전용이라 한글이 시스템
  폰트로 떨어지던 문제 해결.
- **공통 컴포넌트 신규 작성**: `GearLineArt`(장식용 선화 SVG, `aria-hidden`), `SectionHeading`
  (영문 eyebrow + 큰 제목), `PageHero`(서브 페이지 공통 히어로 — 설계도 격자 배경 + 블루 글로우 +
  기어 선화), `BrandShowcase`(브랜드 3단 배치).
- **배경**: 채운 도형 대신 `.bg-blueprint`(격자선) + `.bg-glow`(방사형 글로우) CSS 유틸리티로
  메인 히어로·서브 페이지 히어로·CONTACT 배너를 정밀산업 느낌으로 교체. `prefers-reduced-motion`
  대응 추가.
- **연혁 재설계**(`/company#history`): 왼쪽에 sticky "SINCE 1999 / 연혁" 라벨, 오른쪽에 연도별
  타임라인(그라데이션 큰 연도 숫자 + 점선 + 항목별 분류 칩). 분류 칩은 `historyKind()` 도우미로
  기존 연혁 문구를 키워드로만 분류한 것이라 새 사실이 아님.
- **브랜드 3단 배치**: `Brand.tier`(`core`/`major`/`standard`) 필드 추가 후 `BrandShowcase`가
  메인페이지와 `/brands` 양쪽에서 재사용됨. URYU만 대표 브랜드 배지 노출(매출 비중 수치는 화면에
  넣지 않음, Overview.md 원칙 준수).
- **Header/Footer**: Header를 sticky + 활성 메뉴 표시로, Footer를 3열 그리드로 재정리(내용 변경 없음).
- 8개 페이지(`/`, `/company`, `/brands`, `/brands/[slug]`, `/notice`, `/contact`) 전부 새 컴포넌트
  적용, `/notice/[id]`·`/admin/*`은 계획대로 손대지 않음.
- **검증**:
  - `npx next build --webpack` 성공 (Turbopack이 symlink된 `node_modules`를 거부하는 환경 이슈라
    `--webpack`으로 우회 — 코드 문제 아님, master의 비-symlink `node_modules`로는 기본 Turbopack도
    정상 빌드됨을 확인).
  - Chrome DevTools로 `/`, `/company`, `/brands`, `/brands/uryu`, `/contact`를 1440px·375px에서
    스크린샷 확인 — 가로 스크롤 없음, 3단 브랜드 배치·연혁 타임라인·모바일 스택 모두 정상.
  - sticky 라벨("연혁")과 sticky Header가 `fullPage` 스크린샷에서 중복 렌더된 것처럼 보인 문제는
    실제 스크롤 상태 스크린샷으로 재확인한 결과 캡처 방식의 artifact일 뿐 실제 버그 아님으로 결론.
  - `git diff src/data/`로 대조: `brands.ts`(+14줄), `company.ts`(+10줄) 모두 `tier`/`historyKind`
    추가뿐, 회사 정보·연혁·브랜드 소개 문구는 전혀 바뀌지 않음.

## 바꾼 파일
- 신규: `src/components/{BrandShowcase,GearLineArt,PageHero,SectionHeading}.tsx`
- 수정: `package.json`, `package-lock.json`(Pretendard 의존성), `src/app/layout.tsx`,
  `src/app/globals.css`, `src/app/page.tsx`, `src/app/company/page.tsx`, `src/app/brands/page.tsx`,
  `src/app/brands/[slug]/page.tsx`, `src/app/notice/page.tsx`, `src/app/contact/page.tsx`,
  `src/components/Header.tsx`, `src/components/Footer.tsx`, `src/data/brands.ts`, `src/data/company.ts`
- 총 diff: 14개 수정 파일 274줄 추가/196줄 삭제 + 신규 컴포넌트 4개 225줄. 아직 커밋 전.

## 결정 (→ Decisions에도 기록 예정)
- 브랜드 등급(`tier`)·연혁 분류 칩(`historyKind`)은 UI 표현용 파생 값이며 Overview.md에 새 사실을
  추가하는 것이 아니다 — 계획 단계에서 이미 확정, 이번 세션에서 구현으로 검증 완료.

## 막힌 점 / 확인 필요
- 없음 (이번 세션 범위 안에서는 회사 정보를 새로 만들지 않았음).

## 다음 할 일
- 커밋 전, diff 규모(18개 파일, 순증감 약 500~700줄)를 사람에게 보여주고 교차 리뷰 강도
  (표준 추천, 심층도 고려 가능)를 골라달라고 요청 — 아직 완료 안 함, 이 로그 작성 직후 진행 예정.
- 교차 리뷰(Codex) → 반영 → 커밋 → `master` 병합.
