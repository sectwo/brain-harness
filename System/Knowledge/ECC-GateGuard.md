---
level: 1
tags: [knowledge, ecc]
source: intratnm 2026-09-25
---
# ECC GateGuard 대응

- ECC의 GateGuard 훅은 세션의 **첫 Bash 명령**과 **파일별 첫 Edit/Write** 전에 작업을 막고 사실 확인을 요구한다.
  (요청 한 줄 요약, 명령이 확인하는 것, 파일을 불러가는 곳, 사용자 지시 원문 등)
- 대응: 요구한 사실을 답변에 적고 **같은 작업을 다시 실행**하면 통과한다. 우회하지 않는다.
- 병렬로 여러 수정을 보냈다면 일부는 이미 적용됐을 수 있다. 파일을 다시 읽고 이어간다.
- 특정 경로를 제외하려면 `GATEGUARD_EXEMPT_GLOBS`, 완전히 끄려면 `ECC_GATEGUARD=off`. 전역 설정 변경이므로 사람 승인 후에만.
