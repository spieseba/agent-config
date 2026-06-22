---
name: delegate-to-vibe
description: >-
  Delegate a task to the Mistral Vibe CLI — a coding agent on a different model
  family — for an independent review or to hand off implementation work. On
  invocation the skill asks whether Vibe should run read-only (plan) or with
  full access (auto-approve). Call-only.
disable-model-invocation: true
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
Run from the relevant working directory; only `--agent` changes between modes:

```bash
vibe --prompt "<explicit, self-contained task>" \
  --agent <plan|auto-approve> --output text --max-turns 25 --trust
```

`--max-turns` is only a loop circuit-breaker; raise it if a run is truncated.

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
- Capture stdout; for large output, redirect to a temp file and read back only
  the final answer.
- `plan` is the only enforceable read-only guarantee — `auto-approve` can write
  through the shell regardless of tools. For "run but provably cannot write,"
  point `auto-approve` at a git worktree or read-only copy.
- If `vibe` is missing or unauthenticated the command errors; relay that to the
  user to fix (e.g. `vibe --setup`) rather than installing or authenticating it
  yourself.
