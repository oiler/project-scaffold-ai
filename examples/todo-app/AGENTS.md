# AGENTS.md

## Files

- `README.md`: how to run the project, with a one-line description that links to `PROJECT.md`.
- `AGENTS.md`: a map of the project's files, one line for each file, and the project's own rules.
- `CLAUDE.md`: imports `AGENTS.md`.
- `ROADMAP.md`: what's being done now. The controlling document.
- `BACKLOG.md`: everything not promised yet. Not promised.
- `CHANGELOG.md`: what shipped, for someone who uses it.
- `PROJECT.md`: why the product exists and what guides its tradeoffs. Evergreen.
- `PATHWAYS.md`: files to add as the project grows.
- `DECISIONS.md`: the owner's rulings, append only. Controlling, alongside `ROADMAP.md`.
- `SECURITY.md`: how to report a vulnerability, and what the app protects.
- `_headers`: the security headers Cloudflare Pages sends with every response.
- `.gitignore`: keeps local and secret files out of git.
- `docs/context/`: background, such as kickoff notes, research, and briefs. Artifacts.
- `docs/versions/`: one folder per release, with its record, specs, plans, and reviews. Its `README.md` explains the layout and the close-out. superpowers writes specs to `docs/versions/<version>/specs/` and plans to `docs/versions/<version>/plans/`, not to `docs/superpowers/`.

## Commands

- Serve the app: `python3 -m http.server 8000`, then open `http://localhost:8000`. There's no build step.
- Run the machine-led browser test: `npx playwright test`. It starts its own server.
- The owner runs the phone test by hand, from the steps in the release's `docs/versions/<version>/README.md`.

## Project rules

- Each roadmap milestone is a release with its own folder in `docs/versions/`. Before any code, write the release's `README.md` with its design and its human test.
- This project doesn't use superpowers. The release `README.md` holds the design.
- The owner reviews each release's diff before it merges to `master`.
- Every release from v1.0.0 on gets a web security review before it deploys, saved in its release folder's `reviews/`.
- The project tags each release.
- Store task text as text: never insert it into the page as HTML.
