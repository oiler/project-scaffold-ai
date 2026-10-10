# v1.0.0: Deployed

The fourth roadmap milestone, and the end of v1 scope. The app goes live at a public URL after a security review, and the owner's phone test passes there.

Rulings: DEC1, DEC2, DEC3.

## This folder

| Path | What it is |
|---|---|
| `README.md` | This release record |
| `reviews/security-review.md` | The web security review run before the first deploy, as `AGENTS.md` requires |

## What the release changes

| Path | What it is |
|---|---|
| `_headers` | The security headers Cloudflare Pages sends with every response |
| `backup.js` | Refuses import files over 1 MB and task text over 1,000 characters |
| `app.js` | Refuses new or edited task text over 1,000 characters |
| `tests/backup.spec.js` | Cases for both limits |
| `SECURITY.md` | How to report a vulnerability, and what the app protects |
| `README.md` | How to use the deployed app and back up the list |

## Design

The design first deployed to GitHub Pages (DEC2). The security review found two problems with it, so the release deploys to Cloudflare Pages instead (DEC3). This section describes the release as shipped.

### Hosting

Cloudflare Pages deploys `master` on every push, with no build command, to the project's own `pages.dev` subdomain. The app's local storage is on that origin alone. Every `.dev` domain is on the browsers' HSTS preload list, so the app only loads over HTTPS.

### Headers

`_headers` applies these to every path:

```text
/*
  Content-Security-Policy: default-src 'self'; connect-src 'none'; object-src 'none'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'
  X-Content-Type-Options: nosniff
  Referrer-Policy: no-referrer
  Permissions-Policy: camera=(), microphone=(), geolocation=()
```

`connect-src 'none'` turns the "no network calls after it loads" principle into something the browser enforces.

### Limits

| Input | Limit | When it's exceeded |
|---|---|---|
| Import file size | 1 MB, about 5,000 tasks | "This file is too large to be a Todo App backup." |
| Task text, when added, edited, or imported | 1,000 characters | The add or edit field says "Tasks can be up to 1,000 characters." An imported task is skipped and counted |

## Human test

The owner runs this test on the deployed app, on a phone and a laptop.

1. On the laptop, run `curl -sI https://<project>.pages.dev`. Check that the response includes each header in `_headers`.
2. Open the URL in a laptop browser with the developer tools open. Use every feature once, including both backup buttons. Check that the console shows no Content-Security-Policy violations.
3. On the phone, open the URL, add three tasks, and finish one.
4. Close the browser completely, reopen it, and open the URL. Check that the list shows the same three tasks in the same state.
5. Try to import a file over 1 MB. Check that the app refuses it and the list hasn't changed.

Steps 3 and 4 are the v1 test in `ROADMAP.md`, "How to know it works". Record the result, the devices, and the browsers in Results.

## Results

### Machine-led tests, 2026-10-01

- `npx playwright test`: 28 of 28 pass. Each of the 4 new limit tests failed before its limit existed.

### Human test, 2026-10-01

- **Run by:** The owner, on an iPhone 15 in Safari on iOS 18 and on a MacBook in Firefox 130, against the deployed app.
- **Result:** Pass, on all five steps. `curl` showed every header, and the console showed no violations.
- **Found:** Nothing.

v1 scope is complete.

## Close-out

- [x] Every file in this folder listed under "This folder", and the human test recorded under "Results"
- [x] The version added to `CHANGELOG.md`
- [x] The milestone's row and log entry added to `docs/history.md`
- [x] The milestone removed from `ROADMAP.md`, so the next milestone is first in its list
- [x] The release branch merged into `master`, with `git merge --ff-only`
- [x] The release commit tagged `v1.0.0`
- [x] The release branch deleted with `git branch -d`
- [ ] The next release's branch created from `master`. It waits until the owner promotes a backlog item
