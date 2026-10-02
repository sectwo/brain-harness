# 세션 — 2026-10-03 / master / claude

## 목표
사용자가 회사 로고 원본 파일을 확보해 전달: "/Users/isaac/Documents/Intratnm 위치에 회사 로고들이존재해
확인해줘" → 확인 후 실제 로고를 Header·Footer에 반영.

## 확인한 자료
`/Users/isaac/Documents/Intratnm/01_로고`에 서로 다른 두 디자인이 섞여 있었다.
- ① 2008년 파일(`INRTA한글.jpg`, `intralogo.gif`, `intra(영문).gif`, `logo.gif`): 파란 리본/도로 아이콘 +
  "INTRA / TOOLS & MACHINERY" 워드마크. 해상도가 낮고(최저 237×57) GIF 포맷.
- ② 2026-09-29 파일(`INTRA_로고.png`): "INTRA"(검정) + "A"를 톱니바퀴 윤곽으로 표현한 파란 기어 심볼 +
  "TOOLS & MACHINERY". 2172×724 PNG(투명 배경), 해상도 충분. Overview.md의 "기어/산업기술 계열 그래픽"
  톤과 더 잘 맞음.

두 디자인을 사용자에게 제시하고 선택을 물어 **② 기어 A 로고로 진행하자**는 답을 받았다
(`02_회사정보` 폴더의 주요협력사·주요거래선 이미지는 이번 작업 범위 밖이라 내용만 확인, 아직 미사용).

## 완료한 일
- `public/brand/intra-logo.png`로 로고 원본 복사 (Next.js 표준 서버 빌드라 `next/image` 최적화 적용됨,
  `next.config.ts`에 static export 설정 없음 확인).
- `src/components/Header.tsx`: 텍스트 워드마크("INTRA T&M") → `next/image`로 실제 로고 렌더링.
  로고가 검정+블루 배색이라 네이비 헤더 배경 위에서 검정 글자가 묻히는 문제가 있어, 흰색 chip
  (`rounded-md bg-white`)에 얹어 대비를 확보했다.
- `src/components/Footer.tsx`: 같은 방식으로 좌측 "INTRA T&M" 텍스트를 로고 이미지 + 흰색 chip으로 교체.
  슬로건(`company.tagline`) 문구는 그대로 유지.
- 로고 자체 이미지 파일은 그대로 두고(브랜드 자산 임의 수정 금지 원칙), 대비 문제는 배경 처리로만
  해결했다 — ImageMagick·Pillow 등 이미지 재색상 도구가 로컬에 없기도 했고, 공식 로고 파일 자체를
  고치는 것보다 안전한 선택으로 판단.

## 검증
- `npm run lint`, `npx tsc --noEmit` 통과.
- Chrome DevTools로 `/` 데스크톱(1440px, 헤더+Footer 스크롤)과 모바일(~500px) 확인 — 로고가 흰 chip
  위에서 선명하게 보이고, 가로 스크롤 없음, 모바일 햄버거 메뉴 정상.

## 막힌 점 / 확인 필요
- 없음.

## 추가 작업: 로고·배경 색 어울림 맞추기
사용자가 imweb.me 템플릿 갤러리 링크를 보여주며 "최신 템플릿 구조로 꾸며보는 건 어떨까?"
+ "로고와 배경색은 최대한 어울리게 맞춰주는 작업도 필요할 것 같아"라고 제안.
- **구조 변경 제안은 보류 추천**: 외부 템플릿 구조를 그대로 가져오면 Overview.md에서 요청자가 이미
  확정한 메인페이지 섹션 순서·4메뉴 구조를 무력화하게 된다고 판단해, 기존 구조는 유지하고
  `ui-ux-pro-max` 스킬의 검증된 패턴으로 디테일만 다듬는 쪽을 추천했다. 색 어울림 작업은 바로 진행
  제안. 사용자가 "진행하자"로 이 범위(구조 유지 + 색 조정)를 승인.
- **로고 실측**: 로컬에 ImageMagick·Pillow가 없어, Chrome DevTools로 떠 있는 실제 페이지에서
  `evaluate_script`로 캔버스에 로고(`public/brand/intra-logo.png`)를 그리고 `getImageData`로
  블루 계열 픽셀만 평균 낸 결과 `rgb(0, 97, 184)` ≈ `#0061b8`.
