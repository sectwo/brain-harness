---
level: 1
tags: [knowledge, claude-code, plugin, security]
source: intratnm 2026-10-01
---
# 서드파티 Claude Code 플러그인 공급망 점검 절차

## 상황
공식 Anthropic 도구가 아닌 커뮤니티 플러그인(스킬)을 L1(사용자 범위)에 설치하려 할 때.
설치하면 모든 프로젝트에 영향을 주므로 소스를 직접 확인한 뒤에만 넣는다.

## 절차 (체크리스트)
1. **저장소를 스크래치패드에 클론**해 소스를 직접 읽는다 (README만 믿지 않는다).
2. **매니페스트 확인**: `plugin.json` / `marketplace.json`에 hooks·MCP 서버·postinstall(설치 훅)이
   없는지 본다. 실제 로드되는 것이 SKILL.md(프롬프트)와 로컬 데이터(CSV/JSON)뿐인지 확인한다.
3. **위험 패턴 grep**: 동봉 스크립트에서 네트워크 호출·`subprocess`·`os.system`·`eval`/`exec`·`socket`
   등을 찾는다.
4. **설치 경로**: README가 전역 npm CLI(`npm install -g …`, 출처 미검증)를 권해도 쓰지 않고,
   `claude plugin marketplace add` + `claude plugin install`(Claude Code 표준 플러그인 방식, 스킬
   디렉터리만 참조)로만 설치한다.
5. **설치 전 백업**: `~/.claude/plugins/known_marketplaces.json`·`installed_plugins.json`을
   `~/.claude/plugins/.backup-<날짜>/`에 복사한다.
6. **설치 후 확인**: `claude plugin details`(정적 컴포넌트 인벤토리)와 새 `claude -p` 프로세스(독립
   세션) 두 방법으로 정상 로드를 확인한다. 떠 있던 세션에서는 보이지 않으니
   [[Claude-Plugin-Install]] 참고.
7. **기록**: 결정·검토 과정·기각한 대안을 `System/Decisions.md`에 남긴다. 되돌리기는
   `claude plugin uninstall`.

## 출처
- [[Projects/intratnm/Sessions/2026-10-01-master-claude]] — "브레인 하네스 도구 추가 조사·설치"
- [[System/Decisions#2026-10-01 — 서드파티 Claude Code 플러그인 2종 L1 설치 (karpathy-skills, ui-ux-pro-max)]] — 실제 적용 사례와 결정 근거
