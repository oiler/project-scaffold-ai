# Roadmap

What's being done now.

## v1 scope

### What it includes

- Add a task with one text field and the Enter key.
- Mark a task done, and undo it.
- Edit a task's text, and delete a task.
- Tasks persist in the browser's local storage across reloads and restarts.
- Export the list to a file and import it back, as the backup for data that never leaves the device (DEC1).
- The layout works on a phone and a laptop, and every action works from the keyboard.
- The app is deployed to a static host at a public URL, on an origin of its own (DEC3).

### How to know it works

The owner opens the deployed URL on a phone, adds three tasks, finishes one, closes the browser, and reopens it to find the same list in the same state.

A machine-led browser test does the same against a local server on every change: it adds, finishes, edits, and deletes tasks, reloads the page, and checks the list. The owner runs the phone test by hand at each milestone.

## Milestones

1. **v0.1.0: A list that remembers.** Add, finish, edit, and delete tasks, saved to local storage. Runs from a local server. Released 2026-09-16.
2. **v0.2.0: Phone and keyboard.** The layout works at phone width, and every action has a keyboard path with a visible focus state. Released 2026-09-21.
3. **v0.3.0: Backup.** Export the list to a file and import it back (DEC1). Promoted from `BACKLOG.md` on 2026-09-21. Released 2026-09-25.
4. **v1.0.0: Deployed.** The app is live at a public URL after a security review, and the owner's phone test passes there. Released 2026-10-01.

v1 is complete. The next milestone comes from `BACKLOG.md` when the owner promotes one.

## Status log

- 2026-09-14: Project created.
- 2026-09-14: v0.1.0 started. Its design is in `docs/versions/0.1.0/README.md`.
- 2026-09-16: v0.1.0 released.
- 2026-09-21: v0.2.0 released. Sync between devices came up for the second time, so the owner recorded DEC1 and promoted export and import from the backlog as v0.3.0. Deployment moved to v1.0.0.
- 2026-09-25: v0.3.0 released.
- 2026-09-30: The v1.0.0 security review moved hosting from GitHub Pages to Cloudflare Pages (DEC3).
- 2026-10-01: v1.0.0 released. v1 scope complete.
