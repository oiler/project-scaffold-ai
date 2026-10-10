# AGENTS.md

## Files

- `README.md`: how to run the project, with a one-line description that links to `PROJECT.md`.
- `AGENTS.md`: a map of the project's files, one line for each file, and the project's own rules.
- `CLAUDE.md`: imports `AGENTS.md`.
- `ROADMAP.md`: planned work, in order. The controlling document.
- `BACKLOG.md`: everything not promised yet. Not promised.
- `CHANGELOG.md`: what shipped, for someone who uses it.
- `PROJECT.md`: why the product exists and what guides its tradeoffs. Evergreen.
- `PATHWAYS.md`: files to add as the project grows.
- `DECISIONS.md`: the owner's rulings, append only. Controlling, alongside `ROADMAP.md`.
- `SECURITY.md`: how to report a vulnerability, and what the app protects.
- `_headers`: the security headers Cloudflare Pages sends with every response.
- `.gitignore`: keeps local and secret files out of git.
- `docs/context/`: background, such as kickoff notes, research, and briefs. Artifacts.
- `docs/history.md`: finished milestones, and a dated log. Artifact.
- `docs/versions/`: one folder per release, with its record, specs, plans, and reviews. Its `README.md` explains the layout and the close-out. superpowers writes specs to `docs/versions/<version>/specs/` and plans to `docs/versions/<version>/plans/`, not to `docs/superpowers/`.

## Commands

- Serve the app: `python3 -m http.server 8000`, then open `http://localhost:8000`. There's no build step.
- Run the machine-led browser test: `npx playwright test`. It starts its own server.
- The owner runs the phone test by hand, from the steps in the release's `docs/versions/<version>/README.md`.

## Document authority

When working across multiple product/project docs, identify what *type* each doc is before treating it as authoritative. Authority is not equal across types, and a confident, dated artifact must not silently override current direction.

| Type | What it is | How to weight it |
|------|-----------|------------------|
| **Evergreen** | Standing direction & guardrails: `CLAUDE.md`, `AGENTS.md`, and named files (`PROJECT.md` or `OBJECTIVE.md`, `DESIGN.md`, `ARCHITECTURE.md`) | Constrains everything. If current work contradicts it → **halt and ask**, then likely update the stale evergreen doc. |
| **Controlling** | What we're doing *now* = the current prompt + agreements reached this session. A dated doc is promoted here only when the prompt points at it, or when it's a root `ROADMAP.md` or `DECISIONS.md` that the project's `AGENTS.md` names as controlling. Within `DECISIONS.md`, a later entry that names an earlier one replaces it. | Authoritative for current work. Within this layer, **latest agreement wins**. If the current work contradicts `ROADMAP.md`'s v1 scope or current milestone, **stop and ask** whether the roadmap is stale or the work is off course. Otherwise may be absent — don't go hunting for one. |
| **Artifact** | Context, backstory, the *why*: anything carrying a date, incl. Superpowers plans & specs | On conflict with controlling, **down-weight — never silently discard**. Mine it for rationale; flag contradictions rather than acting on them. |

- Before treating any doc as authoritative, identify its type. Don't let a stale artifact override current direction.
- A conflict with evergreen is a **stop sign, not a tiebreaker** — surface it; don't resolve it silently.
- A project's `AGENTS.md` may define a finer authority order within its own docs (for example, accepted specs over `OBJECTIVE.md`). That order governs content conflicts inside the project; this table governs weighting across doc types.

In this project:

- **Evergreen:** `AGENTS.md`, `CLAUDE.md`, `PROJECT.md`, and `SECURITY.md`.
- **Controlling:** the current prompt, `ROADMAP.md`, and `DECISIONS.md`.
- **Artifacts:** `docs/history.md`, and everything in `docs/context/` and `docs/versions/`, including each release's `README.md` and `reviews/`.
- **Not promised:** `BACKLOG.md`.

## Project rules

- Each roadmap milestone is a release with its own folder in `docs/versions/`. Before any code, write the release's `README.md` with its design and its human test.
- This project doesn't use superpowers. The release `README.md` holds the design.
- The owner reviews each release's diff before it merges to `master`.
- Every release from v1.0.0 on gets a web security review before it deploys, saved in its release folder's `reviews/`.
- The project tags each release.
- Store task text as text: never insert it into the page as HTML.
