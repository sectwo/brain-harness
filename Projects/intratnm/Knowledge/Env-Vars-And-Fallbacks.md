---
project: intratnm
summary: "`.env.example` 변수 5개와 미설정 시 자리표시 동작"
tags: [intratnm, knowledge, env]
source: Sessions 2026-09-26-master; 저장소 `.env.example`
---
# 환경 변수와 미설정 시 동작

`.env.example`에 이름만 문서화돼 있고 값은 전부 비어 있다(비밀 값은 커밋하지 않음). 비어 있어도 사이트는
빌드·동작하며, 각 기능이 자리표시 동작으로 대체된다.

| 변수 | 용도 | 미설정 시 |
|---|---|---|
| `NEXT_PUBLIC_KAKAO_MAP_KEY` | COMPANY 오시는 길 카카오맵 SDK 키 (개발자가 발급, 허용 도메인 `www.intratnm.com` + 로컬) | `KakaoMap` 컴포넌트가 자리표시자 + 외부 지도 링크로 대체 |
| `ADMIN_PASSWORD` | NOTICE 관리자 로그인 비밀번호 | 로그인 불가 |
| `ADMIN_SESSION_SECRET` | 관리자 세션 쿠키 HMAC 서명 키 (`openssl rand -hex 32` 등) | 로그인 불가 |
| `RESEND_API_KEY` | CONTACT 폼 → `intra@intratnm.com` 이메일 전송 | API가 503 + 회사 이메일로 직접 문의 안내 |
| `CONTACT_FROM_EMAIL` | Resend 발신 주소 (Resend에 인증된 도메인 필요). 수신은 항상 회사 이메일 고정 | 전송 불가 |

- 패턴: "키 없으면 자리표시자 + 안내"를 카카오맵과 CONTACT 양쪽에 같은 방식으로 적용했다.
- CONTACT 개인정보 동의 체크박스 옆 문구는 법적 문구를 지어내지 않기 위해 **TODO 자리표시자가 화면에 그대로
  노출**된다 — 사람이 문구를 주면 교체.
- 참고: `.env.example` 2행 주석에 발급자 실명이 들어 있다(역할명 규칙 위반 후보, Handoff 다음 할 일 참고).
