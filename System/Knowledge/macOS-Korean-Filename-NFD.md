---
level: 1
summary: "macOS 한글 파일명은 NFD — 스크립트에서 경로를 정규식·문자열로 비교하기 전에 normalize(\"NFC\")"
source: intratnm 2026-10-18
tags: [system, knowledge, macos, unicode, script]
---
# macOS 한글 파일명 NFD 함정

## 언제 쓰나
- Node·Python 스크립트가 `readdir`/`os.walk`로 읽은 한글 파일·폴더 이름을 정규식이나 `includes`로 거르는데
  아무것도 걸리지 않을 때 (예: `/시안|스크린샷/.test(name)`가 늘 false).
- 요청자가 보낸 자료 폴더(한글 이름)를 자동 처리할 때.

## 방법
- 비교 직전에 정규화한다: Node `name.normalize("NFC")`, Python `unicodedata.normalize("NFC", name)`.
- 파일을 **여는** 경로는 읽은 그대로(원래 바이트) 써도 된다 — 바꾸는 건 비교·표시용 문자열만.
- 소스 코드에 직접 적은 한글 경로(`"02_브랜드자료/로고/…"`)는 NFC지만 macOS(APFS)가 열 때 맞춰 주므로 `access`·`sharp(path)`는 그대로 동작한다.

## 주의
- 오류 없이 "0건 일치"로 조용히 실패한다. 걸러진 개수를 출력해 0이면 의심한다.
- 화면 출력(로그·라벨)에 그대로 쓰면 자모가 분리돼 보일 수 있다 — 표시 전에도 NFC.
- 셸 glob(`ls *시안*`)은 대체로 맞춰 주지만 스크립트 정규식은 아니다.

## 관련
- [[Projects/intratnm/Sessions/2026-10-18-sectwo-개발-claude]] — 이미지 대조용 contact sheet 스크립트가 0건으로 실패한 사례
