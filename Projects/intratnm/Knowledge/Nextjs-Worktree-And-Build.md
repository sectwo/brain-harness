---
project: intratnm
tags: [intratnm, knowledge, nextjs, worktree]
source: Sessions 2026-09-26-design-refresh, 2026-09-26-master, 2026-10-01-master-codex, 2026-10-03-master
---
# Next.js 16 worktree·빌드 특이점

## worktree를 새로 만들 때
- **`node_modules`를 master 쪽으로 심볼릭 링크하지 말고 worktree 안에서 `npm install`한다.**
  Turbopack(기본 `next build`/`next dev`)은 프로젝트 루트 밖을 가리키는 `node_modules` 심링크를
  `Symlink [project]/node_modules is invalid, it points out of the filesystem root`로 거부한다(10-03 확인).
  09-26 design-refresh 때는 `npx next build --webpack`으로 우회했지만, 실제 설치가 더 안전하다.
- 새 worktree는 `.next/types` 캐시가 없어 `npx tsc --noEmit`에서 `LayoutProps` 등 타입이 누락된다.
  코드 문제가 아니라 캐시 문제 — **`npx next typegen`을 먼저 실행**한 뒤 lint → tsc → build 순으로 돌린다.
- master에 새 의존성(예: `resend`)이 들어온 뒤 다른 worktree에서 빌드가 깨지면 `npm install`부터 한다.
- dev 서버는 master가 포트 3000을 쓰고 있으므로 worktree는 3001 등 다른 포트로 띄운다.
- Codex 샌드박스(`-s read-only`)에서는 Turbopack build가 포트 바인딩 제한으로 실패한다 →
  리뷰 지시문에서 `npm run build -- --webpack`을 쓰게 한다(10-01 Codex 로그).

## 프로젝트 설정
- `next.config.ts`에 `agentRules: false`. Next 16 `next dev`가 `AGENTS.md`에 "agent rules" 안내 블록을
  자동으로 덧붙이므로 하네스 규칙 문서 보호용(09-26).
- `middleware.ts`는 Next 16에서 폐기 예고 → `@next/codemod`로 `src/proxy.ts`로 전환했다.
  Edge Runtime에서는 `node:crypto`를 못 쓰므로 `src/lib/admin-auth.ts`는 Web Crypto(`crypto.subtle`) 기반이다.
- ESLint `react-hooks/set-state-in-effect`가 effect 안의 동기 setState를 막는다. `ScrollReveal`은
  React 상태 대신 DOM 클래스를 직접 토글하는 방식으로 작성했다(10-01).

## 검증 루틴 (매 기능)
`npm run lint` → `npx tsc --noEmit` → `npm run build` → Chrome DevTools MCP로 1440px·375px 스크린샷.
`package-lock.json`은 실제 의존성 추가가 아니면 되돌려 diff를 깨끗하게 유지한다.
