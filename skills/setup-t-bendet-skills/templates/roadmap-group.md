# Roadmap group issues

How a roadmap group becomes issues: one **parent**, one sub-issue per vertical **slice**, and a
**closing re-triage** as the last slice. The roadmap names a group's questions; the parent holds
its answers; each slice body carries the rules the shipping skills read. The templates below are
the single copy of those rules.

Who reads which issue:

- `mattpocock-skills:to-tickets` fetches the parent and writes the slices from it, so the parent's
  **standing block** is what reaches every slice.
- `roadmap-batch` files parent, slices and re-triage from these templates.
- `batch-tickets` reads a slice body for two things: the quoted roadmap line (its diff must touch
  the roadmap file) and the fixed phrase `Merge policy: stop at PR open`.

Tracker operations (sub-issues, blocking edges, labels) are in the
[issue workflow](issue-tracker.md); the label pair is in [triage labels](triage-labels.md).

## Roadmap file

`<FILL: path to the roadmap, e.g. docs/ROADMAP.md>`

## Parent issue

Title: the group's roadmap heading. Labels: `<FILL: the type label that marks a feature, from triage-labels.md>`.

```markdown
## What to build

<The group's outcome in one paragraph, from the user's side. Then what the group depends on and
which earlier groups satisfied it.>

Decisions that shape every slice:

- <Each decision the human ticket settled, with its link.>
- Every slice's last acceptance criterion quotes the roadmap item line its PR removes and names
  any roadmap fact the change makes false; the PR edits the roadmap file.
- <FILL: the test every slice ships, e.g. its own E2E, named in its criteria.>
- The first slice that introduces a new seam carries `Merge policy: stop at PR open`; every other
  slice merges on green.
- The closing re-triage is the last sub-issue, blocked by every other slice; its PR closes this
  issue and carries `Merge policy: stop at PR open`.

## Slices

- [ ] <Human ticket, first, labelled `ready-for-human`, or "done" with its link>
- [ ] #<n> <slice title> (blocked by #<n>)
- [ ] #<n> Group <N>: closing re-triage of the roadmap (blocked by every slice above; its PR closes
      this issue)

## Done when

Every slice above is closed and the decisions are recorded in this issue. The closing re-triage
removes the group <N> block from the roadmap and closes this issue with its PR.
```

The standing bullets are copied verbatim into every parent. Group-specific decisions go above
them.

## Slice issue

A sub-issue of the parent, labels `<FILL: the type label that marks a feature, from triage-labels.md>` and `ready-for-agent`, blocking edges
native. The body is the `mattpocock-skills:to-tickets` issue template; its acceptance criteria end
with the standing tail. Domain vocabulary, no file paths or snippets, as that skill says.

```markdown
**What to build:** <the end-to-end behaviour, from the user's side>

**Blocked by:** <#n, or "nothing">

<Merge policy: stop at PR open — only on the slice that opens a new seam>

- [ ] <criterion>
- [ ] <FILL: the standing test criterion, matching the parent's bullet>
- [ ] The roadmap's group <N> line "<quoted item line>" is removed<, and "<quoted fact>" is
      corrected to what shipped>.
```

The quoted line is the carrier: a slice whose diff leaves the roadmap untouched fails the
criterion, and the re-triage's first checklist item is the backstop.

## Closing re-triage issue

Title: `Group <N>: closing re-triage of the roadmap`. Labels `<FILL: the type label that marks a feature, from triage-labels.md>` and
`ready-for-agent`. Blocked by every other sub-issue of the group.

```markdown
**What to build:** the roadmap edit that closes group <N>. The group block comes out, every
decision the group settled (<list them>) is carried back into the roadmap and the ADRs, every
remaining group is read against what shipped, and the PR says whether the remaining order holds.
The roadmap's "Closing re-triage" checklist is the acceptance criteria, copied below with #<parent> filled in.

**Blocked by:** every other sub-issue of the group.

Merge policy: stop at PR open; the order of the remaining groups is reviewed by hand.

- [ ] <the roadmap's "Closing re-triage" checklist, one item per line>
```

The checklist is copied, not linked, so the ticket stands alone when its turn comes.

## Filing order

1. Parent first, with the human ticket as its first sub-issue when the group has one.
2. Slices as sub-issues, blockers before the slices they block.
3. The re-triage last, blocked by every slice.
4. Blocking edges in a second pass, once every issue has a number.

Done when every slice body ends with its quoted roadmap line, the re-triage and any new-seam slice
carry `Merge policy: stop at PR open`, and the parent lists every sub-issue.
