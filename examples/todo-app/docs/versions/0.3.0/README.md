# v0.3.0: Backup

The third roadmap milestone, promoted from `BACKLOG.md` on 2026-09-21. The list can be exported to a file and imported back. Tasks never leave the device on their own, so a file the person keeps is the only backup (DEC1).

Rulings: DEC1.

## What the release changes

| Path | What it is |
|---|---|
| `index.html` | **Export** and **Import** buttons below the list, and the import confirmation dialog |
| `backup.js` | Builds the export file, and parses and checks an import |
| `app.js` | Wires the buttons and the dialog to the list |
| `tests/backup.spec.js` | Export, then import, and one case for each way an import is refused |

## Design

### The backup file

**Export** downloads `todo-app-backup-<YYYY-MM-DD>.json`:

```json
{ "app": "todo-app", "format": 1, "exportedAt": "2026-09-25T09:30:00Z", "tasks": [{ "text": "Buy stamps", "done": true, "createdAt": "2026-09-16T14:02:00Z" }] }
```

The file leaves out task IDs. Import gives each task a new one.

### Import

An import file comes from outside the app, so `backup.js` treats it as untrusted.

| Check | When it fails |
|---|---|
| The file parses as JSON | "This file isn't a Todo App backup." |
| `app` is `todo-app` and `format` is `1` | "This file isn't a Todo App backup." |
| `tasks` is an array | "This backup has no task list." |
| Each task has non-empty string `text` | That task is skipped and counted |
| `done` is a boolean | Read as `false` |
| `createdAt` is a valid date | Set to the time of the import |

Each imported task is rebuilt from these three fields, so any other field in the file is dropped. When every task is skipped, the import is refused.

Import replaces the list, so it asks first, in a `<dialog>`: "Replace your 12 tasks with 40 tasks from this backup?" When tasks were skipped, the dialog says how many. The list changes only after **Replace**, and a refused import leaves it as it was.

## Human test

The owner runs this test in a laptop browser.

1. Add four tasks and finish one. Select **Export**, and check that a dated `.json` file downloads.
2. Clear the site's data in the browser settings, and reload. Check that the list is empty.
3. Select **Import**, choose the exported file, and check that the dialog offers to replace 0 tasks with 4.
4. Select **Replace**. Check that the four tasks are back, with the finished one still finished.
5. Import a JSON file that isn't a backup, such as a `package.json`. Check that the app says it isn't a Todo App backup, and that the list hasn't changed.

Record the result and the browser in Results.

## Results

### Machine-led tests, 2026-09-25

- `npx playwright test`: 24 of 24 pass. The 9 new backup tests include one for each refusal in the import table, and each failed before its check existed.

### Human test, 2026-09-25

- **Run by:** The owner, in Firefox 130 on macOS 15.
- **Result:** Pass, on all five steps.
- **Found:** With one task in the list, the dialog said "Replace your 1 tasks".
- **Changed:** The dialog uses "task" for one and "tasks" otherwise.

## Close-out

- [x] The human test recorded under "Results". The folder holds only this README, so it has no "This folder" section
- [x] The version added to `CHANGELOG.md`
- [x] The milestone's row and log entry added to `docs/history.md`
- [x] The milestone removed from `ROADMAP.md`, so the next milestone is first in its list
- [x] The release branch merged into `master`, with `git merge --ff-only`
- [x] The release commit tagged `v0.3.0`
- [x] The release branch deleted with `git branch -d`
- [x] The next release's branch created from `master`
