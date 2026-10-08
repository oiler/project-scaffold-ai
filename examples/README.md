# Examples

Projects built from `template/` with the placeholders answered, to show what a filled-in scaffold looks like over a project's life. The products are invented, and so are the owner's answers, test results, and dates.

| Project | What it shows |
|---|---|
| [`todo-app/`](todo-app/) | A to-do list web app taken from its first day to v1.0.0 in four releases |

## What `todo-app/` shows

| Scaffold feature | Where to look |
|---|---|
| Answered placeholders | `PROJECT.md`, `ROADMAP.md`, and `AGENTS.md`. `AGENTS.md` answers the optional Commands section, and `ROADMAP.md` answers the optional test prompt |
| A release folder for each roadmap milestone, written before code | `docs/versions/0.1.0/` to `docs/versions/1.0.0/` |
| Human-test findings that changed the release | Results in `0.1.0`, `0.2.0`, and `0.3.0` |
| Correcting an earlier release's record forward | `0.2.0/README.md` changes the Edit design from `0.1.0` and leaves `0.1.0` as written |
| A backlog item promoted to the roadmap | v0.3.0, with the reason in the `ROADMAP.md` status log |
| A review saved in a release folder | `docs/versions/1.0.0/reviews/security-review.md` |
| The `DECISIONS.md` pathway, including a replaced entry | `DECISIONS.md`: DEC3 replaces DEC2, and DEC2 ends with a `Replaced:` line |
| The `SECURITY.md` pathway at the first public deploy | `SECURITY.md`, and the review rule in `AGENTS.md` |
| The close-out checklist | The end of each release `README.md` |

The project doesn't use superpowers, so each release `README.md` holds its own design. It has no application code. The paths in each release's "What the release changes" table are the files the release would change. `_headers` is the one exception, because the file map names it.

Each example was created with `scripts/new-project.sh <target> <name> --owner oiler --no-git`, then edited by hand. When `template/` changes, an example isn't updated automatically, so it can fall behind.
