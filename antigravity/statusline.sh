#!/bin/sh
# Antigravity CLI status line. Reads session JSON on stdin, prints two lines.
# Requires: jq.
input=$(cat)

user=$(whoami)
host=$(hostname -s)

# Single jq pass emits 4 fixed lines followed by 0..N pipe-separated quota
# buckets (key|rem_pct|reset_in_seconds). Paths match the Antigravity CLI
# statusLine JSON schema.
{
  IFS= read -r cwd
  IFS= read -r model
  IFS= read -r ctx_pct
  IFS= read -r ctx_tokens
  quota_lines=$(cat)
} <<EOF
$(printf '%s' "$input" | jq -r '
  def clamp_pct: if . < 0 then 0 elif . > 100 then 100 else . end;
  def pct(f): (f | if . == null then "" else floor | clamp_pct end);
  def rem_pct(r): ((r * 100) | round | clamp_pct);
  def reset_secs:
    if .reset_in_seconds != null then (.reset_in_seconds | floor)
    elif .reset_time != null then (try ((.reset_time | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) - now | floor) catch "")
    else "" end;
  def short_label:
    if   . == "gemini-5h"               then "5h"
    elif . == "gemini-weekly"           then "7d"
    elif . == "gemini-argon-wtu-weekly" then "argon 7d"
    elif . == "3p-5h"                   then "3p 5h"
    elif . == "3p-weekly"               then "3p 7d"
    else
      sub("^gemini-"; "")
      | sub("-wtu-weekly$"; " 7d")
      | sub("-weekly$"; " 7d")
      | sub("-5h$"; " 5h")
    end;
  def filter_buckets($m):
    . as $all
    | if ($m | test("gemini")) then
        ($all | map(select(.key | test("^gemini")))) as $gem
        | if ($gem | length) == 0 then $all
          elif ($m | test("argon")) then $gem
          else
            ($gem | map(select(.key | test("argon") | not))) as $non_argon
            | if ($non_argon | length) > 0 then $non_argon else $gem end
          end
      elif ($m | length) > 0 then
        ($all | map(select(.key | test("^3p")))) as $tp
        | if ($tp | length) > 0 then $tp else $all end
      else $all
      end;
  (((.model.id // "") + " " + (.model.display_name // "")) | ascii_downcase | gsub("^\\s+|\\s+$"; "")) as $m |
  (.workspace.current_dir // .cwd // ""),
  (.model.display_name // .model.id // ""),
  pct(.context_window.used_percentage),
  (.context_window.total_input_tokens // ""),
  ((.quota // {})
    | to_entries
    | map(select((.value.disabled // false) != true and .value.remaining_fraction != null))
    | filter_buckets($m)
    | sort_by([
        (if (.key | test("5h")) then 0 elif (.key | test("weekly|7d")) then 1 else 2 end),
        (if (.key | test("wtu")) then 1 else 0 end),
        .key
      ])
    | .[]
    | "\(.key | short_label)|\(rem_pct(.value.remaining_fraction))|\(.value | reset_secs)")
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

sessions=$(pgrep -xc agy 2>/dev/null)
[ -z "$sessions" ] && sessions=0

line1="${green}${user}@${host}${reset}:${blue}${short_cwd}${reset}  ${dim}│${reset}  ${bold}${model}${reset}"

# Format seconds until reset as compact duration: "2d5h", "2h13m", "45m", "<1m".
fmt_eta() {
  delta="$1"
  [ -z "$delta" ] && return
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

# Format a token count compactly: 1200000 -> "1.2M", 90234 -> "90.2k", 512 -> "512".
fmt_tokens() {
  t="$1"
  [ -z "$t" ] && return
  if [ "$t" -ge 1000000 ]; then
    printf "%d.%dM" $((t / 1000000)) $(((t % 1000000) / 100000))
  elif [ "$t" -ge 1000 ]; then
    printf "%d.%dk" $((t / 1000)) $(((t % 1000) / 100))
  else
    printf "%d" "$t"
  fi
}

line2=""
sep="  ${dim}│${reset}  "
add_segment() {
  label="$1"
  pct="$2"
  eta_secs="$3"
  extra="$4"
  kind="$5"
  [ -z "$pct" ] && return
  bar=$(make_bar "$pct")
  eta=$(fmt_eta "$eta_secs")
  if [ "$kind" = "rem" ]; then
    if [ "$pct" -le 20 ]; then col="$red"
    elif [ "$pct" -le 50 ]; then col="$yellow"
    else col="$cyan"; fi
  else
    if [ "$pct" -ge 80 ]; then col="$red"
    elif [ "$pct" -ge 50 ]; then col="$yellow"
    else col="$cyan"; fi
  fi
  if [ -n "$eta" ]; then
    seg=$(printf "${dim}%s${reset} ${col}%s${reset} ${dim}%s%% ↻ %s${reset}" "$label" "$bar" "$pct" "$eta")
  else
    seg=$(printf "${dim}%s${reset} ${col}%s${reset} ${dim}%s%%${reset}" "$label" "$bar" "$pct")
  fi
  [ -n "$extra" ] && seg="${seg}$(printf " ${dim}· %s${reset}" "$extra")"
  if [ -z "$line2" ]; then
    line2="$seg"
  else
    line2="${line2}${sep}${seg}"
  fi
}

add_segment "ctx" "$ctx_pct" "" "$(fmt_tokens "$ctx_tokens")" "used"

if [ -n "$quota_lines" ]; then
  while IFS='|' read -r q_key q_pct q_reset; do
    [ -z "$q_key" ] && continue
    add_segment "$q_key" "$q_pct" "$q_reset" "" "rem"
  done <<EOF
$quota_lines
EOF
fi

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
