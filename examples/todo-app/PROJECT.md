# Todo App

Why the product exists and what guides its tradeoffs.

- **Owner:** oiler
- **Started:** 2026-09-14

## Purpose

Todo App is a to-do list for one person that runs in a web browser. Most to-do apps ask for an account, sync to a server, and grow features for teams. Todo App does the smallest useful thing: you add a task, you finish it, and the list is still there tomorrow, with no account and nothing sent anywhere.

## Who it's for

One person keeping a personal list on their own phone or laptop. They want to capture a task in a few seconds and see what's left at a glance. They don't share lists, and they don't want to sign up for anything.

## Principles

- **Fast to capture.** Adding a task takes one field and the Enter key. A feature that slows down capture waits until it can be done without slowing it.
- **Your data stays on your device.** Tasks live in the browser's storage. The app makes no network calls after it loads.
- **No build step.** Plain HTML, CSS, and JavaScript that a browser runs as is. A dependency has to save more work than it costs to maintain.
- **Works without a mouse.** Every action has a keyboard path and a visible focus state.

## Design vision

Quiet and plain, like a paper list: one column, readable type, and no decoration that competes with the tasks. Finished tasks fade and move out of the way rather than disappearing at once, so an accidental click is easy to notice and undo.
