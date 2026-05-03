# My `CLAUDE.md` and Claude skills

Personal collection of [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) skills and a `CLAUDE.md`, synced across machines via this repo.

## Why these skills

Collaboration-first, not autonomy-first. The goal is to amplify my thinking, not replace it — I do the thinking about *what* to do, the agent accelerates the *how*. `CLAUDE.md` provides always-on behavioral guardrails; the skills provide on-demand workflows for specific situations (planning, debugging, zooming out).

## Acknowledgements

- `CLAUDE.md` is copied from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills), itself derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.
- Several skills are derived from [mattpocock/skills](https://github.com/mattpocock/skills) — copied verbatim or adapted, as noted below.

## Install

Clone the repo, then symlink (or copy) into your Claude Code config directory:

```bash
git clone <this-repo> ~/code/claude-config
ln -s ~/code/claude-config/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/code/claude-config/skills ~/.claude/skills
```

Symlinks are preferred so updates pulled into the repo are picked up immediately. Use `cp -r` instead if your setup requires real files.

## `CLAUDE.md`

Always-on behavioral guidelines applied to every session. Four principles: *Think Before Coding*, *Simplicity First*, *Surgical Changes*, *Goal-Driven Execution*. Copied verbatim from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) @ `2c60614` on 2026-05-03.

## Skills

The following skills are copied or adapted from [mattpocock/skills](https://github.com/mattpocock/skills) @ `b843cb5` on 2026-04-30. Adaptations, where present, are noted on the skill.

- **`caveman`** — Ultra-compressed communication mode. Cuts token usage ~75% by dropping filler while keeping full technical accuracy.
- **`grill-me`** — Get relentlessly interviewed about a plan or design until every branch of the decision tree is resolved.
- **`grill-with-docs`** — Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates `CONTEXT.md` and `docs/adr/` inline.
- **`write-a-skill`** — Create new skills with proper structure, progressive disclosure, and bundled resources.
- **`zoom-out`** — Tell the agent to zoom out and give broader context or a higher-level perspective on an unfamiliar section of code.

### To be adapted

- **`diagnose`** — Disciplined diagnosis loop for hard bugs and performance regressions: reproduce → minimise → hypothesise → instrument → fix → regression-test. *TODO: rewrite Phase 1 example list for numerical/HPC work (synthetic-truth tests, differential loops, saved-array replay, bisection over data versions).*
- **`improve-codebase-architecture`** — Find deepening opportunities in a codebase, informed by `CONTEXT.md` and `docs/adr/`. *TODO: reframe around analysis-code anti-patterns (implicit array-shape contracts, missing units, duplicated estimators across subdirs, hardcoded constants).*
- **`tdd`** — Test-driven development with a red-green-refactor loop. *TODO: stash; likely merge with a future `numerical-correctness` skill focused on synthetic-truth tests for numerical functions.*

### Skill usage in practice

- `grill-me`
    - One-line behavioral prompt: "ask me hard questions one at a time, recommend an answer for each, until we've walked the whole decision tree."
    - Example: `I want to migrate my previous correlator analysis from Jupyter notebooks to a script-based pipeline. The notebooks live in analysis/notebooks/. /grill-me`
    - Key idea: force decisions to be surfaced before code is written.
    - Practical tips:
        - Explore the codebase first, then grill.
        - Grill isn't one-shot. When you've been grilled and you're now coding, you'll hit a fork that wasn't covered. Re-invoke.
        - Grill is also good for designing experiments, not just code. Example: "I want to test whether method A vs B affects the extracted mass. /grill-me."
- `grill-with-docs`
    - While `grill-me` is conversational, `grill-with-docs` is `grill-me` plus two persistent artifacts:
        - `CONTEXT.md`: glossary of domain-specific language.
        - `docs/adr/`: architectural/methodological decision log. Each session feeds the next because artifacts persist.
    - Compounding value exists in future sessions as the agent reads `CONTEXT.md` and ADRs. Code is written using your vocabulary, and the agent surfaces ambiguity — including contradictions between current statements and what's already in `CONTEXT.md` or the code.
    - Note: don't put implementation details in `CONTEXT.md` — it's a glossary of domain terms, not a tech overview.
- `write-a-skill`
    - Read/remember sub-files of the skill to remember how skills work.

## Personal skills

*Skills authored from scratch will go here once written.*

## Updating from upstream

When pulling in changes from a source repo:

1. Diff the upstream skill against the local copy to see what changed.
2. For unmodified skills, copy the new version over and update the commit hash and date in the relevant section above.
3. For adapted skills, review upstream changes manually — decide which to merge into the local adaptation.
4. Bump the hash and date even when no change is needed for the session, so "as of" stays accurate.
