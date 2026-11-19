#!/bin/sh
set -eu

REPO_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

usage() {
  cat <<EOF
Usage: $(basename -- "$0") [--all | --antigravity | --claude | --codex | --vibe]...

Symlinks AGENTS.md, skills, and statusline scripts, and copies mutable config
files (overwriting existing ones) into the selected agent config directories.

Options:
  --all           Install config for all supported agents
  --antigravity   Install Antigravity CLI config (~/.gemini)
  --claude        Install Claude Code config (~/.claude)
  --codex         Install Codex config (~/.codex)
  --vibe          Install Mistral Vibe CLI config (~/.vibe)
  -h, --help      Show this help
EOF
}

install_antigravity() {
  mkdir -p "$HOME/.gemini/antigravity-cli"
  ln -sfn "$REPO_DIR/AGENTS.md" "$HOME/.gemini/GEMINI.md"
  ln -sfn "$REPO_DIR/skills" "$HOME/.gemini/skills"
  cp "$REPO_DIR/antigravity/settings.json" "$HOME/.gemini/antigravity-cli/settings.json"
  ln -sfn "$REPO_DIR/antigravity/statusline.sh" "$HOME/.gemini/antigravity-cli/statusline.sh"
}

install_claude() {
  mkdir -p "$HOME/.claude"
  ln -sfn "$REPO_DIR/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  ln -sfn "$REPO_DIR/skills" "$HOME/.claude/skills"
  cp "$REPO_DIR/claude/settings.json" "$HOME/.claude/settings.json"
  ln -sfn "$REPO_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
}

install_codex() {
  mkdir -p "$HOME/.codex"
  ln -sfn "$REPO_DIR/AGENTS.md" "$HOME/.codex/AGENTS.md"
  ln -sfn "$REPO_DIR/skills" "$HOME/.codex/skills"
  cp "$REPO_DIR/codex/config.toml" "$HOME/.codex/config.toml"
}

install_vibe() {
  mkdir -p "$HOME/.vibe"
  ln -sfn "$REPO_DIR/AGENTS.md" "$HOME/.vibe/AGENTS.md"
  ln -sfn "$REPO_DIR/skills" "$HOME/.vibe/skills"
  cp "$REPO_DIR/vibe/config.toml" "$HOME/.vibe/config.toml"
}

if [ "$#" -eq 0 ]; then
  usage >&2
  exit 1
fi

do_antigravity=0
do_claude=0
do_codex=0
do_vibe=0

for arg in "$@"; do
  case "$arg" in
    --all)
      do_antigravity=1
      do_claude=1
      do_codex=1
      do_vibe=1
      ;;
    --antigravity) do_antigravity=1 ;;
    --claude)      do_claude=1 ;;
    --codex)       do_codex=1 ;;
    --vibe)        do_vibe=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ "$do_antigravity" -eq 1 ]; then install_antigravity; fi
if [ "$do_claude" -eq 1 ]; then install_claude; fi
if [ "$do_codex" -eq 1 ]; then install_codex; fi
if [ "$do_vibe" -eq 1 ]; then install_vibe; fi
