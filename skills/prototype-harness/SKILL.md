---
name: prototype-harness
description: "Use for a UI or loading prototype comparing several variants live in a React client: a copyable switcher, loading probes and screenshot matrix."
---

Use this harness when a UI or loading question needs several variants compared live in the
client. It is a standalone developer tool; the `mattpocock-skills:prototype` skill can use it
independently of its other steps.

The templates assume **React, Vite, React Router middleware, TanStack Query, an axios client and
Tailwind**. The repo's own paths and lessons live in its harness guide,
`docs/agents/prototype-harness.md`, per the [guide contract](../../CONTRACT.md); without that guide,
tell the user to run `setup-t-bendet-skills`. Names in `<angle brackets>` below come from the guide.

## Copy and configure

Copy [templates/](templates/) into `<prototype folder>/<topic>/`. Fill `config.ts`: issue number,
named axes of `{ key, name }` options, and named toggle value lists. Each list is nonempty; its
first option is the default. Use distinct axis/toggle names, reserving `timings` for measurements
and the query-string parameters the guide lists as app-owned. Keep `config.ts` import-free,
erasable TypeScript: `shots.mjs` runs it through Node directly.
The issue derives `PROTOTYPE-<n>` in sessionStorage and the `PROTOTYPE (#n)` comment marker.
Update the copied README's one-line plan and bar-row table. Wire the compared views with
`useProto()`; loaders and middleware read `proto()`. Changing a choice does not rerun loaders.

## Install checklist

Mark every touch point outside the copied folder, including imports and every compared view
that reads `useProto()`, with the literal `PROTOTYPE (#n)` from `commentMarker`.
`git grep -F 'PROTOTYPE (#n)'` must list the cleanup sites. The files are the guide's
**Install sites**. Dependency, lockfile and ignore-file additions cannot carry the marker: list
them in the copied README and revert them by hand at cleanup.

`import.meta.env.DEV` is true under Vitest, so the installed harness is live in unit tests.

- [ ] In the `<root layout>`, import `PrototypeSwitcher` from the copied folder and mount
      `{import.meta.env.DEV && <PrototypeSwitcher />}` beside `<Outlet />`. The switcher also
      returns `null` outside development.
- [ ] For latency, import `installPrototypeLatency` in the `<API client>`. Where the axios
      instance is created, call `installPrototypeLatency(instance)` under
      `if (import.meta.env.DEV)` once the instance exists.
- [ ] For navigation measurements, import both probes in the `<router>`. Replace the root
      middleware list with a development ternary, preserving the existing production list, with
      `probeStart` first and `probeAfterUser` after the middleware that blocks the route commit:

```tsx
const rootRoute = {
  // PROTOTYPE (#n)
  middleware: import.meta.env.DEV
    ? [probeStart, ...existingMiddleware, probeAfterUser(queryClient)]
    : existingMiddleware,
};
```

Where the query client is out of scope in the `<router>`, pass it into the router factory and mark
that call site too.

For a purely visual prototype, keep the switcher and omit the two loading install sites.

## Loading toolbox

Take `latency.ts` when requests must stay pending long enough to compare: define a numeric
`delay` toggle in milliseconds. It delays only requests through the axios instance. Take `navigation-probe.ts` to measure the whole navigation and
the wait before loaders, or to compare cache conditions. Define `cache: ["cold", "warm"]` for
query removal; without that toggle the probes only measure.

Fill `routeKeys` from the guide's **Query keys** before claiming a cold-cache comparison: it
maps route patterns to the feature-owned query keys. It ships empty so it cannot evict unrelated
data. Removal runs only when the destination pathname changes.

`useProto().timings` exposes `wait` and `total` in milliseconds, without persisting them.
Use the switcher's marked `extras` slot for one-offs, such as a last-navigation readout or a button
shown on one route. Add the session's local state alongside that control.

## Screenshot matrix

Fill the `repo` block at the top of the copied `shots.mjs` from the guide's **Screenshot run**.
Use a Node that runs TypeScript files directly (22.18 or newer), since the script imports
`config.ts`; start the local API and the Vite dev client (a production preview
hides the bar), then run:

```sh
node <prototype folder>/<topic>/shots.mjs [filter] [origin]
```

The optional first argument is a substring of the full filename stem. The second is the client
origin, defaulting to the `repo` block's; pass `""` as the filter to capture everything on a
custom origin. Pass the origin as Vite prints it: a client on `localhost` refuses `127.0.0.1`.
The script signs in once when the `repo` block has a sign-in request, reuses the
storageState, and visits every axis/toggle combination at phone 390×844 and desktop 1440×900.

Edit only the marked `cases` section for the scenario paths, interactions and readiness checks.
Call `capture()` at the comparison point and optionally `capture("settled")` after its readiness
assertion. Every capture hides the bar and query devtools. Files land in `<output folder>/<topic>/`
as `<topic>-{variant}-{case}-{viewport}[-settled].png`; `variant` includes every axis/toggle name
and value. A zero-delay capture shows the settled page; filter on a nonzero `delay` for a pending
one. A failed sign-in stops the run instead of retrying against a login rate limit.

## Rules

- Start loading comparisons cold. A stale time plus hover or focus prefetches can resolve a
  revisited route in milliseconds, hiding the loading state.
- Measure the middleware wait before trusting a streaming variant. A root middleware that awaits
  a request before the route commits keeps a streaming variant from streaming.
- Hide development chrome in every screenshot, including the collapsed switcher and query tools.
- Ask whether the whole variant family is acceptable before building it.
- Read the guide's **Lessons** before designing variants, and add what this prototype taught when
  it closes.
