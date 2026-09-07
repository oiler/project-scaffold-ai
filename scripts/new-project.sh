#!/usr/bin/env bash
# Bootstrap a new project workspace from this scaffold.
#
# Usage:
#   scripts/new-project.sh <target-dir> <project-name> <organization> [--owner "<name>"] [--no-git]
#
# Copies project-name/ to <target-dir>, replaces identity placeholders,
# strips macOS metadata, initializes docs/ and code/ as independent git
# repositories on branch master, and lists every placeholder that still
# needs a human decision.
set -euo pipefail

usage() { sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

[[ $# -ge 3 ]] || usage
target=$1; name=$2; org=$3; shift 3
owner=""; init_git=1
while [[ $# -gt 0 ]]; do
  case $1 in
    --owner) owner=$2; shift 2 ;;
    --no-git) init_git=0; shift ;;
    *) usage ;;
  esac
done

scaffold="$(cd "$(dirname "$0")/.." && pwd)/project-name"
[[ -d $scaffold ]] || { echo "scaffold not found: $scaffold" >&2; exit 1; }
[[ ! -e $target ]] || { echo "target already exists: $target" >&2; exit 1; }

# Title-case the slug for "[Project Name]": my-app -> My App
title=$(echo "$name" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
today=$(date +%Y-%m-%d)

cp -R "$scaffold" "$target"
find "$target" -name .DS_Store -delete

replace() {  # replace <from> <to> across all files in target
  local from=$1 to=$2
  grep -rl --exclude-dir=.git -F "$from" "$target" | while read -r f; do
    sed -i '' "s|$(printf '%s' "$from" | sed 's/[][\.*^$|/]/\\&/g')|$to|g" "$f"
  done
}

replace "[organization/project-docs]" "$org/$name-docs"
replace "[organization/project-code]" "$org/$name-code"
replace "[organization]" "$org"
replace "[project-name]" "$name"
replace "[Project Name]" "$title"
replace "[YYYY-MM-DD]" "$today"
if [[ -n $owner ]]; then
  for p in "[owner]" "[product owner]" "[engineering owner]" "[design owner]" "[accessibility owner]" "[decision owner]"; do
    replace "$p" "$owner"
  done
fi

if [[ $init_git -eq 1 ]]; then
  for repo in docs code; do
    git -C "$target/$repo" init -q -b master
    git -C "$target/$repo" add -A
    git -C "$target/$repo" commit -q -m "initialize $name $repo repository from project scaffold"
  done
fi

echo "Created $target"
echo
echo "Placeholders still requiring a human decision (templates excluded):"
# Strip markdown links and checkboxes from each line first, then extract
# bracketed tokens. Template files keep their placeholders by design.
find "$target" -type f -not -path '*/.git/*' -not -path '*/templates/*' \
  | while read -r f; do awk '/^[[:space:]]*```/ {fence=!fence; next} !fence {gsub(/`[^`]*`/, ""); print FILENAME":"NR":"$0}' "$f"; done \
  | grep -E '\[[^]]+\]' \
  | grep -v 'ADR-NNN' \
  | sed -E 's/\[[^]]*\]\([^)]*\)//g; s/\[[ x]\]//g' \
  | awk -F: '{
      loc=$1":"$2; line=substr($0, length(loc)+2)
      while (match(line, /\[[^]]+\]/)) {
        tok=substr(line, RSTART, RLENGTH)
        if (tok !~ /^\[v?MAJOR\.MINOR(\.PATCH)?\]$/) print loc": "tok
        line=substr(line, RSTART+RLENGTH)
      }
    }' \
  | sed "s|^$target/||" \
  | sort -u || true
echo
echo "Next: follow 'Starting a project' in the scaffold README."
