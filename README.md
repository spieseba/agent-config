# My `AGENTS.md` and skills

My current `AGENTS.md` and collection of skills for coding agents.

## Purpose

Collaboration-first, not autonomy-first. The goal is to amplify my thinking, not replace it. I do the thinking about *what* to do, the agent accelerates the *how*.

## Install

Clone the repo, then symlink (or copy) into the coding agent's config directory:

```bash
git clone https://github.com/spieseba/agent-config.git
cd agent-config

# Claude Code
ln -s /path/to/AGENTS.md ~/.claude/CLAUDE.md
ln -s /path/to/skills ~/.claude/skills

# Codex
ln -s /path/to/AGENTS.md ~/.codex/AGENTS.md
ln -s /path/to/skills ~/.codex/skills

# Antigravity CLI
ln -s /path/to/AGENTS.md ~/.gemini/GEMINI.md
ln -s /path/to/skills ~/.gemini/skills

# Mistral Vibe CLI
ln -s /path/to/AGENTS.md ~/.vibe/AGENTS.md
ln -s /path/to/skills ~/.vibe/skills
```

## `AGENTS.md`

My current `AGENTS.md` is copied verbatim from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) @ `2c60614`, which itself is derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on coding-agent pitfalls. It materializes the following four principles: *Think Before Coding*, *Simplicity First*, *Surgical Changes*, *Goal-Driven Execution*.

## Skills

- **`grill-me`** — Get extensively interviewed about a plan or design until every branch of the decision tree is resolved.
    - This skill is inspired by [mattpocock/skills](https://github.com/mattpocock/skills) @ `b843cb5` and [obra/superpowers](https://github.com/obra/superpowers).
    - Key idea: force decisions to be surfaced before code is written.
    - Note: Grill isn't one-shot. When you've been grilled and you're now coding, you'll hit a fork that wasn't covered. Re-invoke.

