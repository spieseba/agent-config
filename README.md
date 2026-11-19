# Agent config

My current `AGENTS.md` and collection of skills for coding agents.

## Purpose

Collaboration-first, not autonomy-first. The goal is to amplify my thinking, not replace it. I do the thinking about *what* to do, the agent accelerates the *how*.

## Install

Clone the repo, then symlink (or copy) into the coding agent's config directory:

```bash
git clone https://github.com/spieseba/agent-config.git

# Antigravity CLI
ln -s /path/to/AGENTS.md ~/.gemini/GEMINI.md
ln -s /path/to/skills ~/.gemini/skills
cp /path/to/antigravity/settings.json ~/.gemini/antigravity-cli/settings.json
ln -s /path/to/antigravity/statusline.sh ~/.gemini/antigravity-cli/statusline.sh

# Claude Code
ln -s /path/to/AGENTS.md ~/.claude/CLAUDE.md
ln -s /path/to/skills ~/.claude/skills
cp /path/to/claude/settings.json ~/.claude/settings.json
ln -s /path/to/claude/statusline-command.sh ~/.claude/statusline-command.sh

# Codex
ln -s /path/to/AGENTS.md ~/.codex/AGENTS.md
ln -s /path/to/skills ~/.codex/skills
cp /path/to/codex/config.toml ~/.codex/config.toml

# Mistral Vibe CLI
ln -s /path/to/AGENTS.md ~/.vibe/AGENTS.md
ln -s /path/to/skills ~/.vibe/skills
cp /path/to/vibe/config.toml ~/.vibe/config.toml
```

## `AGENTS.md`

My `AGENTS.md` is adapted from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) @ `2c60614`, itself derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on coding-agent pitfalls. The original materializes four principles — *Think Before Coding*, *Simplicity First*, *Surgical Changes*, *Goal-Driven Execution*.

This version merges the middle two into a single *Right-Sized Changes* section and adds rules that force the agent to surface its choices: stated tradeoffs before non-trivial work, flagged corner-cuts, an explicit list of what it did *not* do, and unprompted suggestions for better approaches.

## Skills

- **`grill-me`**: Get extensively interviewed about a plan or design until every branch of the decision tree is resolved.
  - This skill is inspired by [mattpocock/skills](https://github.com/mattpocock/skills) and [obra/superpowers](https://github.com/obra/superpowers).
  - Key idea: force decisions to be surfaced before code is written.
- **`grill-with-docs`**: Grills your plan against the codebase's domain language, sharpening fuzzy terms and recording hard calls in `CONTEXT.md` and ADRs as you go.
  - Key idea:
    - Extension of `grill-me`: build *ubiquitous language* (from domain-driven design) shared by the code, the developers, and the domain experts who know the problem but not the implementation.
    - Once all three share that language, an expert can point at the code and the developer knows exactly what's meant.
- **`handoff`**: Compact the current conversation into a handoff document for another agent.
- **`teach`**: Teaches you a new skill/concept over multiple sessions, using the cwd as a stateful teaching workspace.
- **`ponytail`**: Lazy senior dev mode. Copied verbatim from [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail).

## Antigravity CLI

`antigravity/settings.json` configures Antigravity CLI (`agy`) to use `antigravity/statusline.sh` as the status line.
Copying it replaces existing `~/.gemini/antigravity-cli/settings.json` preferences; merge the `statusLine` block instead if you already have settings there.

`antigravity/statusline.sh` shows:

- `user@host`, current directory, and model.
- Context usage (with token count), remaining quota bars with reset ETA for the active model family, and session count.

Requires `jq`.

## Claude Code

`claude/settings.json` configures Claude Code to use `claude/statusline-command.sh` as the status line.
Copying it replaces existing `~/.claude/settings.json` preferences; merge the `statusLine` block instead if you already have settings there.

`claude/statusline-command.sh` shows:

- `user@host`, current directory, and model.
- Context usage (with token count), 5h/7d rate-limit bars with reset ETA, and session count.

Requires `jq`.

## Codex

`codex/config.toml` is intended for running Codex inside a Docker container.
Copying it replaces existing `~/.codex/config.toml` preferences. It sets:

- `sandbox_mode = "danger-full-access"` (recommended by Codex's docs for containerized environments without Linux sandbox prerequisites).
- `approvals_reviewer = "auto_review"`.
- TUI status line with model, directory, approval, context, token, and rate-limit details.

See the official [Codex sandbox documentation](https://learn.chatgpt.com/codex/sandboxing) for sandbox modes and Linux prerequisites.

## Mistral Vibe CLI

`vibe/config.toml` selects Vibe's built-in `auto-approve` agent by default.
Copying it replaces existing `~/.vibe/config.toml` preferences; Vibe may rewrite it when settings change via `/config`.
