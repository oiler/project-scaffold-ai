#!/usr/bin/env bash
# Bootstrap a new project from this scaffold.
#
# Usage:
#   scripts/new-project.sh <target-dir> <project-name> [--owner "<name>"] [--no-git]
#
# Copies template/ to <target-dir>, replaces identity placeholders,
# initializes one git repository on branch master, and lists every
# placeholder that still needs a human decision. The target appears only
# after every step succeeds.
set -euo pipefail
# An exported CDPATH makes cd print paths and resolve names elsewhere.
unset CDPATH

usage() { sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//' >&2; exit 2; }

[[ $# -ge 2 ]] || usage
target=${1%/}; name=$2; shift 2
[[ -n $target ]] || usage
owner=""; has_owner=0; init_git=1
while [[ $# -gt 0 ]]; do
  case $1 in
    --owner) [[ $# -ge 2 ]] || usage; owner=$2; has_owner=1; shift 2 ;;
    --no-git) init_git=0; shift ;;
    *) usage ;;
  esac
done

template="$(cd "$(dirname -- "$0")/.." && pwd)/template"
parent=$(dirname -- "$target")
[[ $name =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "invalid project name: $name (use lowercase letters, digits, and hyphens)" >&2; exit 1; }
[[ $has_owner -eq 0 || ( -n $owner && $owner != *$'\n'* ) ]] || { echo "--owner must be non-empty and on one line" >&2; exit 1; }
[[ -d $template ]] || { echo "template not found: $template" >&2; exit 1; }
[[ ! -e $target && ! -L $target ]] || { echo "target already exists: $target" >&2; exit 1; }
[[ -d $parent ]] || { echo "parent directory does not exist: $parent" >&2; exit 1; }

# Title-case the slug for "[Project Name]": my-app -> My App
title=$(printf '%s\n' "$name" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
today=$(date +%Y-%m-%d)

# Build next to the target so the final mv is a rename on one filesystem.
tmp=$(mktemp -d "$parent/.new-project.XXXXXX")
trap 'rc=$?; rm -rf "$tmp"; [[ $rc -eq 0 ]] || echo "new-project: failed; nothing was created" >&2' EXIT
work="$tmp/project"
cp -R -- "$template" "$work"
find "$work" -name .DS_Store -delete

# Values travel through the environment and \Q..\E, so perl treats both
# sides as literal text: & | / \ and $ in a name come through unchanged.
replace() {
  local files
  files=$(grep -rlF --exclude-dir=.git -e "$1" "$work") || [[ $? -eq 1 ]]
  [[ -n $files ]] || return 0
  printf '%s\n' "$files" | while IFS= read -r f; do
    FROM=$1 TO=$2 perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' "$f"
  done
}

replace "[project-name]" "$name"
replace "[Project Name]" "$title"
replace "[YYYY-MM-DD]" "$today"
[[ $has_owner -eq 0 ]] || replace "[owner]" "$owner"

if [[ $init_git -eq 1 ]]; then
  git -C "$work" init -q -b master
  git -C "$work" add -A
  git -C "$work" commit -q -m "initialize $name from project scaffold"
fi

# A placeholder is a bracketed token outside fenced code, inline code,
# markdown links, task checkboxes, and Keep a Changelog version headings.
# The report is built before the move so a failure here creates nothing.
report=$(cd "$work" && find . -type f -not -path './.git/*' | sed 's|^\./||' | LC_ALL=C sort | while IFS= read -r f; do
  # Excluded spans are blanked to the same length rather than deleted, so a
  # placeholder that contains inline code is still printed in full.
  awk '
    function mask(s, re,    out, pad) {
      out = ""
      while (match(s, re)) {
        pad = sprintf("%" RLENGTH "s", "")
        out = out substr(s, 1, RSTART - 1) pad
        s = substr(s, RSTART + RLENGTH)
      }
      return out s
    }
    # A fence closes only on the same character, at least as long, with
    # nothing after it.
    match($0, /^[[:space:]]*(````*|~~~~*)/) {
      run = substr($0, RSTART, RLENGTH); sub(/^[[:space:]]*/, "", run)
      if (!fence) { fence = 1; fc = substr(run, 1, 1); fn = length(run); next }
      if (substr(run, 1, 1) == fc && length(run) >= fn && substr($0, RSTART + RLENGTH) ~ /^[[:space:]]*$/) { fence = 0; next }
    }
    fence { next }
    /^[[:space:]]*\[[^]]+\]:[[:space:]]*[^[:space:]]/ { next }
    {
      m = mask($0, "`[^`]*`")
      m = mask(m, "\\[[^]]*\\]\\([^)]*\\)")
      m = mask(m, "\\[[^]]*\\]\\[[^]]*\\]")
      m = mask(m, "^[[:space:]]*([-*+]|[0-9]+[.)])[[:space:]]+\\[[ xX]\\]")
      if (m ~ /^#+[[:space:]]/) m = mask(m, "\\[(Unreleased|[0-9]+\\.[0-9]+\\.[0-9]+[^]]*)\\]")
      off = 0
      while (match(m, /\[[^]]+\]/)) {
        print FILENAME ":" FNR ": " substr($0, off + RSTART, RLENGTH)
        off += RSTART + RLENGTH - 1
        m = substr(m, RSTART + RLENGTH)
      }
    }' "$f"
done)

[[ ! -e $target && ! -L $target ]] || { echo "target appeared during the run: $target" >&2; exit 1; }
mv -- "$work" "$target"

echo "Created $target"
echo
echo "Placeholders still requiring a human decision:"
printf '%s\n' "${report:-none}"
