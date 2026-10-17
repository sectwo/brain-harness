---
project: intratnm
summary: "NOTICE 파일 저장소(`.data/notices.json`)와 HMAC 세션 관리자 로그인 1차 구현"
tags: [intratnm, knowledge, notice, admin]
source: Sessions 2026-09-26-master (NOTICE 구현, 커밋 80e7d82)
---
# NOTICE 게시판·관리자 구조 (1차 구현)

> 배포 서버의 Node.js 실행 가능 여부가 확인되기 전까지의 임시 구조. 확인 결과에 따라 저장소를 DB로 바꿀 수 있다.

## 저장소
- 파일 기반: `.data/notices.json` (저장소 루트, `.gitignore`에 `/.data/` 등록 — 런타임 데이터는 커밋하지 않음).
- 접근 코드: `src/lib/notice-store.ts`. API: `src/app/api/notices/`, `src/app/api/admin/`.
- 메인페이지는 NOTICE를 직접 읽어 최근 3건을 보여 주므로 `force-dynamic`이다.

## 관리자 인증
- `/admin/login` → 비밀번호 1개(`ADMIN_PASSWORD`) 확인 후 **HMAC 서명 세션 쿠키** 발급
  (서명 키 `ADMIN_SESSION_SECRET`). `/admin/notice`에서 CRUD.
- 구현: `src/lib/admin-auth.ts` — `src/proxy.ts`(구 middleware)가 Edge Runtime이라 `node:crypto` 대신
  Web Crypto(`crypto.subtle`) 사용.
- 검증 방법(09-26): curl로 로그인 성공/실패, 인증 없는 API 차단, CRUD 전체를 직접 확인.
- **한계**: 최소 구현(비밀번호 1개, 사용자 계정 없음). 실제 배포 전 재검토 필요. 초기 구현은 교차 리뷰를
  건너뛰었다(사람 결정).

## 운영 전제
- 회사 직원이 웹에서 직접 작성(요청자 확정) → 외부 CMS·임베드 안 씀. 단, 호스팅이 정적/PHP 공유호스팅으로
  확인되면 별도 작은 백엔드가 필요해지고 그때는 예외로 취급(Overview "결정된 구현 방식" 참고).
