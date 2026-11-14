# Prototype harness

Repo facts for the `prototype-harness` skill. The skill holds the process and the templates.

## Install sites

| Name             | Path                                                  |
| ---------------- | ----------------------------------------------------- |
| Prototype folder | `<e.g. src/components/prototype>`                     |
| Root layout      | `<the layout that renders the root <Outlet />>`       |
| API client       | `<the file that creates the axios instance>`          |
| Router           | `<the file that defines the root route's middleware>` |

<The middleware that blocks the route commit, which `probeAfterUser` follows.>

## Query keys

| Route pattern | Query keys                       |
| ------------- | -------------------------------- |
| `<pattern>`   | `<the feature's query-key call>` |

## Screenshot run

- Dev origin: `<e.g. http://localhost:5173>`
- Playwright resolves from: `<a package.json that depends on @playwright/test>`
- Sign-in: `<POST path and the seeded test user's fixture, or "none">`
- Output folder: `<a git-ignored folder, e.g. .scratch/prototype-shots>`
- Before running: <how to start the API and the dev client>

## Lessons

- <What an earlier prototype here taught, with its issue number.>
