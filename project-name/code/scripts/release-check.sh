#!/usr/bin/env bash
# Mechanical release gate. See docs/policies/RELEASE.md in the docs repository.
#
# Usage: scripts/release-check.sh MAJOR.MINOR.PATCH [--docs <path>]
#
# Run from the workspace root or from the code repository. Exits nonzero and
# prints every failing check. Judgment items are not checked here.
set -uo pipefail

[[ $# -ge 1 ]] || { sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
version=$1; shift
docs=""
while [[ $# -gt 0 ]]; do
  case $1 in --docs) docs=$2; shift 2 ;; *) echo "unknown argument: $1" >&2; exit 2 ;; esac
done

code="$(cd "$(dirname "$0")/.." && pwd)"
docs="${docs:-$code/../docs}"
docs="$(cd "$docs" 2>/dev/null && pwd)" || { echo "FAIL docs repository not found; pass --docs <path>"; exit 1; }
minor=${version%.*}
tag="v$version"
fail=0
fail() { echo "FAIL $*"; fail=1; }
ok()   { echo "ok   $*"; }

field() { # field <file> <key>  -> value with surrounding quotes stripped
  sed -nE "s/^[[:space:]]*$2:[[:space:]]*//p" "$1" | head -1 | sed -E 's/^"(.*)"$/\1/'
}
list() { # list <file> <key> -> IDs under a yaml list key
  sed -nE "/^[[:space:]]*$2:/,/^[[:space:]]*[a-z_]+:/p" "$1" | grep -oE '[A-Z]+-[0-9]+' || true
}
# Bracketed tokens, excluding markdown links, checkboxes, and YAML flow lists of IDs.
placeholders() { grep -nE '\[[^]]+\]' "$1" | grep -vE '\]\(|\[ \]|\[x\]|\[[A-Z]+-[0-9]+(, ?[A-Z]+-[0-9]+)*\]' || true; }

# 1. Code release manifest
manifest="$code/release/manifest.yaml"
if [[ -f $manifest ]]; then
  ok "manifest present"
  left=$(placeholders "$manifest")
  [[ -z $left ]] && ok "manifest has no placeholders" || fail "manifest has placeholders:"$'\n'"$left"
  mv=$(field "$manifest" version)
  [[ $mv == "$version" ]] && ok "manifest version $mv" || fail "manifest version '$mv' != $version"
  mt=$(field "$manifest" tag)
  [[ $mt == "$tag" ]] && ok "manifest tag $mt" || fail "manifest tag '$mt' != $tag"
  baseline=$(field "$manifest" baseline_commit)
  if git -C "$docs" cat-file -e "$baseline^{commit}" 2>/dev/null; then
    ok "docs baseline commit exists"
  else
    fail "docs baseline commit '$baseline' not found in docs repository"
  fi
  specs=$(list "$manifest" implemented_specs)
  [[ -n $specs ]] || fail "manifest lists no implemented_specs"
else
  fail "missing $manifest (copy manifest.example.yaml)"
  specs=""
fi

# 2. Implemented specs accepted
for id in $specs; do
  f=$(ls "$docs/versions/$minor/specs/$id"*.md 2>/dev/null | head -1)
  if [[ -z $f ]]; then fail "$id: no file under versions/$minor/specs/"; continue; fi
  st=$(field "$f" status); ap=$(field "$f" approved_at)
  [[ $st == accepted ]] && ok "$id accepted" || fail "$id status is '$st', not accepted"
  [[ -n $ap && $ap != null ]] || fail "$id has no approved_at"
  if "$code/scripts/spec-check.sh" "$id" --docs "$docs" >/dev/null 2>&1; then
    ok "$id passes spec-check"
  else
    fail "$id fails spec-check (run scripts/spec-check.sh $id for details)"
  fi
done

# 3. Acceptance record for this candidate
head_sha=$(git -C "$code" rev-parse HEAD)
acc=$(grep -lE "^candidate_tag:[[:space:]]*\"?$tag\"?" "$docs/versions/$minor/acceptance/"ACCEPT-*.md 2>/dev/null | head -1)
if [[ -n $acc ]]; then
  ok "acceptance record $(basename "$acc")"
  by=$(field "$acc" accepted_by); cc=$(field "$acc" candidate_commit)
  [[ -n $by && $by != null ]] && ok "accepted_by $by" || fail "acceptance record has no accepted_by"
  [[ $cc == "$head_sha" ]] && ok "candidate_commit is HEAD" || fail "candidate_commit '$cc' != code HEAD $head_sha"
  grep -qE '^Result: `accepted`' "$acc" && ok "acceptance result accepted" || fail "acceptance Result is not \`accepted\`"
else
  fail "no acceptance record with candidate_tag $tag under versions/$minor/acceptance/"
fi

# 4. Docs release record
rel="$docs/versions/$minor/releases/$version.yaml"
if [[ -f $rel ]]; then
  ok "release record present"
  left=$(placeholders "$rel")
  [[ -z $left ]] && ok "release record has no placeholders" || fail "release record has placeholders:"$'\n'"$left"
  rt=$(field "$rel" tag); rc=$(field "$rel" commit)
  [[ $rt == "$tag" ]] || fail "release record tag '$rt' != $tag"
  [[ $rc == "$head_sha" ]] || fail "release record commit '$rc' != code HEAD $head_sha"
  [[ -n $(list "$rel" acceptance_records) ]] || fail "release record lists no acceptance_records"
else
  fail "missing $rel (copy templates/release.yaml)"
fi

# 5. Unreleased changelog sections empty
unreleased_empty() {
  sed -n '/^## Unreleased/,/^## /p' "$1" | sed '1d;$d' | grep -vE '^(###|[[:space:]]*$)' | grep -q . && return 1 || return 0
}
for f in "$code/CHANGELOG.md" "$docs/versions/$minor/CHANGELOG.md"; do
  [[ -f $f ]] || { fail "missing $f"; continue; }
  unreleased_empty "$f" && ok "Unreleased empty in $(basename "$(dirname "$f")")/$(basename "$f")" || fail "Unreleased section not rolled in $f"
done

# 6. STATUS current
status="$docs/STATUS.md"
as_of=$(field "$status" as_of)
if [[ $as_of =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then ok "STATUS as_of $as_of"; else fail "STATUS.md as_of is '$as_of'"; fi
[[ $(field "$status" active_version) == "$minor" ]] || fail "STATUS.md active_version is not $minor"

# 7. Clean trees
for r in "$code" "$docs"; do
  [[ -z $(git -C "$r" status --porcelain) ]] && ok "clean tree $(basename "$r")" || fail "uncommitted changes in $r"
done

# 8. Tag not already present
git -C "$code" rev-parse -q --verify "refs/tags/$tag" >/dev/null && fail "tag $tag already exists" || ok "tag $tag not yet created"

echo
if [[ $fail -eq 0 ]]; then echo "READY to tag $tag"; else echo "NOT READY"; fi
exit $fail
