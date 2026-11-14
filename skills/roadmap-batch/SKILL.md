---
name: roadmap-batch
description: "Interview the user, turn the approved roadmap items into specced issues, and hand the issue numbers to batch-tickets to ship."
disable-model-invocation: true
---

# Roadmap batch

Take roadmap items from intent to merged PRs in one invocation. The **interview** fixes the batch,
each approved item becomes a specced issue, and [batch-tickets](../batch-tickets/SKILL.md) ships the
queue. The order is fixed: filing depends on the interview, shipping depends on filing.

## Before you start

The repo's facts live in its guides, per the [guide contract](../../CONTRACT.md). A missing guide or
name stops the skill: tell the user to run `setup-t-bendet-skills`.

- The issue-tracker guide (`docs/agents/issue-tracker.md`) holds every tracker operation; read its
  **Cloud sessions** section first when `CLAUDE_CODE_REMOTE=true`.
- The triage-labels guide (`docs/agents/triage-labels.md`) holds the label pair an issue carries:
  the `ready-for-agent` role's label, plus one type label where the guide lists type labels.
- The roadmap group guide (`docs/agents/roadmap-group.md`) names the **roadmap file** candidates
  come from, and holds the parent, slice and closing re-triage templates.
- The spec template lives in `mattpocock-skills:to-spec`; the issue template and blocking-edge
  rules live in `mattpocock-skills:to-tickets`. Both are user-invoked, so read their `SKILL.md`
  files rather than invoking them: `skills/*/<name>/SKILL.md` under the plugin's `installPath` in
  `~/.claude/plugins/installed_plugins.json`.

## 1. Interview

Ask all five in one message, each with a recommended answer, and wait. Each answer is the user's
call: ask again for any left blank. A user who **delegates** the choices gets the recommendations,
printed back as the answers before step 2.

1. **Count**: how many items this batch takes.
2. **Selection criteria**: independence (no shared files), blast radius, one codebase area, or the
   user's own picks.
3. **Spec depth** per issue: the full `mattpocock-skills:to-spec` template, or acceptance criteria
   only (the `mattpocock-skills:to-tickets` issue template).
4. **Approval**: show each drafted issue body for approval before filing, or file directly.
5. **Merge policy** for the batch: merge on green, or stop at PR open.

Done when all five have an answer the user gave or delegated.

## 2. Propose candidates

Read the roadmap and explore the codebase enough to name the files each candidate would touch.
Then present, as numbered lists:

- **Candidates** matching the criteria, drawn from the lowest-numbered group with no open
  `Human first:` line, one line each saying why it fits.
- **Routed to a decision skill**: every item in a group whose `Human first:` line is open, and
  everything under "Parked". The roadmap's "How the roadmap is worked" section names the skill for
  that group; tell the user to run it, and keep those items out of this batch.
- **Shared files**: each pair of candidates that touches the same file, which needs a blocking edge
  or an agreed order. The roadmap file is exempt: every slice edits it.

Iterate until the user approves a list and its order. That approval is the permission to file.

## 3. Spec and file

A batch drawn from one roadmap group files that group's parent first, from the guide, and every
item as its sub-issue; a batch that takes the group's last items files the closing re-triage last,
blocked by every other sub-issue.

For each approved item, in the approved order:

1. **Check for duplicates** across open and closed issues (**List issues** with every state). A
   match becomes the ticket, reused as is or updated with the user's agreement, and nothing new is
   filed for it.
2. **Write the spec** at the chosen depth, keeping the template's own rules: domain vocabulary,
   the area's ADRs, no file paths or code snippets. Its acceptance criteria end with the guide's
   standing tail, including the quoted roadmap line the ticket's PR removes, which batch-tickets
   checks.
3. **Show the draft** and wait for a yes when the interview chose approval.
4. **File it** per the issue-tracker guide with that label pair.

Once every issue has a number, **wire the blocking edges** between the shared-file pairs in a second
pass, blocker first in the approved order; confirm each edge with **List a ticket's blockers**,
since the open-blocker count lags a new edge. Leave the roadmap line in place: each ticket's own PR
removes it, so the roadmap tracks what has landed.

Done when every approved item has an issue number, its label pair, and its edges.

## 4. Hand off

Invoke batch-tickets with the issue numbers in the approved order and the chosen merge policy, then
print the mapping of roadmap item to issue number so the user can follow the batch.

## Do not

- file an issue the user has not approved in step 2, or more issues than the agreed count
- fill in an interview answer the user neither gave nor delegated; ask again instead
- remove roadmap lines at filing time; the ticket's PR does that
- change the roadmap, other skills, or the guides this skill points at
