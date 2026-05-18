# My `CLAUDE.md` and Claude skills

Personal collection of [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) skills and a `CLAUDE.md`, synced across machines via this repo.

## Why these skills

Collaboration-first, not autonomy-first. The goal is to amplify my thinking, not replace it — I do the thinking about *what* to do, the agent accelerates the *how*. `CLAUDE.md` provides always-on behavioral guardrails; the skills provide on-demand workflows for specific situations.

## Install

Clone the repo, then symlink (or copy) into your Claude Code config directory:

```bash
git clone <this-repo> ~/Projects/agent-config
ln -s ~/Projects/agent-config/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/Projects/agent-config/skills ~/.claude/skills
```

Symlinks are preferred so updates pulled into the repo are picked up immediately. Use `cp -r` instead if your setup requires real files.

## `CLAUDE.md`

Always-on behavioral guidelines applied to every session. Four principles: *Think Before Coding*, *Simplicity First*, *Surgical Changes*, *Goal-Driven Execution*. Copied verbatim from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) @ `2c60614`, itself derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

## Skills

- **`grill-me`** — Get relentlessly interviewed about a plan or design until every branch of the decision tree is resolved. This skill is inspired by [mattpocock/skills](https://github.com/mattpocock/skills) @ `b843cb5` and [obra/superpowers](https://github.com/obra/superpowers).


### Skill usage in practice

- `grill-me`
    - Example: `I want to migrate my previous analysis from Jupyter notebooks to a script-based pipeline. The notebooks live in analysis/notebooks/. /grill-me`
    - Key idea: force decisions to be surfaced before code is written.
    - Additional information:
        - Grill isn't one-shot. When you've been grilled and you're now coding, you'll hit a fork that wasn't covered. Re-invoke.
        - Grill is also good for designing experiments, not just code. Example: "I want to test whether method A vs B affects the outcome. /grill-me."

