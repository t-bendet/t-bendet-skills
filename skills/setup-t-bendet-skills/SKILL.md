---
name: setup-t-bendet-skills
description: "Scaffold the guides batch-tickets, roadmap-batch and prototype-harness read from a repo. Run once per repo before first use."
disable-model-invocation: true
---

# Setup t-bendet skills

Bring a repo up to the [guide contract](../../CONTRACT.md): the guides, sections and operation
names the other skills in this plugin cite. The contract is the authority; this skill fills the
**gaps** between it and the repo. A guide is written from the repo's own evidence, with the user
supplying only what the repo cannot show.

## 1. Explore

- Run `mattpocock-skills:setup-matt-pocock-skills` first when `docs/agents/issue-tracker.md` is
  absent: it is user-invoked, so ask the user to run it, and stop until that guide exists.
- Ask which of the three skills this repo will use; the contract's **Guides** section says which
  guides each needs.
- Run `scripts/check-contract.sh <repo> <skills>` from this plugin's root. Its `MISSING` lines are
  the gap list.
- Gather evidence for each gap: the default branch and branch protection (`gh repo view`,
  `git remote show origin`), the scripts in the package manifest, the CI workflow's jobs, an
  existing roadmap or backlog file, the client's layout, API-client and router files, the E2E
  package and its seeded user fixture.

Done when every gap has either evidence or a question for the user.

## 2. Ask

Put every question the evidence left open in one message, each with a recommended answer, and
wait. Typical ones: the merge method and whether auto-merge is on, the after-merge check, where
the roadmap lives, which middleware blocks the route commit.

## 3. Draft and confirm

Draft each missing guide from its template in [templates/](templates/), replacing every
`<placeholder>` with the repo's fact:

| Gap                                          | Template                                                           |
| -------------------------------------------- | ------------------------------------------------------------------ |
| Operations or Branching in the tracker guide | [issue-tracker-additions.md](templates/issue-tracker-additions.md) |
| `docs/agents/verification.md`                | [verification.md](templates/verification.md)                       |
| `docs/agents/roadmap-group.md`               | [roadmap-group.md](templates/roadmap-group.md)                     |
| The roadmap file                             | [roadmap.md](templates/roadmap.md)                                 |
| `docs/agents/prototype-harness.md`           | [prototype-harness.md](templates/prototype-harness.md)             |

An existing guide is extended, never replaced: add the missing names and leave the rest as the
repo wrote it. An existing roadmap keeps its items; it gains the "How the roadmap is worked"
section, group numbering, `Human first:` lines and "Parked". On a tracker other than GitHub,
rewrite the commands and keep the operation names.

Show the drafts and let the user edit before writing.

## 4. Write

Write the guides, then add a pointer to each new one in the repo's agent entrypoint (`AGENTS.md`,
or `CLAUDE.md` when that is the one that exists), worded by when to read it:

```markdown
| Check selection or build failures | [Verification guide](docs/agents/verification.md) |
| Roadmap groups: parents, slices | [Roadmap group guide](docs/agents/roadmap-group.md) |
| UI or loading prototypes | [Prototype harness guide](docs/agents/prototype-harness.md) |
```

Done when `scripts/check-contract.sh <repo> <skills>` prints `contract satisfied` and no
`<placeholder>` is left in a written guide (`grep -n '<[a-z][^>]*>' docs/agents/*.md` shows only
placeholders the templates mean to keep, such as `<type>/<issue#>-<slug>`).

## 5. Report

List the guides written or extended, the `optional` lines the check still prints and what each
would enable, and the skills now ready to run.