- **검증된 참고 팔레트 대조**: `ui-ux-pro-max --domain color "industrial b2b dark navy corporate blue
  accent"` 조회 결과 "B2B Service" 팔레트(Primary `#0F172A`, Accent `#0369A1`, "Professional navy +
  blue CTA")가 가장 근접. 로고 실측값과 같은 계열(사이언 톤 블루)이라 이 값을 채택.
- **적용**: `src/app/globals.css`의 `--color-blue-accent`를 `#2f6fed` → `#0369a1`로,
  `--color-blue-accent-on-navy`를 `#60a5fa` → `#38bdf8`로 교체. `.bg-aurora`의 하드코딩된 rgba 값도
  같은 색으로 맞춤. 사이트 전역 13개 파일이 Tailwind `blue-accent` 토큰만 참조해 이 한 파일 수정으로
  전체에 반영됨(다른 파일 수정 불필요).
- **대비 재검증**: 화이트 배경 위 `#0369a1` 텍스트/버튼 배경 대비 약 5.93:1(기존 `#2f6fed`는
  4.55:1) — 기존보다 여유가 늘었다. 네이비 배경 위 `#38bdf8` 대비 약 8.44:1(기존 `#60a5fa`는
  7.12:1, 2026-10-01 교차 리뷰로 만든 전용 토큰) — 역시 개선.

## 검증 (색 변경분)
- `npm run lint`, `npx tsc --noEmit`, `npm run build` 모두 통과.
- Chrome DevTools로 `/`(1440px 전체, 390px 모바일 — 실제 렌더 폭은 500px로 나오는 `resize_page` 툴
  특이점 있으나 가로 스크롤 없음 확인), `/company`, `/contact`(1440px) 확인 — 헤더/Footer 로고 chip,
  히어로 오로라 글로우, 버튼, 네비 active 상태, 링크 색이 모두 새 블루로 일관되게 바뀌었고 로고의
  기어 심볼 블루와 같은 계열로 보임. 레이아웃 회귀 없음.

## 다음 할 일
- ~~`ui-ux-pro-max`로 다듬기로 한 "디테일 수준 레이아웃 리파인" 부분은 아직 시작 전~~ → 아래 "추가
  작업: 비주얼 디테일 리파인"에서 완료.
- 로고 교체(Header/Footer) + 색 조정(globals.css)을 묶어서 교차 리뷰 강도를 사용자에게 물어볼 것
  (diff: 3개 파일, +41/-13줄 — 가벼움 강도가 적당해 보임).
- `02_회사정보` 폴더의 주요협력사/주요거래선 이미지는 이번에 다루지 않음 — 필요해지면 별도로 확인.

## 추가 작업: 비주얼 디테일 리파인 (카드·타이포·히어로)
로고·색 작업 커밋(`ee929fd`) 이후 사용자가 "최신 템플릿을 사용해달라고했는데 변한게없네?"라고 지적함.
애초에 "모던 템플릿처럼 꾸며줘"를 "색상만 조정"으로 좁게 해석하고 "진행하자"를 그 좁은 범위 승인으로
받아들인 것이 범위 오해였다고 확인 — 구조/섹션 순서 변경(요청자 재승인 필요)과 기존 구조 안에서의
시각 스타일만 바꾸는 것(카드 디자인·히어로 레이아웃·타이포 스케일·여백·이미지 처리)을 구분해 다시
물었고, 사용자가 "2번 방향으로 진행해줘"(시각 스타일만, 구조 그대로)를 선택했다.

- **작업 방식**: `~/orca/workspaces/intra-tnm/visual-refresh`에 `feat/visual-refresh` 브랜치로 별도
  worktree 생성(브레인 하네스 "기능 하나당 worktree 하나" 원칙). `ee929fd`에서 분기.
  **주의**: `node_modules`를 master의 것과 심볼릭 링크로 연결했더니 Turbopack 빌드가
  `Symlink [project]/node_modules is invalid, it points out of the filesystem root` 에러로 실패함 —
  Turbopack은 프로젝트 루트 밖을 가리키는 node_modules 심링크를 거부한다. 심링크를 지우고
  worktree 안에서 `npm install`로 실제 설치해 해결. **다음에 Next.js(특히 Turbopack 사용) worktree를
  만들 때는 node_modules 심링크 대신 바로 `npm install`하는 쪽이 안전하다.**
- **근거**: `ui-ux-pro-max --domain style`로 현재 구조가 이미 "Feature-Rich Showcase" B2B 랜딩 패턴과
  일치함을 확인(구조 변경 불필요), "Minimalism & Swiss Style"(넉넉한 여백, 명확한 타입 위계, 200-250ms
  hover)과 "Bento Grid Showcase"(카드 표면 처리)를 디테일 리파인의 근거로 채택.
- **바꾼 내용** (6개 파일, `src/components/SectionHeading.tsx`·`PageHero.tsx`·`BrandShowcase.tsx`,
  `src/app/page.tsx`·`company/page.tsx`·`contact/page.tsx`): 섹션 eyebrow 라벨 앞에 작은 accent bar
  추가, 히어로·섹션 제목 크기 확대(`sm:text-5xl` → `lg:text-6xl` 등), 브랜드 카드(Core/Major/Standard)에
  `shadow-sm`+hover 시 떠오르는 효과(`-translate-y`+`shadow-lg/xl`) 추가, 링크 텍스트의 화살표를
  hover 시 오른쪽으로 움직이는 마이크로 인터랙션으로 통일(`group`+`group-hover:translate-x-1`),
  COMPANY 사업영역 카드와 CONTACT 폼에 흰 카드+그림자 처리. 새 CSS 토큰은 추가하지 않고 Tailwind
  기본 유틸리티만 사용. 화면 문구·데이터는 전혀 바꾸지 않음(`src/data/*` 무변경).
- **검증**: worktree에서 `npx next typegen`(신규 worktree라 `.next/types` 캐시가 없어 `LayoutProps`
  타입 누락 — 코드 문제 아니라 캐시 문제, `next typegen`으로 생성) → `npm run lint` 통과 →
  `npx tsc --noEmit` 통과 → `npm run build` 통과(20개 라우트 전부 정상 생성). dev 서버를 포트
  3001에서 띄워(master의 3000 서버는 그대로 둠) Chrome DevTools로 `/`, `/company`, `/brands`,
  `/contact`를 1440px·375px 양쪽에서 전체 페이지 스크린샷 확인 — 가로 스크롤 없음, 카드 hover
  시 테두리 블루·그림자 확대 정상 동작, 모바일에서 연혁 타임라인·브랜드 카드·CONTACT 폼 모두 한
  열로 깔끔하게 쌓임, 접근성 포커스 링·장식 요소 `aria-hidden` 유지 확인.
- **diff 규모**: 6개 파일, +69/-32줄(총 101줄) — "가벼움"(100줄 미만) 기준을 근소하게 넘어 **표준**
  강도를 추천했으나 아직 사용자 응답 전. 변경 내용 대부분이 className/레이아웃 조정이고 로직 변경은
  CONTACT 제출 버튼의 조건부 화살표 렌더링 한 곳뿐이라 사용자에게는 "표준이지만 가벼운 성격"이라고
  설명함.
- **다음 할 일**: 교차 리뷰 강도 확정(표준 추천) 후 Codex 리뷰 진행 → 반영 → `feat/visual-refresh`를
  `master`로 병합할지 사용자와 상의 → 병합 후 worktree 정리(`git worktree remove`).

## 추가 작업: 디자인 스킬 영상 분석 → 스크롤 모션 스태거 적용
- 사용자가 유튜브 영상(AI Labs, "아름다운 웹사이트를 만들기 위한 Claude 디자인 스킬")을 분석·요약해 달라고
  요청. yt-dlp는 자막 엔드포인트 429로 실패해 `youtube-transcript-api`로 자막을 받아 요약 전달.
- 사용자: "이러한 내용들을 적용했으면 좋겠어". 우리 프로젝트에 맞는 것만 추림 — 디자인 방향 선점·업종 기반
  결정은 `ui-ux-pro-max`로 이미 하는 중, 새로 적용할 가치가 있는 건 GSAP 모션 원칙. shadcn·대시보드·모바일
  스킬은 지금 프로젝트 성격과 안 맞아 보류.
- **AI 이미지 생성 원칙 정정(사용자)**: 처음엔 "실제 사진만 쓴다" 원칙 때문에 전면 보류를 추천했으나, 사용자가
  "타사·제품 표현이 아니라 우리(의뢰) 회사를 위한 용도라면 적절히 써도 좋다"고 정정. → 히어로 추상 그래픽,
  OG 이미지, 배경 텍스처 등 장식 용도는 가능, 취급 브랜드 제품을 AI로 그리는 건 계속 금지. 아직 실제 생성 도구는
  이 환경에 연결돼 있지 않음.
- **모델**: 사용자 지시로 메인 세션을 Opus 5.5로 전환(`/model`). 상세설계·중요 설계는 Fable 5.1 Max를 쓰기
  전에 사용자에게 묻기로 함.
- **GSAP 조회 결과와 적용**: `ui-ux-pro-max --domain gsap` 조회 결과, 기존 `ScrollReveal`이 이미 "Scroll Reveal /
  Subtle" 프리셋(transform/opacity만 사용, reduced-motion 가드)과 일치. 문제는 OUR BRANDS(카드 8개)와 NOTICE
  리스트가 한 덩어리로 동시에 페이드인한다는 점 — "Stagger List / Subtle" 프리셋(항목당 40ms) 적용.
  GSAP 라이브러리는 추가하지 않고 `ScrollReveal`에 `stagger` prop 추가: 켜면 내부 `[data-reveal-item]`을
  순서대로 띄운다. 리빌 스타일은 인라인으로 넣고 끝나면 제거해 카드 자체 hover transition과 충돌하지 않게 함.
  바꾼 파일: `ScrollReveal.tsx`, `src/app/page.tsx`(OUR BRANDS·NOTICE에 stagger + 항목 표시),
  `BrandShowcase.tsx`(카드 3종 Link에 `data-reveal-item` — `/brands` 페이지에선 래퍼가 없어 영향 없음).
- **검증**: lint·tsc·build 통과. Chrome DevTools(1440px)에서 스크롤 시 헤딩→URYU→BIX→HIOS→… 순으로 opacity가
  계단식으로 올라가는 것 수치로 확인, 1초 뒤 인라인 스타일 전부 제거·카드 hover transition 0.2s 복원 확인.
- **diff 규모(worktree 전체 누적)**: 7개 파일, +119/-51 → 교차 리뷰는 표준 강도 추천 유지.

## 교차 리뷰: feat/visual-refresh (표준)
위 섹션들의 "교차 리뷰 강도 확정(표준 추천) 후 Codex 리뷰 진행"은 이 섹션으로 완료됐다.
- **강도·리뷰어**: 사용자가 **표준**을 선택. 리뷰어는 Codex, 모델 `gpt-5.6-terra`, 추론 medium
  (L1 규칙의 표준 강도 매핑).
- **실행 방식 특이점(도구 지식)**: 이 Codex CLI 버전에서는 `codex review`의 `--uncommitted`와
  `--base <브랜치>` 옵션 둘 다 커스텀 지시문(PROMPT)과 함께 쓸 수 없어 에러가 난다
  (`the argument '--base <BRANCH>' cannot be used with '[PROMPT]'`). 그래서 변경분을
  `feat/visual-refresh` 브랜치에 먼저 로컬 커밋(`bcff1bb`)한 뒤,
  `codex exec -m gpt-5.6-terra -c model_reasoning_effort="medium" -s read-only "<지시문: git diff
  master...HEAD를 리뷰하라 ...>"` 방식으로 읽기 전용 리뷰를 돌렸다. 이 우회법은 L1 `/cross-review`
  명령 원본(`~/Brain/System/commands/cross-review.md`)의 실행 예시와 다르다 — L1 반영 여부는 아래
  "다음 할 일"에 제안으로만 남기고 L1 파일은 손대지 않았다.
- **리뷰 범위**: master 대비 diff(7개 파일) + `ScrollReveal` 사용처, `/brands` 페이지.
- **결과**: 치명 0, 높음 0, 참고 1.
  - 참고: `src/components/ScrollReveal.tsx` — `requestAnimationFrame` 실행 전에 정리 타이머를
    시작하고 RAF ID를 보관·취소하지 않아, 백그라운드 탭 등으로 타이머가 먼저 돌면 스타일을 지운 뒤
    RAF가 인라인 opacity/transform을 다시 써넣어 영구히 남고 카드 hover transform이 막힐 수 있음.
    언마운트 시에도 RAF가 남음.
  - **반영함**: RAF ID를 배열에 보관해 cleanup에서 `cancelAnimationFrame`, 정리 타이머는 RAF 콜백
    안에서 시작하도록 수정. 커밋 `909bddc`. 사용자의 "유도리있게 진행하자" 방침에 따라, 근거가
    명확하고 범위가 작은 지적이라 바로 반영한 뒤 보고했다.
  - 리뷰어 확인 사항(문제 없음): reduced-motion·JS 미동작·IntersectionObserver 미지원 경로에서
    콘텐츠가 숨지 않음, 장식 bar의 `aria-hidden`·포커스 링 유지, 외부 링크 `target="_blank"` +
    `rel="noopener noreferrer"` 유지, SEO 메타 유지, 회사 정보·노출 문구의 사실 변경이나 새 사실
    추가 없음.
- **수정 후 검증**: lint·tsc·build 통과. Chrome DevTools(1440px)에서 스태거 리빌이 순차적으로
  진행되고(중간 측정 opacity 0.55→0.40→0.24→0.06→0…) 1.2초 뒤 모든 항목의 인라인 style이 비고
  opacity 1임을 확인.
- **재리뷰**: 수정이 지적 범위 그대로라 재리뷰는 하지 않음(L1 규칙상 재리뷰는 1회까지 가능, 필요하면
  사용자 판단).
- **브랜치 상태**: `feat/visual-refresh`에 커밋 2개(`bcff1bb`, `909bddc`), master 대비 7개 파일
  +124/-51. 아직 master 병합 전, push 안 함.

### 다음 할 일
- `feat/visual-refresh`를 master로 병합할지 사용자와 상의 → 병합 후 `git worktree remove`로 정리.
- L1 `/cross-review` 명령의 Codex 실행 예시를 `codex exec` 읽기 전용 방식으로 고칠지 사용자와 상의
  (L1 변경이라 계획·확인 필요).
- Fable 기록 방침·모델 운용 변경(아래 "운영 방침 변경")을 L1 Rules.md "5. 모델 선택"에 반영할지
  사용자와 상의 (L1 변경이라 계획·확인 필요).

## 운영 방침 변경
- **메인 세션 모델**: 사용자 지시로 Opus 5.5로 전환. 상세설계·정말 중요한 설계는 Fable(Max)을 쓰기
  전에 사용자에게 묻는다.
- **vault 기록은 Fable이 담당**: 사용자 지시 — "브레인 하네스에 실제로 커밋하고 기록하기 위한 내용들은
  Fable을 통해서 진행 — 중요하니까". 이번 기록부터 Fable 하위 에이전트가 vault 기록·커밋을 맡는다.
- **유도리**: 사용자 — "너무 딱딱하게 생각하지 말고 유도리있게 진행하자". 절차를 과하게 격식화하지
  않되, push·되돌리기 어려운 작업·L1 변경의 사전 확인은 유지한다.

## master 병합 및 worktree 정리
위 "교차 리뷰" 섹션의 다음 할 일 중 "master 병합 여부 상의 → worktree 정리"는 이 섹션으로 완료됐다.
- **계기**: 사용자가 "진행 중인 인트라티앤엠 웹사이트 프로젝트에 적용해서 진행해볼까?"라고 해서
  `feat/visual-refresh`를 master에 병합했다.
- **병합**: `git merge --ff-only feat/visual-refresh`로 fast-forward 병합(`ee929fd` → `909bddc`).
  7개 파일, +124/-51.
- **병합 후 검증**: master에서 lint·tsc·build 통과. 포트 3000 dev 서버에서 Chrome DevTools(1440px)로
  확인 — OUR BRANDS 스태거 항목 9개가 리빌 후 모두 opacity 1이고 인라인 style이 비어 있으며 가로
  스크롤 없음.
- **정리**: 포트 3001 dev 서버 종료, `git worktree remove ~/orca/workspaces/intra-tnm/visual-refresh`,
  `git branch -d feat/visual-refresh`.
- **push**: 프로젝트 저장소 push는 하지 않음(사용자 승인 필요).
- **남은 worktree**(사실만 기록, 상태 판단 안 함): `design-refresh`(feat/design-refresh),
  `margate`(summarize-agents-md), `review-notice-contact`(detached HEAD).

### 다음 할 일
- L1 `/cross-review` 명령의 Codex 실행 예시를 `codex exec` 읽기 전용 방식으로 고칠지 사용자와 상의
  (L1 변경이라 계획·확인 필요) — 아직 남음.
- Fable 기록 방침·모델 운용 변경("운영 방침 변경" 참고)을 L1 Rules.md "5. 모델 선택"에 반영할지
  사용자와 상의 (L1 변경이라 계획·확인 필요) — 아직 남음.

## 남은 worktree·브랜치 정리
위 "master 병합 및 worktree 정리" 섹션의 "남은 worktree" 목록은 이 정리로 해소됐다.
- **계기**: 사용자 지시 "남은 worktree들도 정리해줘".
- **정리 전 점검**:
  - `design-refresh`(feat/design-refresh, `6b794c4`)와 `margate`(summarize-agents-md, `4f5ab9e`):
    HEAD가 master에 포함돼 있고 미추적 파일은 `node_modules`뿐이라 `git worktree remove --force`로 제거.
  - `review-notice-contact`(detached HEAD, `775f0c1`): HEAD는 master에 포함돼 있었지만 스테이징된
    변경 18개가 있었다. 비교 결과 NOTICE·CONTACT 초기 구현 스냅샷으로, master에 이미 들어간 내용이고
    master 쪽이 더 최신(PageHero 적용, CONTACT 에러 포커스 접근성, pretendard 의존성 등)이었다.
    worktree에만 있는 작업은 없다고 판단. 만약을 위해 스테이징 변경을 패치로 백업
    (`git diff --cached --binary` → 세션 scratchpad의 `review-notice-contact-staged.patch`, 세션 임시
    폴더라 영구 보관은 아님)한 뒤 `--force`로 제거.
- **dev 서버**: design-refresh 경로에서 돌던 포트 3100 dev 서버 종료. master의 포트 3000 dev 서버는 유지.
- **브랜치 삭제**: 병합된 브랜치 5개를 `git branch -d`로 삭제 — feat/design-refresh,
  summarize-agents-md, feat/brands, feat/company-page, feat/notice (뒤의 3개는 worktree 없이 남아
  있던 브랜치, 모두 master 포함 확인).
- **결과**: 프로젝트 저장소에는 master worktree·브랜치 하나만 남음. push 안 함.

### 참고(Fable 점검 중 발견)
- 이전 vault 커밋 점검에서 `Overview.md`의 "오시는 길 지도: 앱키는 …(개발자)이 발급" 문구에 개발자
  실명이 들어 있어 역할명 규칙상 검토 후보로 보고됨 — 이번엔 고치지 않았고 사용자 판단 대기.

## L1·L2 문서 정리 (실명·/cross-review·모델 규칙)
위 "다음 할 일"의 L1 반영 제안 2건(`/cross-review` Codex 실행 방식, Fable 기록·모델 운용 변경)과
"참고(Fable 점검 중 발견)"의 실명 검토 후보는 이 작업으로 완료됐다.
- **승인**: 사용자가 계획을 보고 승인("계획 보여주고 진행해줘"). 기록·커밋은 Fable 하위 에이전트가 수행.
- **백업**: L1 변경 전 `Rules.md`, `commands/cross-review.md`, `System/Decisions.md`를
  `/Users/isaac/.brain-backups/2026-10-03/`에 복사 (vault `.gitignore`가 백업 폴더를 무시하지 않아 vault
  밖에 둠, `.gitignore`는 손대지 않음).
- **실명 정리 (5곳)**: `Overview.md` 3곳(카카오맵 앱키 발급 주체 2곳, 예비 시안 문구 1곳)과 프로젝트
  `Decisions.md` 1곳을 "개발자"로, `System/Decisions.md`의 `git config --global` 완료 괄호(이름+이메일)를
  "(사용자 본인 계정으로 설정)"으로 바꿈. 대표자 이름 등 공식 회사 정보는 그대로. 정리 후 vault 전체
  grep 0건 확인.
- **`System/commands/cross-review.md`**: 3단계 Codex 리뷰를 `codex exec -s read-only` 방식으로 교체
  (`codex review --base`가 PROMPT와 함께 안 되는 제약 명시, 커밋 안 된 변경은 먼저 로컬 커밋, 지시문 없는
  기본 리뷰는 `codex review --base`도 가능). `install-commands.sh` 실행 후 `~/.claude/commands/`와 diff 없음 확인.
- **`System/Rules.md`**: 5절 표에 Fable 행 추가, 메인 세션 기본을 Opus 5.5로, "vault 기록·커밋은 Fable
  하위 에이전트" 불릿 추가. "유도리 있게 진행" 불릿은 5절(모델)이 아니라 7절의 "L1 변경 사전 확인" 불릿
  바로 아래에 둠 — 같은 주제(무엇을 확인받고 무엇은 안 받는지)라서.
- **`System/Decisions.md`**: 2026-10-03 결정 추가 (모델 운용 변경·/cross-review Codex 실행 방식 변경).
- push 안 함.

## push
- 사용자 승인 후 두 저장소를 push했다.
  - `intra-tnm` `master`: `0192867..909bddc` (origin/master = `909bddc` 확인)
  - `brain-harness` `main`: `69d20cc..265bce7` (origin/main = `265bce7` 확인)
- 프로젝트 저장소 worktree는 `master` 하나뿐.

## /handoff (Fable 하위 에이전트)
- 이 로그 이후 `/handoff` 실행: `Handoff.md` 갱신(last_handoff 2026-10-03), `Knowledge/` 노트 4개 신규,
  `Agents/Claude.md`·`Agents/Codex.md` 특이점 추가, `System/Projects.md` intratnm 행 갱신. L1 Knowledge/Rules/
  Environment는 손대지 않고 승격 후보만 보고.

## L1 지식 승격
- `/handoff`가 보고한 L1 승격 후보 중 사용자가 **1·2·3·4·7번만 승인**("추천한 1,2,3,4,7번 올려줘").
  기록·커밋은 Fable 하위 에이전트가 수행.
- 만든 L1 노트 5개 (`System/Knowledge/`, README 목록에 추가):
  1. [[System/Knowledge/Codex-Review-Output]] — Codex 출력은 `head`로 자르지 말고 파일로 끝까지 받기 (10-02 로그)
  2. [[System/Knowledge/Claude-Plugin-Install]] — 세션 중 설치한 플러그인은 완전 재시작해야 로드됨 (10-01 로그)
  3. [[System/Knowledge/Nextjs-Worktree]] — Turbopack 심링크 거부 → `npm install`, `next typegen` 먼저,
     `agentRules: false`, Codex 샌드박스 `--webpack` (09-26 ×2, 10-01 codex, 10-03 로그)
  4. [[System/Knowledge/Chrome-DevTools-MCP]] — `fullPage` sticky/IntersectionObserver artifact,
     `resize_page` 폭 차이 (09-26 design-refresh, 10-01, 10-03 로그)
  7. [[System/Knowledge/Plugin-Supply-Chain-Check]] — 플러그인 설치 전 점검 체크리스트 + L1 Decisions 2026-10-01 링크
- **L2 정리** (중복 금지): `Knowledge/Nextjs-Worktree-And-Build.md`에서 범용 내용을 L1으로 옮기고
  L1 링크 + intratnm 고유 내용(dev 포트 3001, proxy.ts·Web Crypto, ESLint 규칙, 검증 루틴)만 남김.
  `Knowledge/README.md` 설명도 맞춤. `Handoff.md`에는 승격 관련 표시가 없어 손대지 않음.
- **보류**: 후보 5·6·8번은 사용자 미승인(2026-10-03) — L1에 올리지 않음. 8번 내용("백그라운드 임시
  출력은 세션 압축 사이 사라질 수 있음")도 Codex-Review-Output 노트에 넣지 않았다.
- Rules.md·Environment.md는 고치지 않음. push 안 함.
- **정정**: 미승인 6번(Codex 샌드박스 `--webpack` build) 내용이 L1 `Nextjs-Worktree.md`에 섞여 들어간 것을
  발견했다. 사용자 지시("A로 되돌리고 push해줘")로 L1 노트·README에서 빼고 L2
  `Knowledge/Nextjs-Worktree-And-Build.md`의 "Codex 리뷰 시 빌드" 절로 되돌렸다. 위 3번 줄의
  "Codex 샌드박스 `--webpack`" 표기는 이 정정 전 기록이다. 이 정정은 Fable 하위 에이전트가 중간에
  멈춰서(변경 없음 확인) 메인 세션이 직접 처리했다.
