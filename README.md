# Agent config

My current `AGENTS.md` and collection of skills for coding agents.

## Purpose

Collaboration-first, not autonomy-first. The goal is to amplify my thinking, not replace it. I do the thinking about *what* to do, the agent accelerates the *how*.

## Install

Clone the repo, then symlink (or copy) into the coding agent's config directory:

```bash
git clone https://github.com/spieseba/agent-config.git

# Claude Code
ln -s /path/to/AGENTS.md ~/.claude/CLAUDE.md
ln -s /path/to/skills ~/.claude/skills
ln -s /path/to/claude/settings.json ~/.claude/settings.json
ln -s /path/to/claude/statusline-command.sh ~/.claude/statusline-command.sh

# Codex
ln -s /path/to/AGENTS.md ~/.codex/AGENTS.md
ln -s /path/to/skills ~/.codex/skills
ln -s /path/to/codex/config.toml ~/.codex/config.toml

# Antigravity CLI
ln -s /path/to/AGENTS.md ~/.gemini/GEMINI.md
ln -s /path/to/skills ~/.gemini/skills

# Mistral Vibe CLI
ln -s /path/to/AGENTS.md ~/.vibe/AGENTS.md
ln -s /path/to/skills ~/.vibe/skills
```

## `AGENTS.md`

My `AGENTS.md` is adapted from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) @ `2c60614`, itself derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on coding-agent pitfalls. The original materializes four principles — *Think Before Coding*, *Simplicity First*, *Surgical Changes*, *Goal-Driven Execution*. 

This version merges the middle two into a single *Right-Sized Changes* section and adds rules that force the agent to surface its choices: stated tradeoffs before non-trivial work, flagged corner-cuts, an explicit list of what it did *not* do, and unprompted suggestions for better approaches.

## Skills

- **`grill-me`** — Get extensively interviewed about a plan or design until every branch of the decision tree is resolved.
    - This skill is inspired by [mattpocock/skills](https://github.com/mattpocock/skills) and [obra/superpowers](https://github.com/obra/superpowers).
    - Key idea: force decisions to be surfaced before code is written.
    - Note: Grill isn't one-shot. When you've been grilled and you're now coding, you'll hit a fork that wasn't covered. Re-invoke.

- **`grill-with-docs`** — Grills your plan against the codebase's domain language, sharpening fuzzy terms and recording hard calls in `CONTEXT.md` and ADRs as you go.
    - Key idea: 
        - Build a *ubiquitous language* (from domain-driven design) shared by the code, the developers, and the domain experts who know the problem but not the implementation.
        - Once all three share that language, an expert can point at the code and the developer knows exactly what's meant.
    - Benefits: 
        - You and the agent converge on the same vocabulary, so it takes far fewer words (and tokens!) to communicate.
        - Easier-to-navigate code as agreed on language is also reflected in the code.

- **`handoff`** — Compact the current conversation into a handoff document for another agent.

- **`hand-to-vibe`** — Hand a task to the Mistral Vibe CLI for an independent, read-only crosscheck or a full-access implementation handoff.

- **`teach`** — Teaches you a new skill/concept over multiple sessions, using the cwd as a stateful teaching workspace.


## Claude Settings

`claude/statusline-command.sh` is my [Claude Code status line](https://docs.claude.com/en/docs/claude-code/statusline): 
- Line 1: `user@host`, cwd, and model.
- Line 2: Context usage plus 5h/7d rate-limit bars and session count.

Requires `jq`. `claude/settings.json` wires this up by pointing Claude Code at the synced statusline script.

## Codex Configuration

`codex/config.toml`:
- Configures `sandbox_mode = "danger-full-access"` to run codex without sandbox restrictions because I run agents in a [sandbox](https://github.com/spieseba/docker-sandbox).
- Codex TUI status line is configured with model, cwd, reasoning, approval mode, context usage, rate-limit, and context-window segments.

