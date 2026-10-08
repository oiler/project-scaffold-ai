# Decisions

Rulings the owner has made, newest last. Append only: to reverse a decision, add a new entry that names the one it replaces. The only change allowed to an old entry is one appended line that points forward, such as `- **Replaced:** by D3`.

## D1. No sync between devices in v1

- **Date:** 2026-09-21
- **Ruling:** v1 has no sync between devices. Export and import to a file is the backup, and it's promoted from the backlog as v0.3.0.
- **Why:** Sync came up in two separate conversations during v0.2.0. It needs an account and a server, which the "Your data stays on your device" principle rules out. A file the person keeps gives them a backup without either.

## D2. Host on GitHub Pages

- **Date:** 2026-09-21
- **Ruling:** v1.0.0 deploys to GitHub Pages from `master`.
- **Why:** It's free, it serves static files with no build step, and the code already lives on GitHub.
- **Replaced:** by D3

## D3. Host on Cloudflare Pages, on an origin of its own

- **Date:** 2026-09-30
- **Ruling:** Replaces D2. v1.0.0 deploys to Cloudflare Pages from `master`, on its own `pages.dev` subdomain, with the security headers in `_headers`.
- **Why:** The v1.0.0 security review (findings 1 and 2 of `docs/versions/1.0.0/reviews/security-review.md`) found that a GitHub Pages project site shares its origin with every other project site on the same account, so their pages can read and erase this app's local storage. GitHub Pages also can't set a Content-Security-Policy header.
