# Overview — intratnm 홈페이지

> 사람이 작성하는 기준 문서. 에이전트는 여기 없는 회사 정보를 지어내지 않는다.
> 아래 콘텐츠는 홈페이지 제작요청자 **이시영**이 ChatGPT로 정리해 전달한 콘텐츠 기획서
> (2026-09-26 수신, [[Decisions#2026-09-26 — 이시영 콘텐츠 기획서 반영]] 참고)를 그대로 옮긴 것이다.
> 디자인이 아니라 **콘텐츠·구조 기획서**이며, 기존에 이삭(사용자)이 만든 예비 시안의 디자인/레이아웃 위에 적용한다.

## 회사
- 회사명: ㈜인트라티앤엠 / INTRA T&M CO., LTD.
- 대표자: 이제정
- 사업자등록번호: 108-81-18365
- 설립: 1999년 (URYU SEISAKU·BIX 대리점 계약과 함께 법인 설립)
- 주소: 서울특별시 금천구 가산디지털1로 168, 우림라이온스밸리 C동 1001호
- TEL: 02-2026-3388 / FAX: 02-2026-3399 / E-mail: intra@intratnm.com
- 한 줄 소개(메인 비주얼 카피): "산업 현장을 위한 전문 공구와 기술"
- 업종: 산업용 체결 공구를 중심으로 전동 드라이버, 비트·소켓, 자동 나사공급기, 공압 부품,
  포카요케(Poka-Yoke) 시스템, 납땜 장비 등 생산·조립 현장용 제품을 공급하는 회사 (해외 제조사 국내 총판/대리점).
  자체 제조는 하지 않으며 "전문 제조사의 제품을 공급하고 적합한 제품을 제안하는" 역할로 표현한다.

## 홈페이지 목표
- 회사 신뢰도 제고 + 취급 브랜드 소개 + 제품·견적 문의 유도.
- **핵심 운영 원칙**: 개별 제품을 DB로 등록·관리하지 않는다. 신제품·단종·모델 변경마다 홈페이지를 고쳐야 하는
  유지보수 부담을 피하기 위해, 제품은 **브랜드 단위**로만 소개하고 상세 사양·모델은 **제조사 공식 카탈로그/홈페이지로 링크**한다.

## 요구사항 (전달 기준: 2026-09-26 자료)
- 기존 예비 시안의 디자인/레이아웃을 그대로 유지하고 콘텐츠만 이 기획서로 교체한다.
- 다크 네이비 + 화이트/라이트그레이를 섹션별로 교차시키는 톤 (제안된 흐름: NAVY Hero → WHITE Company →
  라이트그레이 Brands → NAVY Trusted Experience/Notice → WHITE Contact → 딥네이비 Footer). 최종 색 배치는 예비 시안 우선.
- 메인 비주얼은 특정 제조사 제품 사진이 아니라 기어/산업기술 계열 그래픽을 사용한다. 실제 제품 사진은 BRANDS 페이지 내부에서만 쓴다.
- 반응형(모바일) 구성 필요 — TODO(확인 필요): 구현 여부·범위 미착수.

## 사이트 구조 (페이지)
상단 메인 메뉴는 4개로 단순화한다 (탐색 과정에서 COMPANY/PRODUCTS/BRANDS/APPLICATIONS/SUPPORT + 별도
Product Database 안까지 검토했다가, "브랜드 중심 + 유지보수 최소화" 원칙에 따라 최종적으로 아래로 좁혀졌다):

**COMPANY　|　BRANDS　|　NOTICE　|　CONTACT**

- **COMPANY**: 회사소개 / 연혁 / 사업영역 / 오시는 길
- **BRANDS**: 별도 PRODUCT 메뉴 없이 브랜드 중심으로 제품에 접근. 8개 브랜드를 브랜드 페이지에서 소개.
- **NOTICE**: 하위 메뉴 없이 클릭 시 공지사항 게시판으로 바로 이동.
- **CONTACT**: 제품·견적 문의 하나로 통합 (제품문의/견적문의/기술문의를 나누지 않음).
- PRODUCT SEARCH, APPLICATIONS, SUPPORT 메뉴는 검토했으나 **채택하지 않음** (콘텐츠 유지 부담 대비 실익이 적다고 판단).

### 메인페이지 흐름
```
HEADER (INTRA T&M 로고 + COMPANY|BRANDS|NOTICE|CONTACT)
  ↓
MAIN VISUAL — "산업 현장을 위한 전문 공구와 기술" + 기어/산업기술 그래픽
  ↓
COMPANY 소개 요약 (자세히 보기 → 링크만, 연혁·오시는 길은 메인에 안 보여줌)
  ↓
OUR BRANDS — URYU / BIX / HIOS / OHTAKE-ROOT / HERUTU / CHIYODA / GOOT / KTC (클릭 시 브랜드 상세)
  ↓
TRUSTED EXPERIENCE (짧은 네이비 띠, 로고 대신 텍스트)
  - AUTOMOTIVE: 현대자동차 · 기아자동차
  - ELECTRONICS & INDUSTRIAL: 삼성전자서비스 · 아이마켓코리아 · 코리아이플랫폼
  (공장명(울산/아산/전주, 화성/소하리/광주 등)은 메인에는 안 넣고, 필요하면 COMPANY 안에서만)
  ↓
NOTICE — 최근 공지 3건
  ↓
CONTACT — 제품·견적 문의
  ↓
FOOTER — INTRA T&M 로고 + 회사정보 + TEL/FAX/E-mail (웹사이트 주소는 표시 안 함)
```

### COMPANY 상세
- **회사소개**: "산업 현장과 함께 성장해온 전문 파트너, INTRA T&M" — 1999년 설립 이후 산업용 에어공구·체결
  공구를 중심으로 전동 드라이버, 비트·소켓, 자동 나사공급기, 공압 부품, 포카요케 시스템, 납땜 장비 등을
  공급해왔다는 내용. (기존 2019년 회사소개서의 `Tool & Machinery Partner!` 정체성을 계승)
- **연혁** (기존 회사소개서 1999~2019 기준, 홈페이지용으로 선별):

  | 연도 | 내용 |
  |---|---|
  | 1999 | URYU SEISAKU 대리점 계약 / BIX 대리점 계약 / ㈜인트라티앤엠 법인 설립 |
  | 2000 | YAMAZEN 대리점 계약 |
  | 2001 | 울산영업소 설립 |
  | 2004 | HIOS 대리점 계약 |
  | 2006 | 서울 금천구 본사 이전 |
  | 2007 | 인트라이엔지 법인 설립 / GOOT 대리점 계약 / 대전영업소 설립 / CHIYODA 대리점 계약 |
  | 2008 | 경영혁신형 중소기업 인증 획득 |
  | 2012 | ISO 14001 인증 획득 |
  | 2014 | KTC 대리점 계약 |
  | 2019 | 기업부설연구소 설립 |

  - YAMAZEN은 현재 BRANDS 목록에서는 제외하지만 실제 연혁이므로 연혁 표에는 유지한다.
  - TODO(확인 필요): 2020년 이후 연혁, HERUTU 취급/거래 시작 연도.
- **사업영역** (제품 모델이 아니라 회사가 다루는 기술·분야 중심):
  산업용 체결 공구(URYU) / 체결 액세서리(BIX) / 전동 체결 장비(HIOS) / 조립·생산 자동화(OHTAKE-ROOT) /
  품질관리·Poka-Yoke(HERUTU) / 공압 관련 제품(CHIYODA) / 전자 조립 장비(GOOT) / 산업용 공구(KTC)
- **오시는 길**: 주소/TEL/FAX/E-mail + 지도 영역(위치 마커, [지도에서 보기], 가능하면 [길찾기], 모바일에서 지도
  앱으로 바로 열리게). TODO(확인 필요): 어떤 지도 서비스/API를 쓸지는 사이트 구현 환경에 맞춰 결정.

### BRANDS 상세
공통 템플릿: **브랜드 로고 → 브랜드 소개 → 주요 제품군 → 대표 제품사진(가능하면 직접 촬영) →
제조사 공식 카탈로그 링크 → 제품·견적 문의**. **개별 제품 모델 상세 페이지는 만들지 않는다**
(제품 변경·단종에 따른 유지보수 부담 때문). 제품군 표기는 `English (한글)` 형식으로 통일한다.

브랜드는 아래 순서로 노출한다 (URYU가 매출 비중 약 80%로 핵심 브랜드이므로 최상단, 다른 브랜드보다
소개·제품군을 상세하게 구성; BIX는 중간 수준; HIOS 이하는 간결하게):

1. **URYU SEISAKU** (핵심 브랜드) — 일본 산업용 공구 제조사. 오일펄스 공구·정밀 체결 시스템, 임팩트렌치,
   너트러너, 드릴, 그라인더 등.
   - 제품군: Fastening Tools(체결 공구: Oil Pulse/Impact Wrench/Nutrunner), Drills & Tappers(드릴 및 태퍼),
     Grinding & Abrasive Tools(그라인딩 및 연마 공구), Screwdrivers(드라이버),
     Fastening Control Systems(체결 관리 시스템: UDP·UCX·UEC 계열), Testers & Other Tools(테스터 및 기타 공구)
   - 공식 홈페이지(후보, 최종 확인 필요): https://www.uryu.co.jp/ , 영문 https://www.uryu.co.jp/english/
2. **BIX** — 일본 드라이버 비트·임팩트 소켓 전문 제조사. 특주품·OEM 대응 가능.
   - 제품군: Driver Bits(드라이버 비트), Socket Bits(소켓 비트), Impact Sockets(임팩트 소켓),
     Special Sockets(특수 소켓), Custom Products(특주 제품)
   - 공식 홈페이지(후보): https://www.bix-co.jp/
3. **HIOS** — 일본 산업용 전동 드라이버·체결기기 전문 제조사.
   - 제품군: Electric Screwdrivers(전동 드라이버), Screw Counters & Controllers(체결 수량 관리·제어기기),
     Torque Measuring Equipment(토크 측정·검사기기), Accessories(액세서리)
   - 공식 홈페이지: TODO(확인 필요) — 자료에서 URL 미확보.
4. **OHTAKE-ROOT** — 일본 자동 나사공급기 전문 제조사. (기존 회사소개서 표기 `OTAKE` 대신 공식 명칭
     `OHTAKE-ROOT` 사용)
   - 제품군: Automatic Screw Feeders(자동 나사공급기), Automation/Robotic Screw Feeders(자동화·로봇용
     나사공급기), Pneumatic Screw Feeders(공압식 나사공급기), Hoppers & Accessories(호퍼 및 액세서리)
   - 공식 홈페이지(후보): https://ohtake-root.co.jp/ , 영문 https://ohtake-root.co.jp/en/
5. **HERUTU** — 일본 산업용 무선기기·포카요케(Poka-Yoke) 전문 제조사. 취급 시작이 비교적 최근이라
   과장 없이 간결하게 구성.
   - 제품군: Check Pen(체크펜), Transmitter/Receiver(송·수신기), Grease Gun(그리스건),
     Pliers Wrench(플라이어 렌치)
   - 실제 취급 모델(체크펜 모델번호 등)이 확정되지 않았으므로 **모델번호를 임의로 표시하지 않는다.**
   - 공식 홈페이지(후보): https://www.herutu.co.jp/
6. **CHIYODA** — 일본 산업용 공압 배관 부품 전문 제조사 (CHIYODA TSUSHO).
   - 제품군: Fittings(피팅), Tubes & Hoses(튜브 및 호스), Couplings(커플링), Hose Fittings(호스 피팅)
   - 공식 홈페이지(후보): https://chiyoda-pneumatic.co.jp/
7. **GOOT** — 일본 TAIYO ELECTRIC IND.의 납땜기기 전문 브랜드.
   - 제품군: Soldering Irons(납땜 인두기), Soldering Stations(납땜 스테이션),
     Desoldering Products(디솔더링 제품), Soldering Accessories(납땜 액세서리)
   - 공식 홈페이지(후보): https://en.goot.jp/
8. **KTC** (KYOTO TOOL) — 일본 산업용·자동차 정비용 공구 전문 제조사. 취급 비중이 작아 가장 간결하게 구성.
   - 제품군: Hand Tools(수공구), Torque & Measuring Tools(토크 및 측정 공구), Power Tools(동력 공구),
     Automotive Tools(자동차 정비 공구)
   - 공식 홈페이지(후보): https://ktc.jp/ , 영문 https://en.ktc.jp/

브랜드 이미지 운영: 가능하면 INTRA T&M에서 직접 촬영한 실제 취급 제품 사진을 쓴다. 브랜드마다 전 제품을
찍지 않고 대표 제품·제품군 사진 몇 장만 사용한다 (예: URYU는 Oil Pulse / Impact Wrench / Drill / Grinder /
Controller 계열 정도).

### NOTICE
하위 메뉴 없이 단일 게시판 하나로 회사 공지 / 휴무 안내 / 제조사 안내 / 카탈로그 업데이트 / 신제품 안내를
모두 운영한다. 메인페이지에는 최근 3건만 노출.

### CONTACT
"제품이나 견적에 대해 궁금한 사항이 있으신가요? 필요한 제품 및 문의 내용을 보내주시면 담당자가 확인 후
연락드리겠습니다." + `[ 제품·견적 문의하기 → ]` 버튼. 문의 내용은 최종적으로 회사 이메일
`intra@intratnm.com`으로 전달되도록 구성한다. TODO(확인 필요): 폼→이메일 전송 구현 방식.

### FOOTER
INTRA T&M 로고 + "산업 현장을 위한 전문 공구와 기술" + 회사명(㈜인트라티앤엠 / INTRA T&M CO., LTD.) +
대표자(이제정) + 사업자등록번호(108-81-18365) + 주소 + TEL(02-2026-3388) + FAX(02-2026-3399) +
E-mail(intra@intratnm.com). **현재 홈페이지 웹 주소는 Footer에 표시하지 않는다** (최종 전달안 기준).

## 디자인
- 브랜드 컬러: 다크 네이비 + 블루 포인트, 기어/정밀산업 그래픽을 아이덴티티 요소로 사용.
- 참고 시안: 임이삭 프로젝트에서 이미 제작한 예비 시안 (레이아웃 기준, 파일 위치는 별도 확인 필요 —
  TODO(확인 필요)).
- 로고: 헤더 좌측 + Footer 좌측 2곳만 노출 권장. `OUR BRANDS`, `TRUSTED EXPERIENCE` 영역에는 INTRA 로고를
  넣지 않는다 (제조사 로고와 혼동 방지, 신뢰 섹션 단순화).
- 각 브랜드 공식 로고 파일: TODO(확인 필요), 미확보.

## 기술 스택
- 미정. 결정되면 [[Decisions]]에 기록 후 여기 요약.
- 이번 자료는 콘텐츠·구조 기획서일 뿐 기술 스택과는 무관.

## 배포 / 도메인
- TODO(확인 필요)

## 남은 확인 사항 (자료 자체가 명시한 미확정 항목)
- 2020년 이후 회사 연혁
- HERUTU 취급/거래 시작 연도
- 각 브랜드 공식 로고 파일
- 각 브랜드 공식 카탈로그 연결 최종 URL (위 후보 URL은 리서치 단계 확인일 뿐 최종 확정 아님)
- 브랜드별로 사용할 대표 제품사진 (직접 촬영 목록·실물 미정)
- CONTACT 문의→이메일 연결 구현 방식
- NOTICE 게시판 구현 방식
- 모바일 반응형 구성
- 오시는 길 지도 연동에 쓸 지도 서비스/API 선택

## 저장소
- 로컬: `~/orca/projects/intra-tnm` (Orca로 관리)
- 규칙: 저장소의 `AGENTS.md`
