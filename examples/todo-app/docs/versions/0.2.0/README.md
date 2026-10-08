# v0.2.0: Phone and keyboard

The second roadmap milestone. The layout fits a phone screen, and every action works from the keyboard with a visible focus state. The app still runs from a local server.

## What the release changes

| Path | What it is |
|---|---|
| `styles.css` | Layout for phone and laptop widths, touch targets, and focus outlines |
| `app.js` | Keyboard handling, focus after delete, and the shortcut to the add field |
| `index.html` | Labels for every control, so screen readers name them |
| `tests/keyboard.spec.js` | Every action done from the keyboard alone |
| `tests/phone.spec.js` | The same actions in Playwright's iPhone 13 profile |

## Design

### Layout

- One column, at most `40rem` wide, centered, with `1rem` side margins at phone width.
- Every control is at least `44px` tall, the minimum comfortable touch target.
- Type is `1.125rem` on a phone so iOS Safari doesn't zoom when the add field gets focus.

### Keyboard

| Key | Action |
|---|---|
| `/` | Moves focus to the add field from anywhere outside a text field |
| Tab | Moves through the add field, then each task's checkbox, text, and delete button, in list order |
| Space | Finishes or reopens the focused task |
| Enter | On a task's text, starts editing. While editing, saves |
| Escape | While editing, cancels |

- Every focusable element shows a `2px` outline in the text color, offset by `2px`. The outline never depends on color alone.
- After a delete, focus moves to the next task, or to the previous one when the deleted task was last, or to the add field when the list is empty. A keyboard user never loses their place.

## Human test

The owner runs this test on a phone and on a laptop.

1. On the laptop, run `python3 -m http.server 8000 --bind 0.0.0.0`, and note the laptop's local IP address.
2. On the phone, on the same Wi-Fi network, open `http://<laptop-ip>:8000`. Check that the page fits the screen with no sideways scrolling.
3. On the phone, add two tasks, finish one, edit the other, and delete one. Check that each control is easy to tap.
4. On the laptop, without touching the mouse, press `/`, add three tasks, finish the second with Space, edit the third, and delete the first. Check that the focus outline is visible at every step.
5. After the delete, check that focus is on a task, not lost at the top of the page.

Record the result, the devices, and the browsers in Results.

## Results

### Machine-led tests, 2026-09-21

- `npx playwright test`: 15 of 15 pass, including the 7 from v0.1.0. Each new test failed before its code existed.

### Human test, 2026-09-21

- **Run by:** The owner, on an iPhone 15 in Safari on iOS 18 and on a MacBook in Firefox 130.
- **Result:** Pass after one change. The page fit the phone screen, and the keyboard steps passed on the first run.
- **Found:** Editing on the phone didn't work. A double-tap on a task's text zoomed the page instead of starting an edit, because touch browsers don't send double-click.
- **Changed:** Each task has an **Edit** button, after its text and before **Delete**. Double-click still edits on a laptop. This changes the Edit row in `docs/versions/0.1.0/README.md`, which stays as written.

### Outside the release

During this release, sync between devices came up for the second time. The owner ruled it out for v1 in DEC1. Export and import became v0.3.0, and deployment moved to v1.0.0.

## Close-out

- [x] Results recorded in this file, and the version added to `CHANGELOG.md`
- [x] The release branch merged into `master`, with `git merge --ff-only`
- [x] The release commit tagged `v0.2.0`
- [x] The release branch deleted with `git branch -d`
- [x] The next release's branch created from `master`
