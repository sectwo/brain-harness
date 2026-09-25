---
level: 1
tags: [knowledge, headroom]
source: intratnm 2026-09-25
---
# Headroom이 도구 출력을 압축할 때

- Headroom 프록시는 긴 Bash 출력 등을 압축해서 `[N words compressed ...]` 표시와 함께 일부만 보여 준다.
  압축된 출력은 공백·줄바꿈이 사라지거나 내용이 빠질 수 있다.
- **정확한 원문이 필요하면(파일을 고치기 전 등) Read 도구로 파일을 직접 읽는다.** Read/Glob 출력은 압축 대상에서 빠진다.
- 여러 파일을 한 번에 `cat`해서 보는 것은 압축되기 쉬우니 피한다.
