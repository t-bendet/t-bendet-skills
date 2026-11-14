# Prototype plan

Compare stacked/split layouts and compact/expanded detail on the existing home route.

## Run

Start the local API and the Vite client, then open `http://localhost:5173/?layout=A&detail=A`.
Read choices with `useProto()` in components and `proto()` in loaders or middleware; update
with `setProto()`. Changing the bar updates React readers and the URL without rerunning loaders;
navigate to exercise a loader variant. The URL overrides the session on a full load.

| Bar row | Keys           | What it changes                           |
| ------- | -------------- | ----------------------------------------- |
| layout  | A / B, ← / →   | Stacked / split (wire the compared views) |
| detail  | A / B          | Compact / expanded (wire the views)       |
| delay   | 0 / 800 / 2000 | Added milliseconds per API request        |
| cache   | cold / warm    | Destination query removal when mapped     |

Fill the plan and this table when adapting `config.ts`. The first option is each row's default.

Run `node <this folder>/shots.mjs [filter] [origin]` from the repo. The optional substring filter
matches the full capture stem; origin defaults to the one in the script's `repo` block. For all
captures on another port use `"" http://localhost:5174`. Edit the script's `cases` section for the
compared flows. Screenshots go to the `repo` block's output folder under this folder's name, with
the prototype bar and query devtools hidden. Each axis/toggle combination runs on phone and
desktop, signing in once when the `repo` block has a sign-in request.
