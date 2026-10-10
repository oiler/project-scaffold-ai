# v0.1.0: A list that remembers

The first roadmap milestone. You can add, finish, edit, and delete tasks, and the list survives a reload and a browser restart. It runs from a local server. Phone layout and deployment are v0.2.0 and v0.3.0.

## What the release changes

| Path | What it is |
|---|---|
| `index.html` | The page: the add field and the task list |
| `app.js` | Task state, rendering, and saving to local storage |
| `styles.css` | Minimal styles for one readable column |
| `tests/tasks.spec.js` | The machine-led browser test |
| `playwright.config.js` | Starts a local server for the test |

## Design

### Data

The list is an array of tasks saved under one local storage key, `todo-app:tasks`, as JSON:

```json
[{ "id": "k3x9", "text": "Buy stamps", "done": false, "createdAt": "2026-10-08T14:02:00Z" }]
```

- The app reads the key once on load and writes the whole array after every change. A list for one person stays small, so rewriting it is cheaper than tracking changes.
- If the stored value doesn't parse, the app starts with an empty list and keeps the bad value under `todo-app:tasks:corrupt`, so nothing is lost silently.
- A task's text is trimmed. Empty text is refused.

### Behavior

| Action | How |
|---|---|
| Add | Enter the text in the field and press Enter. The new task goes to the top |
| Finish | Select the checkbox. The task fades and moves below the open tasks. Selecting it again reopens it |
| Edit | Double-click the text, or focus it and press Enter. Enter saves, and Escape cancels |
| Delete | The delete button on the task. No confirmation, since a deleted task is one line to retype |

### Rendering

`app.js` renders the list from state after each change. Task text goes into the page with `textContent`, never `innerHTML`, so text such as `<img onerror=…>` shows as typed (`AGENTS.md`, project rules).

## Human test

The owner runs this test in a desktop browser.

1. Serve the project with `python3 -m http.server 8000` and open `http://localhost:8000`.
2. Add three tasks: "Buy stamps", "Call the dentist", and `<b>bold?</b>`. Check that the third shows the tags as typed, not as bold text.
3. Finish "Buy stamps". Check that it fades and moves below the open tasks.
4. Edit "Call the dentist" to "Call the dentist on Monday", and press Enter.
5. Delete the third task.
6. Quit the browser, reopen it, and open the page again. Check that the list shows the same two tasks in the same state.

Record the result, the browser, and its version in Results.

## Results

### Machine-led tests, 2026-09-16

- `npx playwright test`: 7 of 7 pass: add, refuse empty text, finish, reopen, edit, delete, and reload. Each test failed before its code existed.

### Human test, 2026-09-16

- **Run by:** The owner, in Firefox 130 on macOS 15.
- **Result:** Pass, on all six steps. The `<b>bold?</b>` task showed its tags as typed.
- **Found:** Pressing Enter with only spaces in the add field cleared the field and added nothing, without saying why.
- **Changed:** The field keeps what was entered and shows "Enter a task first." under it. A test covers the message.

## Close-out

- [x] The human test recorded under "Results". The folder holds only this README, so it has no "This folder" section
- [x] The version added to `CHANGELOG.md`
- [x] The milestone's row and log entry added to `docs/history.md`
- [x] The milestone removed from `ROADMAP.md`, so the next milestone is first in its list
- [x] The release branch merged into `master`, with `git merge --ff-only`
- [x] The release commit tagged `v0.1.0`
- [x] The release branch deleted with `git branch -d`
- [x] The next release's branch created from `master`
