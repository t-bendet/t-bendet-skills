<!-- Optional. Merge into docs/agents/issue-tracker.md after "## Branching" when the repo's tickets
are worked from Claude Code cloud sessions. Keep a bullet only for an operation that fails there;
name each one exactly as under "## Conventions", so a skill finds its substitute by the same name.
GitHub form. Every `<FILL: ...>` is replaced or deleted with its sentence. -->

## Cloud sessions

A Claude Code cloud session (`CLAUDE_CODE_REMOTE=true`) cannot reach GitHub GraphQL, so
`gh issue ...`, `gh pr ...` and `gh pr checks` fail with 403. `gh api` (REST) and the `gh run ...`
commands work. Substitute as follows; everything else in this guide is unchanged.

- **Read an issue**: `gh api repos/<owner>/<repo>/issues/<n>`; its comments: `gh api repos/<owner>/<repo>/issues/<n>/comments`.
- **List issues**: `gh api "repos/<owner>/<repo>/issues?state=open&labels=<label>" --jq '[.[] | select(.pull_request | not)]'` (the endpoint returns pull requests too).
- **Create an issue**: `gh api --method POST repos/<owner>/<repo>/issues -f title="..." -F body=@<file> -f "labels[]=<label>"`. Sub-issues and blocking edges use the `gh api` forms under Conventions; `--parent` and `--blocked-by` are GraphQL.
- **Comment on an issue**: `gh api --method POST repos/<owner>/<repo>/issues/<n>/comments -f body="..."`.
- **Open a PR**: push the branch, then `gh api --method POST repos/<owner>/<repo>/pulls -f title="..." -f head=<branch> -f base=<FILL: base branch> -F body=@<file>`.
- **Watch CI**: the `gh run` form under Conventions. Per-check results: `gh api repos/<owner>/<repo>/commits/<sha>/check-runs`.
- **Merge a PR**: <FILL: keep the form matching Conventions. Direct: `gh api --method PUT repos/<owner>/<repo>/pulls/<n>/merge -f merge_method=squash`, once the checks are green. Auto-merge: `gh api --method PUT repos/<owner>/<repo>/pulls/<n>/ccr/auto_merge -f merge_method=squash`.>
- **Delete a branch**: refused from a cloud session. <FILL: whether the tracker deletes head branches on merge, so nothing is left to do, or who deletes them.>
