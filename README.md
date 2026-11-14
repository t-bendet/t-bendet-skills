# t-bendet-skills

Agent skills for shipping tickets unattended and prototyping UI variants, written to work in any
repo that provides a small set of guides.

| Skill                                                          | What it does                                                                                   | Invoked by  |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ----------- |
| [batch-tickets](skills/batch-tickets/SKILL.md)                 | Works a queue of issues one at a time: branch, delegate, verify, PR, merge, report.            | agent, user |
| [roadmap-batch](skills/roadmap-batch/SKILL.md)                 | Interviews you, turns approved roadmap items into specced issues, hands them to batch-tickets. | user        |
| [prototype-harness](skills/prototype-harness/SKILL.md)         | A copyable variant switcher, loading probes and screenshot matrix for a React client.          | agent, user |
| [setup-t-bendet-skills](skills/setup-t-bendet-skills/SKILL.md) | Scaffolds the guides the other three read from a repo.                                         | user        |

## How it works

The skills hold process; each repo holds its own facts (base branch, check commands, labels,
roadmap path, client file paths) in guides under `docs/agents/`. [CONTRACT.md](CONTRACT.md) lists
the guides and the exact section and operation names the skills cite.

## Requirements

- The [`mattpocock-skills`](https://github.com/mattpocock/skills) plugin, set up in the repo with
  its own setup skill. These skills use its `pr`, `to-spec` and `to-tickets` skills and its
  issue-tracker and triage-label guides.
- `gh` for GitHub-tracked repos.
- `prototype-harness` only: React, Vite, React Router middleware, TanStack Query, axios, Tailwind,
  and Playwright for the screenshot matrix.

## Install

```bash
claude plugin marketplace add t-bendet/t-bendet-skills
```

```bash
claude plugin install t-bendet-skills@t-bendet --scope project
```

The install also installs and enables `mattpocock-skills` from the `claude-plugins-official`
marketplace at the same scope. Installed skills are named `t-bendet-skills:<name>`.

## Using it in a repo

1. Run `setup-t-bendet-skills` in the repo. It writes the missing guides from templates and the
   repo's own evidence.
2. Check the result with the script in this repo (in an install, under the plugin's `installPath`
   in `~/.claude/plugins/installed_plugins.json`):

   ```bash
   scripts/check-contract.sh /path/to/repo
   ```

   Name skills after the path to check only those: `scripts/check-contract.sh /path/to/repo batch-tickets`.

Without the plugin system, clone the repo and symlink each skill folder into the repo's skills
directory:

```bash
ln -s /path/to/t-bendet-skills/skills/batch-tickets .claude/skills/batch-tickets
```

Symlink, do not copy: the skills link to `CONTRACT.md` and `scripts/` two levels above their own
folder, which resolves through a symlink and breaks in a copy.

## License

[MIT](LICENSE)
