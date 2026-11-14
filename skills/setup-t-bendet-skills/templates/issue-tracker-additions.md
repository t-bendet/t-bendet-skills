<!-- Merge into docs/agents/issue-tracker.md. Add each operation under "## Conventions" unless the
guide already has one of that name; add the Branching section whole. GitHub form; rewrite the
commands for another tracker and keep the names. -->

- **List a parent's sub-issues**: `gh api repos/<owner>/<repo>/issues/<parent>/sub_issues --jq '[.[] | select(.state == "open") | .number]'`. An issue is a parent when `gh api repos/<owner>/<repo>/issues/<n> --jq .sub_issues_summary.total` is above 0.
- **Blocking**: GitHub's native issue dependencies. Add an edge with `gh issue create --blocked-by <n>,<n> ...` or `gh issue edit <child> --add-blocked-by <blocker>` (`gh` 2.94+). Older `gh`: `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`, where `<blocker-db-id>` is `gh api repos/<owner>/<repo>/issues/<n> --jq .id`. Where dependencies are unavailable, put a `Blocked by: #<n>, #<n>` line at the top of the child body. A ticket is unblocked when every blocker is closed.
- **List a ticket's blockers**: `gh api repos/<owner>/<repo>/issues/<n>/dependencies/blocked_by --jq '[.[].number]'` (open and closed).
- **Count open blockers**: `gh api repos/<owner>/<repo>/issues/<n> --jq .issue_dependencies_summary.blocked_by` (0 means startable).
- **Watch CI**: `gh run list --branch <branch> --json databaseId --jq '.[0].databaseId'` finds the run; `gh run watch <run-id> --exit-status` waits for it. For a PR: `gh pr checks <pr> --watch`.

## Branching

Every ticket is implemented on its own branch, off an up-to-date `<base branch>`, with a PR against
`<base branch>`.

Branch name: `<type>/<issue#>-<slug>`: the conventional-commit type matching the bulk of the
change, the bare issue number, and 2-5 kebab-case words from the title. Work with no ticket drops
the number.

Commit subjects use `<type>: <summary>`. The commit body and the PR body reference the issue with
`Closes #<issue#>` so the tracker closes it on merge; work that leaves the issue open uses
`Part of #<issue#>`, because closing keywords ignore negation.

<Merge rules: the merge method, whether auto-merge is enabled, whether the tracker deletes head
branches on merge, and any branch protection that forces one PR at a time.>
