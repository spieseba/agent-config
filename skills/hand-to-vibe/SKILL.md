---
name: hand-to-vibe
description: >-
  Hand a task to the Mistral Vibe CLI — a coding agent on a different model
  family — for an independent review or to hand off implementation work. On
  invocation the skill asks whether Vibe should run read-only (plan) or with
  full access (auto-approve).
user-invocable: true
argument-hint: "[plan | auto-approve] <task>"
---

# Delegate to Mistral Vibe

Hand a task to `vibe`, Mistral's CLI coding agent. It runs on a different model
family from the calling agent, which makes it useful both as an independent
crosscheck and as an extra pair of hands.

## Choose the mode
If the user named a mode, use it; otherwise ask and wait. The mode is the
`--agent` value — never grant more access than the user chose.

- **plan** — read-only. Vibe reads and searches but cannot run shell commands or
  edit files. A genuine read-only boundary.
- **auto-approve** — full access. Vibe can run commands and edit files. Use to
  delegate implementation, or for a review that must run code.

## Invoke
Run from the relevant working directory; only `--agent` changes between modes.
`--output streaming` emits NDJSON (one object per message) for a live play-by-play;
run it in the background to follow along. `PYTHONUNBUFFERED=1` is required — without
it `vibe` block-buffers a redirected stdout and the file stays empty until the end:

```bash
PYTHONUNBUFFERED=1 vibe --prompt "<explicit, self-contained task>" \
  --agent <plan|auto-approve> --output streaming --max-turns 25 --trust
```

`--max-turns` is only a loop circuit-breaker; raise it if a run is truncated.

## Follow the run — do not fire-and-forget
- Tell the user the output-file path up front so they can tail it.
- Follow the stream as it grows; surface meaningful progress (tools called, files
  read, intermediate conclusions), not just the final answer. Translate the NDJSON
  into readable progress — don't paste raw JSON. Line 1 is a large system-prompt
  object; skip it.
- Final answer = last `assistant` line with non-empty `content` and no `tool_calls`.
- When vibe finishes, report the result and reconcile it with your own view.

## Prompting Vibe
Vibe shares none of the calling agent's context and may be the less capable
model at long-horizon agentic work. State everything explicitly: the task,
where to look (exact files), what "correct" means, and what to report.

**When reviewing or crosschecking**, treat Vibe's output as an independent
witness, not an authority: enumerate agreements and disagreements, surface every
disagreement to the user unresolved rather than deferring or rationalising, and
name cross-model agreement as the signal it is.

**When delegating implementation**, plan it first. Decompose the work into the
smallest independently-verifiable steps, each specified completely (files,
expected behaviour, constraints, acceptance criteria), and hand them off one at
a time. After each, check `git diff` against the criteria before the next; if
Vibe wanders, revert and retry with a tighter, smaller step.

## Notes
- Capture stdout to a temp file so it can be followed live and read back in full
  after the run (needs `PYTHONUNBUFFERED=1` — see Invoke).
- `plan` is the only enforceable read-only guarantee — `auto-approve` can write
  through the shell regardless of tools. For "run but provably cannot write,"
  point `auto-approve` at a git worktree or read-only copy.
- If `vibe` is missing or unauthenticated the command errors; relay that to the
  user to fix (e.g. `vibe --setup`) rather than installing or authenticating it
  yourself.
