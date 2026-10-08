# v1.0.0 security review

- **Written:** 2026-09-29
- **Reviews:** `master` at `v0.3.0`, and the deployment planned in D2
- **How:** The owner, with Claude Code and the `web-security` skill, before the first public deploy, as `AGENTS.md` requires
- **Type:** Artifact. It changes no ruling. Finding 1 needs a decision, which is listed at the end.

## Verdict

**Deploy after fixing findings 1 to 3.** The app has no server, no accounts, and no network calls after it loads, so the attack surface is small: what gets rendered, what gets imported, and what else shares the app's origin. Rendering holds up. The origin doesn't, as planned.

## Findings

| # | Finding | Likelihood | Impact | Fix |
|---|---|---|---|---|
| 1 | A GitHub Pages project site is served from `<user>.github.io/<repo>/`, and every project site on the account shares that origin. Any of them can read, change, or erase this app's local storage | Certain, once the account has a second project site | High: the whole list is exposed or lost, with no server copy | Host on an origin of its own. Needs an owner decision |
| 2 | The app sends no Content-Security-Policy, and GitHub Pages can't set response headers | Low: rendering uses `textContent` everywhere (see "What holds up") | High if an injection appears later: a script could read the whole list | Send a CSP that allows scripts only from the app's origin and blocks network calls |
| 3 | Import reads a file of any size into memory, and accepts task text of any length | Low: the person picks the file | Low: a very large file freezes the tab until they close it | Refuse files over 1 MB and task text over 1,000 characters |
| 4 | An exported backup is plain JSON, readable by anyone who gets the file | Medium: backups get emailed and synced to cloud storage | Low to medium, depending on what the tasks say | Say so in `SECURITY.md`. Encrypting backups goes to the backlog only if someone asks |

## What holds up

- **Rendering.** Every place task text enters the page uses `textContent`. A search of the code found no `innerHTML`, `insertAdjacentHTML`, or `document.write`.
- **Import.** `backup.js` rebuilds each task from three known fields, so a backup can't add fields the app would act on.
- **No third-party code.** The app loads no scripts, styles, or fonts from another origin, so there's nothing to pin with Subresource Integrity.

## Suggestions not adopted

- **Encrypt local storage.** The key would live on the same origin as the data, so anything that can read the data can read the key.
- **A confirmation before delete.** It isn't a security control, and the 0.1.0 design ruled it out on purpose.

## Decisions for the owner

1. **Where to host.** Recommendation: Cloudflare Pages, which gives each project its own `pages.dev` origin and reads security headers from a `_headers` file. That fixes findings 1 and 2 together. Netlify works the same way, and either is free at this size.

The owner approved Cloudflare Pages on 2026-09-30 (D3).
