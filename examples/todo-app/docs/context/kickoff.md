# Kickoff notes

- **Date:** 2026-09-14
- **Type:** Artifact. It records how the project started. `PROJECT.md` and `ROADMAP.md` hold the current direction.

The owner wanted a to-do list that opens instantly and asks for nothing: no account, no sync, and no team features. Every list app tried during the kickoff wanted a sign-up before the first task.

Options considered for storage:

| Option | Why it was or wasn't chosen |
|---|---|
| Local storage | Chosen. Built into every browser, no server, and enough for one person's list |
| IndexedDB | More capacity and structure than a short list needs, and a harder API to use without a library |
| A server with accounts | Rules out "no account" and sends tasks off the device. Sync stays in the backlog |
