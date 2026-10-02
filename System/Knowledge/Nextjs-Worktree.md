---
level: 1
tags: [knowledge, nextjs, worktree, turbopack]
source: intratnm 2026-09-26, 2026-10-01, 2026-10-03
---
# Next.js(Turbopack) 프로젝트에서 git worktree 쓸 때

## 상황
Next.js 16 프로젝트에서 기능별 worktree를 새로 만들어 빌드·타입체크를 돌리면 코드와 무관한
이유로 실패하거나, `next dev`가 저장소 문서를 건드린다.

## 원인과 해결

### 1. `node_modules` 심링크 → Turbopack이 거부
- master의 `node_modules`를 worktree에 심볼릭 링크로 연결하면 Turbopack(기본 `next build`/`next dev`)이
  `Symlink [project]/node_modules is invalid, it points out of the filesystem root`로 실패한다.
  프로젝트 루트 밖을 가리키는 `node_modules` 심링크를 거부하기 때문이다.
- **해결: worktree마다 `npm install`로 실제 설치한다.** `npx next build --webpack`으로 우회할 수도
  있지만(2026-09-26에 사용) 실제 설치가 더 안전하다.
- master에 새 의존성이 들어온 뒤 다른 worktree에서 빌드가 깨지면 역시 `npm install`부터 한다.

### 2. 새 worktree는 `next typegen`을 먼저
- 새 worktree에는 `.next/types` 캐시가 없어 `npx tsc --noEmit`에서 `LayoutProps` 같은 타입이
  누락된 것으로 나온다. 코드 문제가 아니라 캐시 문제다.
- **해결: `npx next typegen`을 먼저 실행**한 뒤 lint → tsc → build 순서로 돌린다.

### 3. `next dev`가 `AGENTS.md`를 고친다 → `agentRules: false`
- Next 16 `next dev`는 `AGENTS.md`에 "agent rules" 안내 블록을 자동으로 덧붙인다.
- **해결: `next.config.ts`에 `agentRules: false`**를 넣어 하네스 규칙 문서를 보호한다.

## 출처
- [[Projects/intratnm/Sessions/2026-10-03-master-claude]] — 심링크 거부 확인, `next typegen`
- [[Projects/intratnm/Sessions/2026-09-26-design-refresh-claude]] — `--webpack` 우회
- [[Projects/intratnm/Sessions/2026-09-26-master-claude]] — `agentRules: false`
- 프로젝트 고유 내용(proxy.ts, ESLint 규칙, 검증 루틴)은 [[Projects/intratnm/Knowledge/Nextjs-Worktree-And-Build]]
