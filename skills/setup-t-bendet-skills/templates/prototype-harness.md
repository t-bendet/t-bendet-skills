# Prototype harness

Repo facts for the `prototype-harness` skill. The skill holds the process and the templates.

## Install sites

| Name             | Path                                                                                 |
| ---------------- | ------------------------------------------------------------------------------------ |
| Prototype folder | `<FILL: e.g. src/components/prototype; say when the first prototype creates it>`     |
| Root layout      | `<FILL: the layout that renders the root Outlet>`                                    |
| API client       | `<FILL: the file that creates the axios instance, and the instance's export name>`   |
| Router           | `<FILL: the file or files that define and attach the root route's middleware>`       |
| Query client     | `<FILL: where it is created, and how the router file reaches it for probeAfterUser>` |

<FILL: The middleware that blocks the route commit, which `probeAfterUser` follows; or that none
does, so `probeAfterUser` goes last and `wait` reads about 0.>

<FILL: What bypasses the axios instance, such as a mock mode, and how to run without it: the
latency toggle delays only requests through the instance. Delete when nothing does.>

<FILL: Query-string parameters the app owns, which no axis or toggle may be named after, and
whether the app rewrites the whole search string. Delete when the app keeps no state there.>

## Query keys

| Route pattern     | Query keys                             |
| ----------------- | -------------------------------------- |
| `<FILL: pattern>` | `<FILL: the feature's query-key call>` |

<FILL: For an app with one route, or with its state in the search string: how a cold-cache
comparison is made, since the probe evicts only when the pathname changes. Delete otherwise.>

## Screenshot run

- Dev origin: `<FILL: e.g. http://localhost:5173>`; pass another origin as the script's second
  argument when the port moved.
- Playwright resolves from: `<FILL: a package.json that depends on @playwright/test; or, when none
does, the package.json a prototype branch adds it to and the install commands>`
- Sign-in: `<FILL: POST path and the seeded test user's fixture, or "none">`
- Output folder: `<FILL: a git-ignored folder, e.g. .scratch/prototype-shots>`
- Before running: <FILL: how to start the API and the dev client>

## Lessons

None yet. Each prototype adds what it taught, with its issue number, when it closes.
