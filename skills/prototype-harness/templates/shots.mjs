import { existsSync } from "node:fs";
import { mkdir } from "node:fs/promises";
import { createRequire } from "node:module";
import { basename, dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { config } from "./config.ts";

// repo: fill this block from the repo's harness guide, "Screenshot run".
const repoSettings = {
  origin: "http://localhost:5173",
  // A package.json, relative to the repo root, whose dependencies include @playwright/test.
  playwrightFrom: "package.json",
  // { path, data } for a JSON sign-in request with a seeded test user, or null for no sign-in.
  signIn: null,
  output: ".scratch/prototype-shots",
};

const folder = dirname(fileURLToPath(import.meta.url));
let repo = folder;
while (!existsSync(join(repo, ".git"))) {
  const parent = dirname(repo);
  if (parent === repo) throw new Error("Cannot find the repository root");
  repo = parent;
}
const require = createRequire(join(repo, repoSettings.playwrightFrom));
const { chromium, request } = require("@playwright/test");
const topic = basename(folder);
const [filter = "", origin = repoSettings.origin] = process.argv.slice(2);
const output = join(repo, repoSettings.output, topic);
const hideChrome =
  "[data-prototype-switcher],[class*=tsqd]{display:none!important}";
const viewports = {
  phone: { width: 390, height: 844 },
  desktop: { width: 1440, height: 900 },
};

// cases: add routes and interactions here; capture() records the current state,
// and capture("settled") records a second frame after a case's readiness assertion.
const cases = [
  {
    name: "home",
    path: "/",
    async run({ page, capture }) {
      await page.getByRole("main").waitFor();
      await capture();
    },
  },
];

const choices = [
  ...Object.entries(config.axes).map(([key, options]) => [
    key,
    options.map((option) => option.key),
  ]),
  ...Object.entries(config.toggles),
];
const matrix = choices.reduce(
  (rows, [key, values]) =>
    rows.flatMap((row) => values.map((value) => ({ ...row, [key]: value }))),
  [{}],
);
const slug = (value) => String(value).replace(/[^a-zA-Z0-9_-]/g, "_");
const jobs = matrix.flatMap((params) => {
  const variant = Object.entries(params)
    .map(([key, value]) => `${slug(key)}-${slug(value)}`)
    .join("-");
  return cases.flatMap((scenario) =>
    Object.entries(viewports).map(([viewportName, viewport]) => ({
      params,
      scenario,
      viewport,
      name: `${topic}-${variant}-${slug(scenario.name)}-${viewportName}`,
    })),
  );
});
const selected = jobs.filter(({ name }) => name.includes(filter));
if (selected.length === 0) throw new Error(`No captures match: ${filter}`);
await mkdir(output, { recursive: true });

// Sign in once; a failed sign-in stops the run rather than retrying into a rate limit.
let storageState;
if (repoSettings.signIn) {
  const api = await request.newContext({ baseURL: origin });
  try {
    const login = await api.post(repoSettings.signIn.path, {
      data: repoSettings.signIn.data,
    });
    if (!login.ok()) throw new Error(`Sign-in failed: ${login.status()}`);
    storageState = await api.storageState();
  } finally {
    await api.dispose();
  }
}

const browser = await chromium.launch();
try {
  for (const { params, scenario, viewport, name } of selected) {
    const context = await browser.newContext({ viewport, storageState });
    try {
      const page = await context.newPage();
      const url = new URL(scenario.path, origin);
      for (const [key, value] of Object.entries(params)) {
        url.searchParams.set(key, String(value));
      }
      await page.goto(url.href);
      await page.locator("[data-prototype-switcher]").waitFor();
      const capture = async (phase = "") => {
        if (phase !== "" && phase !== "settled") {
          throw new Error('Capture phase must be empty or "settled"');
        }
        await page.addStyleTag({ content: hideChrome });
        const path = join(output, `${name}${phase ? `-${phase}` : ""}.png`);
        await page.screenshot({ path, fullPage: true, style: hideChrome });
        console.log(path);
      };
      await scenario.run({ page, capture, params });
    } finally {
      await context.close();
    }
  }
} finally {
  await browser.close();
}
