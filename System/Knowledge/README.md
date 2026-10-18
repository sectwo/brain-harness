---
level: 1
tags: [system, knowledge]
---
# Knowledge — L1 공통 지식

> 프로젝트를 넘어 쓰는 지식. 한 주제에 한 파일. `/handoff`가 승격 후보를 제안하고 사람이 승인한 것만 올린다.
> 각 파일에는 "출처"(어느 프로젝트·날짜에서 알게 됐는지)를 적는다.

| 파일 | 내용 |
|---|---|
| [[System/Knowledge/Orca-Codex-Headroom]] | Orca에서 띄우는 Codex를 Headroom 프록시로 보내는 법 |
| [[System/Knowledge/ECC-GateGuard]] | ECC GateGuard 훅이 작업을 멈출 때 대응, 현재 예외 설정, 훅 판정을 가짜 입력으로 확인하는 법 |
| [[System/Knowledge/Headroom-Output-Compression]] | Headroom이 도구 출력을 압축할 때 원문 보는 법 |
| [[System/Knowledge/Codex-Review-Output]] | `codex review`/`exec` 출력은 `head`로 자르지 말고 파일로 끝까지 받기 · 비대화형 실행은 `< /dev/null`로 stdin을 닫기 |
| [[System/Knowledge/Claude-Plugin-Install]] | 세션 중 설치한 플러그인은 로드 안 됨(완전 재시작 필요) + 한 프로젝트에만 태그 고정 설치(--scope project) |
| [[System/Knowledge/Nextjs-Worktree]] | Next.js(Turbopack) worktree: `npm install`·`next typegen`·`agentRules: false` |
| [[System/Knowledge/Chrome-DevTools-MCP]] | `fullPage`/`resize_page` 캡처 artifact — 실제 스크롤·실측으로 재확인, MCP 프로필이 막히면 headless Chrome + CDP로 대체 촬영 |
| [[System/Knowledge/Plugin-Supply-Chain-Check]] | 서드파티 Claude Code 플러그인 설치 전 공급망 점검 체크리스트 |
| [[System/Knowledge/Binary-Install-Without-Brew]] | brew가 CLT 버전 때문에 막힐 때 GitHub 공식 릴리스 바이너리를 체크섬·코드 서명 확인 후 ~/.local/bin에 두는 법 |
| [[System/Knowledge/PreToolUse-Commit-Guard]] | Claude Code PreToolUse(Bash) 훅으로 에이전트 git commit을 막는 패턴과 함정 6가지 (precommit-check.sh) |
| [[System/Knowledge/macOS-Korean-Filename-NFD]] | macOS 한글 파일명은 NFD — 스크립트에서 경로를 정규식·문자열로 비교하기 전에 normalize("NFC") |
| [[System/Knowledge/Lighthouse-LCP-Diagnosis]] | Lighthouse 성능이 낮을 때 LCP 요소·단계(TTFB/로드 지연/로드/렌더 지연)로 원인을 가르고, 바꾸지 않은 페이지·다른 측정 방식(simulate/devtools)과 비교해 진짜 원인인지 확인 |
