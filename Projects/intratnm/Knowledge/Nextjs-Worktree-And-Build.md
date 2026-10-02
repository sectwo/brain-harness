---
project: intratnm
tags: [intratnm, knowledge, nextjs, worktree]
source: Sessions 2026-09-26-design-refresh, 2026-09-26-master, 2026-10-01-master-codex, 2026-10-03-master
---
# Next.js 16 worktree·빌드 특이점 (intratnm 고유)

## worktree를 새로 만들 때
범용 내용(Turbopack `node_modules` 심링크 거부 → `npm install`, `next typegen` 먼저, `agentRules: false`,
Codex 샌드박스 `--webpack` build)은 **L1 [[System/Knowledge/Nextjs-Worktree]]로 승격**(2026-10-03).
아래는 이 프로젝트에만 해당하는 것.
- dev 서버는 master가 포트 3000을 쓰고 있으므로 worktree는 3001 등 다른 포트로 띄운다.

## 프로젝트 설정
- `middleware.ts`는 Next 16에서 폐기 예고 → `@next/codemod`로 `src/proxy.ts`로 전환했다.
  Edge Runtime에서는 `node:crypto`를 못 쓰므로 `src/lib/admin-auth.ts`는 Web Crypto(`crypto.subtle`) 기반이다.
- ESLint `react-hooks/set-state-in-effect`가 effect 안의 동기 setState를 막는다. `ScrollReveal`은
  React 상태 대신 DOM 클래스를 직접 토글하는 방식으로 작성했다(10-01).

## 검증 루틴 (매 기능)
`npm run lint` → `npx tsc --noEmit` → `npm run build` → Chrome DevTools MCP로 1440px·375px 스크린샷
(캡처 주의점은 [[System/Knowledge/Chrome-DevTools-MCP]]).
`package-lock.json`은 실제 의존성 추가가 아니면 되돌려 diff를 깨끗하게 유지한다.
