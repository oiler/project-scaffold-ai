# Roadmap

Planned work, in order. When a milestone finishes, it moves to `docs/history.md`.

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

No milestone is planned. v1 shipped as v1.0.0, and `docs/history.md` lists the four milestones that built it. The next milestone comes from `BACKLOG.md` when the owner promotes one.
