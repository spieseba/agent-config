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
cp /path/to/claude/settings.json ~/.claude/settings.json
ln -s /path/to/claude/statusline-command.sh ~/.claude/statusline-command.sh

# Mistral Vibe CLI
ln -s /path/to/AGENTS.md ~/.vibe/AGENTS.md
ln -s /path/to/skills ~/.vibe/skills
cp /path/to/vibe/config.toml ~/.vibe/config.toml

# Antigravity CLI
ln -s /path/to/AGENTS.md ~/.gemini/GEMINI.md
ln -s /path/to/skills ~/.gemini/skills

# Codex
ln -s /path/to/AGENTS.md ~/.codex/AGENTS.md
ln -s /path/to/skills ~/.codex/skills
cp /path/to/codex/config.toml ~/.codex/config.toml
ln -s /path/to/codex/pets ~/.codex/pets

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

- **`teach`** — Teaches you a new skill/concept over multiple sessions, using the cwd as a stateful teaching workspace.


## Claude Settings

`claude/settings.json` configures Claude Code to use `claude/statusline-command.sh` as the status line.

`claude/statusline-command.sh` shows:
- `user@host`, current directory, and model.
- Context usage, 5h/7d rate-limit bars, and session count.

Requires `jq`.


## Codex config

`codex/config.toml` is intended for running Codex inside a Docker container. It:

- Sets `sandbox_mode = "danger-full-access"` Codex’s own documentation explicitly recommends this for containerized environments where the required Linux sandbox features aren’t available.
- Sets `approvals_reviewer = "auto_review"`.
- TUI status line with model, directory, approval, context, token, and rate-limit details.

See the official [Codex sandbox documentation](https://learn.chatgpt.com/codex/sandboxing)
for the sandbox modes and Linux prerequisites.


## Mistral Vibe config

`vibe/config.toml` selects `glm-5-2` and Vibe's built-in `auto-approve` agent by default.
Copying it replaces existing Vibe preferences; Vibe may rewrite it when settings change via `/config`.
