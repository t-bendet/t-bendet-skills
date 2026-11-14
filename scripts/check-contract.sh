#!/usr/bin/env bash
# Reports every name from CONTRACT.md that a consuming repo lacks.
# Usage: check-contract.sh <repo> [batch-tickets] [roadmap-batch] [prototype-harness]
set -u

repo="${1:?usage: check-contract.sh <repo> [skill...]}"
shift
skills="${*:-batch-tickets roadmap-batch prototype-harness}"
missing=0

need() {
  local file="$1" pattern="$2" label="$3"
  if [ ! -f "$repo/$file" ]; then
    echo "MISSING  $file (wanted: $label)"
    missing=$((missing + 1))
  elif ! grep -qE -- "$pattern" "$repo/$file"; then
    echo "MISSING  $file: $label"
    missing=$((missing + 1))
  fi
}

optional() {
  local file="$1" pattern="$2" label="$3"
  if [ -f "$repo/$file" ] && ! grep -qE -- "$pattern" "$repo/$file"; then
    echo "optional $file: $label"
  fi
}

operation() { need "$1" "\\*\\*$2\\*\\*" "operation **$2**"; }
section() { need "$1" "^## $2\$" "section ## $2"; }

tracker=docs/agents/issue-tracker.md
verification=docs/agents/verification.md
group=docs/agents/roadmap-group.md
labels=docs/agents/triage-labels.md
harness=docs/agents/prototype-harness.md

for skill in $skills; do
  case "$skill" in
    batch-tickets)
      for name in "Read an issue" "List issues" "Comment on an issue" \
        "List a parent's sub-issues" "List a ticket's blockers" \
        "Count open blockers" "Watch CI"; do
        operation "$tracker" "$name"
      done
      section "$tracker" "Branching"
      optional "$tracker" "^## Cloud sessions\$" "section ## Cloud sessions"
      section "$verification" "Local checks"
      section "$verification" "CI coverage"
      optional "$verification" "^## After a merge\$" "section ## After a merge"
      ;;
    roadmap-batch)
      for name in "Create an issue" "List issues" \
        "Make an issue a sub-issue of a parent" "Blocking"; do
        operation "$tracker" "$name"
      done
      need "$labels" "ready-for-agent" "role ready-for-agent"
      need "$labels" "ready-for-human" "role ready-for-human"
      for name in "Roadmap file" "Parent issue" "Slice issue" \
        "Closing re-triage issue" "Filing order"; do
        section "$group" "$name"
      done
      need "$group" "Merge policy: stop at PR open" "phrase 'Merge policy: stop at PR open'"
      roadmap=""
      if [ -f "$repo/$group" ]; then
        roadmap=$(awk '/^## Roadmap file$/{on=1; next} /^## /{on=0} on' "$repo/$group" |
          grep -oE '`[^`]+\.md`' | head -1 | tr -d '`')
      fi
      if [ -n "$roadmap" ]; then
        section "$roadmap" "How the roadmap is worked"
        section "$roadmap" "Parked"
        need "$roadmap" "Closing re-triage" "the Closing re-triage checklist"
      elif [ -f "$repo/$group" ]; then
        echo "MISSING  $group: a backticked roadmap path under ## Roadmap file"
        missing=$((missing + 1))
      fi
      ;;
    prototype-harness)
      for name in "Install sites" "Query keys" "Screenshot run" "Lessons"; do
        section "$harness" "$name"
      done
      ;;
    *)
      echo "unknown skill: $skill" >&2
      exit 2
      ;;
  esac
done

if [ "$missing" -eq 0 ]; then
  echo "contract satisfied for: $skills"
else
  echo "$missing required name(s) missing for: $skills"
  exit 1
fi
