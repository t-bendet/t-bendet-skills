# Guide contract

The skills in this repo carry process; the repo that uses them carries its own facts in **guides**.
A skill cites a guide by its path and a section or operation by its exact name, so these names are
the interface: rename one in a guide and the skill that cites it stops finding it.

`setup-t-bendet-skills` scaffolds the guides a repo lacks from the templates in
[its folder](skills/setup-t-bendet-skills/). `scripts/check-contract.sh <repo>` reports every
required name a repo is missing and every `<FILL: ...>` marker a template left unfilled.

## Guides

All paths are relative to the consuming repo's root.

| Guide                              | Scaffolded by                        | Read by                      |
| ---------------------------------- | ------------------------------------ | ---------------------------- |
| `docs/agents/issue-tracker.md`     | `mattpocock-skills` setup, then ours | batch-tickets, roadmap-batch |
| `docs/agents/triage-labels.md`     | `mattpocock-skills` setup            | roadmap-batch                |
| `docs/agents/verification.md`      | `setup-t-bendet-skills`              | batch-tickets                |
| `docs/agents/roadmap-group.md`     | `setup-t-bendet-skills`              | roadmap-batch, batch-tickets |
| the roadmap file                   | `setup-t-bendet-skills`              | roadmap-batch                |
| `docs/agents/prototype-harness.md` | `setup-t-bendet-skills`              | prototype-harness            |

A repo needs only the guides of the skills it uses: `prototype-harness` needs the last row alone;
`batch-tickets` without roadmap groups needs the issue-tracker and verification guides.

## Required names

An operation is a bullet that starts with its bold name (`- **Read an issue**: ...`); a mention
in a sentence, or a bullet under `## Cloud sessions`, does not count. Sections are headings.

### `docs/agents/issue-tracker.md`

Operations:

- **Create an issue**, **Read an issue**, **List issues**, **Comment on an issue**
- **Make an issue a sub-issue of a parent**, **List a parent's sub-issues**
- **Blocking**, **List a ticket's blockers**, **Count open blockers**
- **Watch CI**
- **Merge a PR**: either an auto-merge form, issued before the checks finish, or a direct form,
  issued only once they are green.

Sections:

- `## Branching`, the guide's last section: the base branch, a `Branch name:` paragraph, a
  `Commit subjects` paragraph, and the keyword that closes an issue from a PR. All four are the
  repo's own; the skills assume no form.
- `## Cloud sessions` (optional): substitutes for operations that fail in a cloud session, each
  under the operation's own name.

### `docs/agents/triage-labels.md`

The label strings for the `ready-for-agent` and `ready-for-human` roles. A repo with type labels
lists them here too, one of which marks a feature. Every label named exists in the tracker.

### `docs/agents/verification.md`

- `## Local checks`: the commands, and which apply to which kind of change.
- `## CI coverage`: the **required CI jobs** (those a PR must pass before **Merge a PR**, whether
  branch protection enforces them or only the guide does), what local checks leave uncovered, and
  whether a push to the base branch runs CI.
- `## After a merge` (optional): one check that the merged change is live, such as a health URL.

### `docs/agents/roadmap-group.md`

- `## Roadmap file`: the path of the roadmap.
- `## Parent issue`, `## Slice issue`, `## Closing re-triage issue`: the issue templates.
- `## Filing order`

Two phrases are fixed, because `batch-tickets` matches them literally: a slice's last acceptance
criterion **quotes the roadmap line** its PR removes, and a ticket to be reviewed by hand carries
`Merge policy: stop at PR open`.

### The roadmap file

- `## How the roadmap is worked`, naming for each kind of open decision the skill that settles it,
  and holding the **Closing re-triage** checklist.
- Numbered groups, lowest first. A group with an open decision carries a line starting
  `Human first:`; the line is removed or marked resolved when the decision lands.
- `## Parked`: items no batch may take.

### `docs/agents/prototype-harness.md`

- `## Install sites`: the prototype folder, and the layout, API-client, router and query-client
  files the harness touches.
- `## Query keys`: the route-pattern to query-key mapping for cold-cache comparisons.
- `## Screenshot run`: the dev origin, where Playwright resolves from, the sign-in request, the
  output folder. A repo without Playwright or a sign-in says so, and what a prototype branch adds.
- `## Lessons`: what earlier prototypes in this repo taught; empty until the first one closes.

## The entrypoint

The repo's agent entrypoint (`AGENTS.md`, or `CLAUDE.md` where that is the only one) links every
guide above that the repo has. A skill hands an implementer the entrypoint and the task guides it
routes to; beyond those links, their shape is the repo's own.

`mattpocock-skills` is required: `batch-tickets` uses its `pr` skill, `roadmap-batch` reads its
`to-spec` and `to-tickets` templates, and its setup skill scaffolds the first two guides above.
