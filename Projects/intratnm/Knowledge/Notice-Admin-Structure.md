---
project: intratnm
summary: "NOTICE 파일 저장소(`.data/notices.json`, 직렬화·원자적 쓰기)와 HMAC 세션 관리자 로그인(해시 비교·쓰기 API Origin 검사) 구조, 배포 전 남은 보안 항목"
tags: [intratnm, knowledge, notice, admin]
source: Sessions 2026-09-26-master (NOTICE 구현), [[Projects/intratnm/Sessions/2026-10-19-sectwo-개발-claude]] (사후 보안 리뷰 반영)
---
# NOTICE 게시판·관리자 구조

> 배포 서버의 Node.js 실행 가능 여부가 확인되기 전까지의 임시 구조. 확인 결과에 따라 저장소를 DB로 바꿀 수 있다.

## 저장소
- 파일 기반: `.data/notices.json` (저장소 루트, `.gitignore`에 `/.data/` 등록 — 런타임 데이터는 커밋하지 않음).
- 접근 코드: `src/lib/notice-store.ts`. API: `src/app/api/notices/`, `src/app/api/admin/`.
- 쓰기는 프로세스 안에서 큐로 직렬화하고, 임시 파일에 쓴 뒤 `rename`으로 원자적 교체한다.
  **단일 프로세스 전제** — 다중 프로세스(PM2 cluster 등)로 배포하면 DB로 바꿔야 한다.
- 메인페이지는 NOTICE를 직접 읽어 최근 3건을 보여 주므로 `force-dynamic`이다.

## 관리자 인증
- `/admin/login` → 비밀번호 1개(`ADMIN_PASSWORD`) 확인 후 **HMAC 서명 세션 쿠키** 발급
  (서명 키 `ADMIN_SESSION_SECRET`). `/admin/notice`에서 CRUD.
- 구현: `src/lib/admin-auth.ts` — `src/proxy.ts`(구 middleware)가 Edge Runtime이라 `node:crypto` 대신
  Web Crypto(`crypto.subtle`) 사용. `checkPassword`는 SHA-256 해시끼리 비교(async, 길이 차이로 조기 반환하지 않음).
- 상태 변경 API(관리자 로그인·로그아웃·공지 쓰기)는 `isSameOrigin`으로 요청 Origin을 검사한다 — 다른/없는 Origin은 403.
- 검증 방법: curl로 로그인 성공/실패, 인증 없는 API 차단, CRUD, Origin 403, 동시 작성 보존을 직접 확인.
- **한계**: 최소 구현(비밀번호 1개, 사용자 계정 없음). 배포 서버 확정 후 남은 보안 항목: 로그인 시도 제한, CONTACT 요청 수 제한,
  무상태 토큰이라 로그아웃 후에도 만료(12h)까지 유효 → 토큰 무효화·비밀키 회전 절차. 실제 관리자 화면 로그인·작성은 사람 확인 대기.

## 운영 전제
- 회사 직원이 웹에서 직접 작성(요청자 확정) → 외부 CMS·임베드 안 씀. 단, 호스팅이 정적/PHP 공유호스팅으로
  확인되면 별도 작은 백엔드가 필요해지고 그때는 예외로 취급(Overview "결정된 구현 방식" 참고).

## 관련
- [[Projects/intratnm/Decisions#2026-10-18 — 메인 COMPANY 요약 섹션 제거 · CONTACT 요청 수 제한 보류]] — 요청 수 제한은 배포 서버 확정 후
