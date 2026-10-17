@AGENTS.md
@Projects/brain-harness/Handoff.md

## 실험: task-observer (one-skill) — brain-harness만
→ [[Projects/brain-harness/Decisions#2026-10-18 — 실험: one-skill(task-observer) — brain-harness만, 세션 5회 또는 1주]]
작업 폴더는 `/Users/isaac/.brain-experiments/task-observer` 하나로 고정한다 (worktree 안에 만들지 않는다).
관찰은 기록·제안까지만 한다. 스킬·Rules·Knowledge에 반영하는 것은 리뷰에서 사람이 승인한 것만 (Rules 6절).

Before the first tool call of any session — and before writing or proposing a plan, not merely before executing one — invoke the
task-observer skill AND execute its Session Start Protocol (storage check, frontmatter scan, review trigger). Loading the skill and
running the protocol are separate steps; a session that loads the file and stops has activated nothing. Any turn that will involve
a tool call counts; do not classify the session as "too simple" from its opening message.
After completing each task, list the observation records written this session in the same turn and report a one-line summary from
that listing (ids and titles, or "none logged and why") — never from memory of writing them.
