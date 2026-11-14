#!/usr/bin/env bash
# Reports every name from CONTRACT.md that a consuming repo lacks, each once.
# Usage: check-contract.sh <repo> [batch-tickets] [roadmap-batch] [prototype-harness]
# Reads files only: whether the labels exist in the tracker is setup's check, and a
# "Human first:" line is required only while a group has an open decision.
set -u

repo="${1:?usage: check-contract.sh <repo> [skill...]}"
shift
[ -d "$repo" ] || { echo "no such repo: $repo" >&2; exit 2; }
skills="${*:-batch-tickets roadmap-batch prototype-harness}"
missing=0
roadmap=""
seen="|"

fail() {
  case "$seen" in *"|$1|"*) return ;; esac
  seen="$seen$1|"
  echo "MISSING  $1"
  missing=$((missing + 1))
}

need() {
  local file="$1" pattern="$2" label="$3"
  if [ ! -f "$repo/$file" ]; then
    fail "$file (the guide is absent)"
  elif ! grep -qE -- "$pattern" "$repo/$file"; then
    fail "$file: $label"
  fi
}

# need_in <file> <section heading> <pattern> <label>: the pattern inside one "## " section.
need_in() {
  local file="$1" heading="$2" pattern="$3" label="$4"
  [ -f "$repo/$file" ] || return 0
  awk -v h="## $heading" '$0 == h {on=1; next} /^## /{on=0} on' "$repo/$file" |
    grep -qE -- "$pattern" || fail "$file: $label"
}

# linked <file>: the agent entrypoint mentions the guide's path.
linked() {
  [ -f "$repo/$1" ] || return 0
  cat "$repo/AGENTS.md" "$repo/CLAUDE.md" 2>/dev/null | grep -qF -- "$1" ||
    fail "$1: a link from AGENTS.md or CLAUDE.md"
}

optional() {
  local file="$1" pattern="$2" label="$3"
  if [ -f "$repo/$file" ] && ! grep -qE -- "$pattern" "$repo/$file"; then
    echo "optional $file: $label"
  fi
}

# operation <file> <name>: a bullet starting with the bold name, outside ## Cloud sessions.
operation() {
  local file="$1" name="$2"
  if [ ! -f "$repo/$file" ]; then
    fail "$file (the guide is absent)"
  elif ! awk '/^## Cloud sessions$/{off=1; next} /^## /{off=0} !off' "$repo/$file" |
    grep -qE -- "^[[:space:]]*- \\*\\*$name\\*\\*"; then
    fail "$file: operation **$name** (a bullet starting with the name, outside ## Cloud sessions)"
  fi
}
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
        "Count open blockers" "Watch CI" "Merge a PR"; do
        operation "$tracker" "$name"
      done
      section "$tracker" "Branching"
      need_in "$tracker" "Branching" "^Branch name" "## Branching: a 'Branch name' paragraph"
      need_in "$tracker" "Branching" "^Commit subjects" "## Branching: a 'Commit subjects' paragraph"
      if [ -f "$repo/$tracker" ] &&
        [ "$(grep -E '^[[:space:]]*- \*\*Merge a PR\*\*' "$repo/$tracker" | head -1 | grep -o 'gh pr merge' | wc -l)" -gt 1 ]; then
        fail "$tracker: **Merge a PR** keeps one form (auto-merge or direct), not both"
      fi
      linked "$tracker"
      linked "$verification"
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
      need_in "$group" "Slice issue" "roadmap's group .* line \"" "## Slice issue: the criterion that quotes the roadmap line"
      linked "$group"
      if [ -f "$repo/$group" ]; then
        roadmap=$(awk '/^## Roadmap file$/{on=1; next} /^## /{on=0} on' "$repo/$group" |
          grep -oE '`[^`]+\.md`' | head -1 | tr -d '`')
      fi
      if [ -n "$roadmap" ]; then
        section "$roadmap" "How the roadmap is worked"
        section "$roadmap" "Parked"
        need_in "$roadmap" "How the roadmap is worked" "^\*\*Closing re-triage" "the **Closing re-triage** checklist"
        need_in "$roadmap" "How the roadmap is worked" "^(- \[ \]|[0-9]+\.) " "the **Closing re-triage** checklist items (checkboxes or a numbered list)"
        optional "$roadmap" "^### [0-9]+\. " "no numbered group (### <n>. <name>) left to batch"
        linked "$roadmap"
      elif [ -f "$repo/$group" ]; then
        fail "$group: a backticked roadmap path under ## Roadmap file"
      fi
      ;;
    prototype-harness)
      for name in "Install sites" "Query keys" "Screenshot run" "Lessons"; do
        section "$harness" "$name"
      done
      for row in "Prototype folder" "Root layout" "API client" "Router"; do
        need_in "$harness" "Install sites" "^\\| $row +\\|.*\`" "## Install sites: a '$row' row with a path"
      done
      need_in "$harness" "Install sites" "[Qq]uery client" "## Install sites: where the query client is"
      need_in "$harness" "Query keys" "^\\|.*\`" "## Query keys: a route-pattern row"
      for fact in "Dev origin" "Playwright resolves from" "Sign-in" "Output folder"; do
        need_in "$harness" "Screenshot run" "^- $fact:" "## Screenshot run: a '$fact:' bullet"
      done
      linked "$harness"
      ;;
    *)
      echo "unknown skill: $skill" >&2
      exit 2
      ;;
  esac
done

guides=""
case " $skills " in *" batch-tickets "*) guides="$guides $tracker $verification" ;; esac
case " $skills " in *" roadmap-batch "*) guides="$guides $tracker $labels $group ${roadmap:-}" ;; esac
case " $skills " in *" prototype-harness "*) guides="$guides $harness" ;; esac
for file in $(printf '%s\n' $guides | sort -u); do
  [ -n "$file" ] && [ -f "$repo/$file" ] || continue
  while IFS= read -r line; do
    echo "UNFILLED $file:$line"
    missing=$((missing + 1))
  done < <(grep -n -- '<FILL:' "$repo/$file" | cut -c1-90)
done

if [ "$missing" -eq 0 ]; then
  echo "contract satisfied for: $skills"
else
  echo "$missing required name(s) missing or unfilled for: $skills"
  exit 1
fi
