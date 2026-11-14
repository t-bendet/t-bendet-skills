---
name: setup-t-bendet-skills
description: "Scaffold the guides batch-tickets, roadmap-batch and prototype-harness read from a repo. Run once per repo before first use, and again to add a skill left out earlier."
disable-model-invocation: true
---

# Setup t-bendet skills

Bring a repo up to the [guide contract](../../CONTRACT.md): the guides, sections and operation
names the other skills in this plugin cite. The contract is the authority; this skill fills the
**gaps** between it and the repo. A guide is written from the repo's own evidence, with the user
supplying only what the repo cannot show.

## 1. Explore

- Run `mattpocock-skills:setup-matt-pocock-skills` first when `docs/agents/issue-tracker.md` is
  absent and a tracker skill is wanted: it is user-invoked, so ask the user to run it, and stop
  until that guide exists. `prototype-harness` alone needs no tracker guide.
- Ask which of the three skills this repo will use **now**; the contract's **Guides** section says
  which guides each needs. A skill wanted later is left out, and a later run of this skill adds it.
- `prototype-harness` has a stack prerequisite: the client's manifest shows React, Vite, React
  Router 7 with a root `middleware`, TanStack Query, an axios instance and Tailwind. Name what is
  missing and leave the skill out.
- Run [check-contract.sh](../../scripts/check-contract.sh) as `check-contract.sh <repo> <skills>`,
  naming only the chosen skills. Its `MISSING` lines are the gap list.
- Gather evidence for each gap, by skill:

  | Skill             | Evidence                                                                                                                                                                                                                                                                                                                                                                                                             |
  | ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | batch-tickets     | The base branch (`gh repo view --json defaultBranchRef`). The **Merge a PR** form, from the merge settings and required checks below. The commit-subject and branch-name conventions in the entrypoint and `git log`. The package manifest's scripts. The CI workflow's jobs and its `on:` triggers.                                                                                                                 |
  | roadmap-batch     | An existing roadmap or backlog file. The type labels in `docs/agents/triage-labels.md` and the tracker (`gh label list`), and which one marks a feature.                                                                                                                                                                                                                                                             |
  | prototype-harness | The client's root layout, API-client and router files, where the query client is created, each feature's query keys, anything that bypasses the axios instance (a mock mode), the dev origin and how to start the API and client, `.gitignore`, a package that depends on `@playwright/test`, and a sign-in request with its seeded user fixture. Record an absent one as absent, with what a prototype branch adds. |

- **Merge settings**:
  `gh api repos/<owner>/<repo> --jq '{allow_auto_merge, allow_squash_merge, allow_merge_commit, allow_rebase_merge, delete_branch_on_merge}'`.
  **Required checks**:
  `gh api repos/<owner>/<repo>/branches/<base>/protection --jq .required_status_checks.contexts`
  and `gh api repos/<owner>/<repo>/rules/branches/<base>`. A 404, or a 403 on a private repo whose
  plan has no protection, means the base branch has no required checks: **Merge a PR** takes the
  direct form.
- **No CI workflow on the base branch** stops a tracker skill: `gh pr checks` exits 1 with "no
  checks reported" on every PR, so nothing can go green. Tell the user, and offer a one-job
  workflow that runs the local checks on pull requests and on pushes to the base branch.
- Read the entrypoint and the harness's permission settings for **colliding rules**, and turn each
  into a question: a rule confining an agent to listed files (a ticket brief lists none), a rule
  or deny on force-pushing (a deferred ticket's retry pushes with `--force-with-lease`), a rule
  that agents never commit or merge.
- List the labels the guides name that the tracker lacks: the two triage roles, and the feature
  type label.

Done when every gap has either evidence or a question for the user.

## 2. Ask

Put every question the evidence left open in one message, each with a recommended answer, and
wait. Typical ones, by skill:

- batch-tickets: the merge method, the after-merge check, each colliding rule.
- roadmap-batch: where the roadmap lives, the feature type label, whether to create the missing
  labels.
- prototype-harness: which middleware blocks the route commit, where the prototype folder goes,
  which package gains `@playwright/test` when none has it, the screenshot output folder.

A user who delegates the answers gets your recommendations, printed back as the answers.

## 3. Draft and confirm

Draft each missing guide from its template in [templates/](templates/), replacing every
`<FILL: ...>` marker with the repo's fact and leaving the other `<...>` placeholders, which belong
to the issue templates and commands. A FILL the repo has no fact for (no formatter, no
documentation check, no protection, no sign-in) is deleted with its line, or replaced by one
sentence saying the repo has none where a reader would otherwise look for it.

| Gap                                                              | Template                                                           |
| ---------------------------------------------------------------- | ------------------------------------------------------------------ |
| Operations or Branching in the tracker guide                     | [issue-tracker-additions.md](templates/issue-tracker-additions.md) |
| `## Cloud sessions`, when tickets are worked from cloud sessions | [cloud-sessions.md](templates/cloud-sessions.md)                   |
| `docs/agents/verification.md`                                    | [verification.md](templates/verification.md)                       |
| `docs/agents/roadmap-group.md`                                   | [roadmap-group.md](templates/roadmap-group.md)                     |
| The roadmap file                                                 | [roadmap.md](templates/roadmap.md)                                 |
| `docs/agents/prototype-harness.md`                               | [prototype-harness.md](templates/prototype-harness.md)             |

An existing guide is extended, never replaced: add the missing names and leave the rest as the
repo wrote it. An existing roadmap keeps its items; it gains the "How the roadmap is worked"
section, group numbering, `Human first:` lines and "Parked". Where `docs/agents/triage-labels.md`
lists no type labels and the repo has them, add one line naming them and the one that marks a
feature. On a tracker other than GitHub, rewrite the commands and keep the operation names.

Show the drafts and let the user edit before writing.

## 4. Write

Write the guides. Create the labels the user agreed to (`gh label create <name>`). Add the harness
output folder to `.gitignore` when it is not ignored.

Then point at each new guide from the repo's agent **entrypoint**: `AGENTS.md`, or `CLAUDE.md`
where that is the only one. A `CLAUDE.md` that only imports `AGENTS.md` makes `AGENTS.md` the
entrypoint; when the `mattpocock-skills` setup left its `## Agent skills` block in such a
`CLAUDE.md`, offer to move it so both blocks sit in one file. Add the rows to the entrypoint's
task-guide table, creating the table when it has none, each worded by when to read it:

```markdown
| Before working on…                         | Read                                                        |
| ------------------------------------------ | ----------------------------------------------------------- |
| Issues, branches, commits, PRs, or merging | [Issue workflow](docs/agents/issue-tracker.md)              |
| Check selection or build failures          | [Verification guide](docs/agents/verification.md)           |
| Roadmap groups: parents, slices            | [Roadmap group guide](docs/agents/roadmap-group.md)         |
| What to build next                         | [Roadmap](<the roadmap file>)                               |
| UI or loading prototypes                   | [Prototype harness guide](docs/agents/prototype-harness.md) |
```

Done when `check-contract.sh <repo> <skills>` prints `contract satisfied`: every required name is
present, every guide is reachable from the entrypoint, and no `<FILL:` marker is left.

## 5. Report

List the guides written or extended, the labels created, the colliding rules and what was decided
for each, the `optional` lines the check still prints and what each would enable, and the skills
now ready to run.
