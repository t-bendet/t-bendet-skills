# Roadmap

<What this file is: intent not yet specced into issues. Issues hold specced work.>

## How the roadmap is worked

**One group at a time.** A group becomes a parent issue, one sub-issue per vertical slice and a
closing re-triage, in the shapes the [roadmap group guide](agents/roadmap-group.md) holds. The
parent issue is where the group's decisions live; this file names the questions, never the
answers. A slice's PR removes its item line here and corrects any fact its change made false; the
closing re-triage removes the group block.

**Pick the entry skill by how many decisions the group has open.**

- No open decision: run `roadmap-batch`, which files the issues and hands them to `batch-tickets`.
- One decision: write the parent issue from the guide, then run `mattpocock-skills:to-tickets`
  against it so the human session becomes its first sub-issue. That ticket runs
  `mattpocock-skills:research` for a comparison, `mattpocock-skills:prototype` for a UI question,
  or `mattpocock-skills:grilling` for semantics.
- Several interlocking decisions: open a `mattpocock-skills:wayfinder` map for that group.

**Closing re-triage.** The last ticket of every group; this checklist is its acceptance criteria:

- [ ] Every item line of the group is gone from this file; any left is quoted in the PR with why.
- [ ] The group block is removed, and each decision it settled is recorded where it lasts (an ADR,
      a guide, the constraints below).
- [ ] Every remaining group is read against what shipped; facts the group made false are corrected.
- [ ] The PR states whether the order of the remaining groups still holds, and closes #<parent>.

## Groups in order

### 1. <Group name>

Human first: <the open decision and who or which skill settles it. Delete this line when the group
has none; mark it resolved with a link when the decision lands.>

- <Item line: one outcome, one sentence. A slice's PR removes it.>

## Parked

- <Item no batch may take, with the reason.>
