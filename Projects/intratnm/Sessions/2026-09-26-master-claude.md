# 세션 — 2026-09-26 / master / claude

## 목표
Next.js 스캐폴딩 완료 + 홈페이지 제작요청자(요청자) 인터뷰로 Overview.md의 남은 확인 사항 채우기

## 완료한 일
- Next.js(App Router) + TypeScript + Tailwind CSS 스캐폴딩을 `~/orca/projects/intra-tnm`에 생성,
  기존 harness `AGENTS.md`/`CLAUDE.md`는 건드리지 않고 병합. `npm install`·`npm run build`·`npm run lint`
  모두 통과 확인 후 커밋(`0f6013f`).
- 기술 스택 결정(Next.js+TS+Tailwind) vault 커밋 (`80751ce`).
- 요청자 1차 인터뷰 진행 (하나씩 순서대로 질문하는 방식으로 전환, 상세는 [[Decisions#2026-09-26 —
  요청자 1차 인터뷰: 남은 확인 사항 정리]]):
  - 회사 연혁 2019년 확정(추가 없음), HERUTU 시작 연도 보류
  - 디자인 목업 없음 확인 → 콘텐츠 기획서의 구조·색상 설명을 디자인 브리프로 채택
  - 브랜드 로고 8개 전부 제조사 홈페이지에서 확보 필요, 카탈로그 URL 8개 전부 확정(HIOS: hios.com)
  - 레거시 사이트(`www.intratnm.com`) 직접 크롤링 → URYU/BIX/HIOS/CHIYODA/GOOT 5개 브랜드는 기존
    제품사진 재사용 승인, OHTAKE-ROOT/KTC/HERUTU 3개는 신규 확보 필요
  - NOTICE 자체 구현, CONTACT는 이메일 API(Resend 등), 지도는 카카오맵, 배포는 회사 자체 서버+기존
    도메인(`www.intratnm.com`) 유지, 모바일 반응형은 전체 페이지 적용
- `Overview.md`/`Decisions.md`에 위 내용 전부 반영.

## 바꾼 파일
- 저장소(`intra-tnm`): Next.js 스캐폴딩 17개 파일 (커밋 `0f6013f`)
- vault: `Overview.md`, `Decisions.md` 다수 수정 — 아직 커밋 전(이 세션 로그와 함께 커밋 예정)

## 막힌 점 / 확인 필요
- HERUTU 취급 시작 연도 — 계약일자 확인 필요 (요청자가 확인 예정)
- OHTAKE-ROOT / KTC / HERUTU 대표 제품사진 — 신규 확보 필요
- 배포 서버가 Node.js 실행 가능한지 정적 호스팅인지 — 요청자가 확인 예정. 확인 전까지 Node 서버
  배포를 기본 가정으로 개발 진행.

## 다음 할 일 (1차 마무리 시점 — 아래 "이어서" 참고)
- 위 3개 확인 사항 회신 오면 Overview.md 반영
- 실제 페이지 구현 시작 (COMPANY/BRANDS/NOTICE/CONTACT), 카카오맵 API 키 발급, Resend 연동 준비
- `/cross-review`는 아직 실행 안 함 — 스캐폴딩 diff가 작아서 필요성 낮다고 판단, 실제 페이지 구현이
  쌓이면 사람에게 강도 추천과 함께 제안

## 이어서 (같은 세션, 압축 후 재개)

### 완료한 일
- Fable(리뷰 전용 서브에이전트)로 설계 문서(Overview·Decisions·README) 정합성 리뷰 → 발견된 모순
  직접 수정, 사실 확인이 필요한 항목은 요청자에게 하나씩 순서대로 질문 (→ [[Decisions#2026-09-26 —
  Fable 리뷰 반영: 문서 정합성 정리]], [[Decisions#2026-09-26 — 요청자 2차 인터뷰: Fable 리뷰 남은
  확인 사항 정리]]). NOTICE가 회사 직원 직접 작성으로 정해지며 배포 서버 Node.js 지원 여부 확인이
  최우선 과제로 올라감.
- **요청자 실명 제거**: 사람이 "이시영이라는 이름이 커밋에 대놓고 드러난다"고 지적 → Overview·
  Decisions·세션 로그 본문 38곳을 "요청자"로 치환(커밋), 이미 push된 커밋 메시지 3개(콘텐츠 기획서
  반영/1차 인터뷰/2차 인터뷰)는 `git filter-branch --msg-filter`로 재작성 후
  `git push --force-with-lease`로 원격에 반영. 원본은 로컬 전용 `backup/pre-name-scrub` 브랜치에 보존
  (삭제 여부 확인 대기). 이후로는 커밋/문서에 실명 대신 역할명만 쓰기로 함 (에이전트 메모리에 기록).
- **COMPANY 페이지 구현** (`~/orca/workspaces/intra-tnm/company-page`, 브랜치 `feat/company-page`,
  커밋 `2f4aa3f`):
  - `src/data/company.ts`: 회사 정보 단일 출처, Overview.md 문구 그대로
  - 공통 `Header`/`Footer`/`MobileNavToggle`(모바일 햄버거), `nav-links.ts`
  - `/company`: 회사소개·연혁·사업영역(브랜드 카드, `/brands/<slug>` 링크)·오시는 길 + `KakaoMap`
    컴포넌트(앱키 `NEXT_PUBLIC_KAKAO_MAP_KEY` 미발급 상태라 자리표시자 + 외부 링크로 대체)
  - `globals.css`에 다크 네이비/블루 포인트/라이트그레이 고정 팔레트, OS 다크모드 미디어쿼리 제거
  - `layout.tsx`: `lang="ko"`, 기본 메타데이터(title 템플릿)
  - 미사용 기본 svg 5개 삭제, `.env.example`에 카카오 키 이름 문서화
  - **발견**: Next 16 `next dev`가 `AGENTS.md`에 "agent rules" 안내 블록을 자동으로 덧붙임 → 우리
    하네스 규칙 문서 보호를 위해 `next.config.ts`에 `agentRules: false` 추가
  - 검증: `npm run build`·`lint`·`tsc --noEmit` 통과, Chrome DevTools MCP로 375px/1280px 스크린샷 확인,
    모바일 햄버거 메뉴 클릭 동작(a11y 트리로 `aria-expanded` 등) 확인

### 바꾼 파일
- vault: `Overview.md`/`Decisions.md`/이 세션 로그 실명 치환 커밋, Decisions에 항목 2개 추가
- Brain 저장소 커밋 메시지 3개 재작성 + force-push (히스토리 재작성, 원격 반영)
- `intra-tnm` worktree `company-page`: 17개 파일 변경 (커밋 `2f4aa3f`, 아직 병합 전)

### 막힌 점 / 확인 필요
- (이전과 동일) HERUTU 취급 시작 연도, OHTAKE-ROOT/KTC/HERUTU 제품사진, 배포 서버 Node.js 지원 여부,
  개인정보 동의 문구, TRUSTED EXPERIENCE 고객사 실명 노출 최종 확인
- `backup/pre-name-scrub` 브랜치(로컬 전용, 실명 포함 원본) 삭제 여부 — 사람 확인 대기

### 다음 할 일
- `feat/company-page` 교차 리뷰 강도 추천(표준) 제시 → 사람이 고른 강도로 `/cross-review` 진행
- 리뷰 반영 후 `master`에 병합
- BRANDS → 메인페이지 → NOTICE(Node.js 확인 후) → CONTACT 순으로 이어서 구현 (각각 별도 worktree)
- `/handoff` 실행해 Handoff.md 갱신 (현재 Handoff.md는 2026-09-25 시점 그대로 정체)
