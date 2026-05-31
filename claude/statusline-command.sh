#!/bin/sh
# Claude Code status line. Reads session JSON on stdin, prints two lines.
# Requires: jq.
input=$(cat)

user=$(whoami)
host=$(hostname -s)

# Single jq pass emits exactly one value per line, in a fixed order, so the
# reads below stay aligned. Paths match the documented statusline schema.
# pct() floors percentages to whole numbers (bars are integer-width) and yields
# "" when the field is absent — rate_limits only appears for Pro/Max sessions
# after the first response, and context_window may be null early on.
{
  IFS= read -r cwd
  IFS= read -r model
  IFS= read -r ctx_pct
  IFS= read -r five_pct
  IFS= read -r five_reset
  IFS= read -r week_pct
  IFS= read -r week_reset
} <<EOF
$(printf '%s' "$input" | jq -r '
  def pct(f): (f | if . == null then "" else floor end);
  .cwd // "",
  .model.display_name // "",
  pct(.context_window.used_percentage),
  pct(.rate_limits.five_hour.used_percentage),
  .rate_limits.five_hour.resets_at // "",
  pct(.rate_limits.seven_day.used_percentage),
  .rate_limits.seven_day.resets_at // ""
')
EOF

# Shorten home directory to ~ (POSIX, no sed)
case "$cwd" in
  "$HOME"*) short_cwd="~${cwd#$HOME}" ;;
  *)        short_cwd="$cwd" ;;
esac

BAR_WIDTH=10
# Partial-block bar: 8 sub-cell levels per char (Unicode eighth blocks cap here).
# Total resolution is BAR_WIDTH * 8 distinct levels — here 80, ~1.25% per step.
# eighths = how many 1/8-cells are filled; render full blocks, one partial block
# for the remainder, then light-shade padding.
make_bar() {
  pct="$1"
  eighths=$((pct * BAR_WIDTH * 8 / 100))
  full=$((eighths / 8))
  rem=$((eighths % 8))
  i=0
  bar=""
  while [ $i -lt $full ]; do bar="${bar}█"; i=$((i + 1)); done
  if [ $full -lt $BAR_WIDTH ] && [ $rem -ne 0 ]; then
    case $rem in
      1) bar="${bar}▏" ;; 2) bar="${bar}▎" ;; 3) bar="${bar}▍" ;;
      4) bar="${bar}▌" ;; 5) bar="${bar}▋" ;; 6) bar="${bar}▊" ;; 7) bar="${bar}▉" ;;
    esac
    i=$((i + 1))
  fi
  while [ $i -lt $BAR_WIDTH ]; do bar="${bar}░"; i=$((i + 1)); done
  printf "%s" "$bar"
}

# Bold/dim ANSI
bold="\033[1m"
dim="\033[2m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
cyan="\033[36m"
reset="\033[0m"

sessions=$(pgrep -xc claude 2>/dev/null)
[ -z "$sessions" ] && sessions=0

line1="${green}${user}@${host}${reset}:${blue}${short_cwd}${reset}  ${dim}│${reset}  ${bold}${model}${reset}"

now=$(date +%s)

# Format seconds until reset as compact duration: "2h13m", "45m", "<1m".
fmt_eta() {
  secs="$1"
  [ -z "$secs" ] && return
  delta=$((secs - now))
  [ "$delta" -le 0 ] && { printf "now"; return; }
  d=$((delta / 86400))
  h=$(((delta % 86400) / 3600))
  m=$(((delta % 3600) / 60))
  if [ "$d" -gt 0 ]; then
    printf "%dd%dh" "$d" "$h"
  elif [ "$h" -gt 0 ]; then
    printf "%dh%02dm" "$h" "$m"
  elif [ "$m" -gt 0 ]; then
    printf "%dm" "$m"
  else
    printf "<1m"
  fi
}

line2=""
sep="  ${dim}│${reset}  "
add_segment() {
  label="$1"
  pct="$2"
  reset_at="$3"
  [ -z "$pct" ] && return
  bar=$(make_bar "$pct")
  eta=$(fmt_eta "$reset_at")
  if [ "$pct" -ge 80 ]; then col="$red"
  elif [ "$pct" -ge 50 ]; then col="$yellow"
  else col="$cyan"; fi
  if [ -n "$eta" ]; then
    seg=$(printf "${dim}%s${reset} ${col}%s${reset} ${dim}%s%% ↻ %s${reset}" "$label" "$bar" "$pct" "$eta")
  else
    seg=$(printf "${dim}%s${reset} ${col}%s${reset} ${dim}%s%%${reset}" "$label" "$bar" "$pct")
  fi
  if [ -z "$line2" ]; then
    line2="$seg"
  else
    line2="${line2}${sep}${seg}"
  fi
}

add_segment "ctx" "$ctx_pct"  ""
add_segment "5h"  "$five_pct" "$five_reset"
add_segment "7d"  "$week_pct" "$week_reset"

sessions_seg=$(printf "${cyan}⏵ %s${reset} ${dim}sessions${reset}" "$sessions")
if [ -z "$line2" ]; then
  line2="$sessions_seg"
else
  line2="${line2}${sep}${sessions_seg}"
fi

if [ -n "$line2" ]; then
  printf "%b\n%b" "$line1" "$line2"
else
  printf "%b" "$line1"
fi
