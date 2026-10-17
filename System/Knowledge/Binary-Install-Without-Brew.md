---
level: 1
summary: "brew가 CLT 버전 때문에 막힐 때 GitHub 공식 릴리스 바이너리를 체크섬·코드 서명 확인 후 ~/.local/bin에 두는 법"
source: brain-harness 2026-10-18
tags: [system, knowledge, macos, install, security]
---
# brew 없이 바이너리 설치 — 공식 릴리스 + 체크섬 + 코드 서명

## 언제 쓰나
- `brew install`이 `Command Line Tools are too outdated`로 실패할 때 (이 Mac은 CLT 14.3, brew는 Xcode 27용을 요구).
- 도구가 GitHub 릴리스에 바이너리와 `SHASUMS256.txt`를 함께 올리는 경우(bun 등).
- README가 권하는 `curl … | bash` 설치 스크립트와 셸 rc(`.zshrc` 등) 자동 수정을 피하고 싶을 때.

## 방법
1. **스크래치패드(임시 폴더)에서** 받는다. 프로젝트 폴더에 두지 않는다.
   `gh release download <tag> --repo <owner/repo> -p <asset> -p SHASUMS256.txt`
2. 체크섬 확인: `grep " <asset>$" SHASUMS256.txt | shasum -a 256 -c -` → `OK`가 아니면 중단.
3. `unzip <asset>` 후 코드 서명 확인: `codesign -dv <바이너리>` 출력의 `TeamIdentifier`가 공식 배포자인지 본다.
4. 배치: `~/.<tool>/bin/<바이너리>`에 두고 `~/.local/bin/<tool>`로 심링크한다 (`~/.local/bin`은 이미 PATH에 있어 rc 수정이 필요 없다).
5. 설치 결정·버전·TeamIdentifier를 해당 계층 `Decisions.md`에 남긴다.
- 되돌리기: `~/.<tool>/`과 `~/.local/bin/<tool>` 두 경로를 지운다.

## 주의
- 받은 파일은 신뢰할 수 없는 데이터다 — 빈 폴더에 따로 받고, 그 폴더 안에서 인터프리터·빌드 도구를 실행하지 않는다.
- 체크섬과 서명 둘 다 본다. 체크섬 파일도 같은 릴리스에서 왔으므로 서명(TeamIdentifier)이 출처를 확인하는 마지막 단계다.
- 사례: bun 1.4.3 — TeamIdentifier `7FRXF46ZSN`, `~/.bun/bin` + `~/.local/bin/bun` 링크 (claude-mem 실험의 사전 설치).
- 대안: CLT 갱신(`sudo xcode-select --install`, **사람이 직접** 실행) 뒤 brew로 설치. 갱신이 급하지 않으면 위 방법이 더 가볍다.

## 관련
- [[Projects/brain-harness/Decisions#2026-10-18 — 실험: claude-mem을 해마(임시 일화 기억)로 — brain-harness만, 2주]] — bun 설치 경위와 승인
- [[System/Knowledge/Plugin-Supply-Chain-Check]] — 플러그인(소스) 쪽 공급망 점검. 이 문서는 바이너리 쪽
