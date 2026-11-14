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

## Using it in a repo

1. Run `setup-t-bendet-skills` in the repo. It writes the missing guides from templates and the
   repo's own evidence.
2. Check the result:

   ```bash
   scripts/check-contract.sh /path/to/repo
   ```

   Name skills after the path to check only those: `scripts/check-contract.sh /path/to/repo batch-tickets`.

The repo is laid out as a plugin (`skills/<name>/SKILL.md`) but ships no plugin manifest yet; until
it does, copy or symlink a skill folder together with `CONTRACT.md` into the repo's skills
directory.

## License

[MIT](LICENSE)
