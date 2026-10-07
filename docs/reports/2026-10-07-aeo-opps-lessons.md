# What aeo-opps teaches the scaffold

- **Written:** 2026-10-07
- **Reviews:** aeo-opps on `jf/v3` at `ced10a4`, releases v3.0.0 to v3.3.1, with the session transcripts from the v3.2.0 to v3.3.0 handoff
- **Type:** Artifact. It records recommendations, the owner's rulings on them, and what was applied.

aeo-opps started from the Agent Factory template, not this scaffold, but its process came from the scaffold brainstorm. Six releases in two days show which parts held up. The per-version folder worked best, and it is the main recommendation. One handoff between versions went wrong, and the fix, a "Starting a Version" section in aeo-opps `AGENTS.md`, belongs in the scaffold too.

## Recommendations

| # | Recommendation | Where it goes | Status |
|---|---|---|---|
| 1 | Add the per-version folder: one `README.md` for each release that holds the design, the human test, and the results, plus `specs/`, `plans/`, and `reviews/` when the project uses superpowers and orko-review | `template/docs/versions/README.md`, and a line in the `template/AGENTS.md` file map | Applied |
| 2 | Add a version close-out checklist, and state that a release isn't done until it's closed out | `template/docs/versions/README.md` | Applied |
| 3 | Add the handoff prompt shape for a session that starts in a parent folder | `template/docs/versions/README.md`, and the parent-repository row in `PATHWAYS.md` | Applied in the versions README. The `PATHWAYS.md` row is unchanged |
| 4 | Add a `## Commands` placeholder, including which commands only the owner runs | `template/AGENTS.md` | Open |
| 5 | Label `docs/context/` as artifacts and `BACKLOG.md` as not promised in the file map | `template/AGENTS.md` | Open |
| 6 | Ask for both a human test and a machine-led test in "How to know it works" | `template/ROADMAP.md` | Open |
| 7 | Add `tmp/` to the ignore list, for scratch files the owner shares with a session | `template/.gitignore` | Applied, because the versions README names `tmp/` |
| 8 | Fix the `DECISIONS.md` row, with the entry format | `template/PATHWAYS.md` | Applied in the row. No separate starter file |
| 9 | Promote a root `DECISIONS.md` that `AGENTS.md` names to controlling | Global `CLAUDE.md`, Document authority table | Open |
| 10 | Promote the "end each output with decisions and a recommendation for each" rule | Global `CLAUDE.md` | Open |
| 11 | When `BACKLOG.md` exists, send out-of-scope findings there instead of only listing them | Global `CLAUDE.md`, Scope and focus | Open |
| 12 | Extend the timestamp hook and its global `CLAUDE.md` line to specs and plans in version folders | `~/.claude/hooks/superpowers-doc-timestamps.py`, global `CLAUDE.md` | Applied |

Items 4 to 11 come from the 2026-10-06 review in chat. The v3.2.0 to v3.3.1 work confirms each of them, and item 8 has new evidence.

## The per-version folder

Each release has a folder, `docs/versions/<version>/`, and its `README.md` does three jobs in one file.

| Section | What it does | Example |
|---|---|---|
| Opening paragraph and `Rulings:` line | Names the roadmap item and lists the DECISIONS entries that govern it, instead of restating them | `3.2.0/README.md`: "Rulings: D1, D4, D12, D17, D25 to D43." |
| The design | Written before any code, "so the plan survives if the session that builds it ends" | `3.2.0/README.md`, `3.3.0/README.md` |
| What the release holds | A table of the files the release adds or changes | `3.1.0/README.md`, `3.1.1/README.md` |
| Human test | Numbered steps with a check at each step. The owner writes them before the release, and they end with "Record the result and the Claude Code version in this file" | `3.2.0/README.md`, nine steps |
| Results | Dated entries with **Run by**, **Result**, **Found**, and **Changed** lines. Machine-led test counts and mutation counts follow | `3.1.0/README.md`, two human tests |
| `REVIEW.md`, when one runs | An independent design review, marked as an artifact that changes no ruling, ending with decisions for the owner | `3.2.0/REVIEW.md` |

### Why it worked

- **One file per release replaced a spec, a plan, a test plan, and a test report.** Superpowers wasn't running (D2), and nothing was missing. Formal-v1 had six subfolders per version, and aeo-opps used one file.
- **Findings turned into changes, and the file keeps both.** The first v3.1.0 human test found the folder step in the wrong place, which became D24. The second found the session miscounting files, which became v3.1.1. The v3.3.0 human test found two false "position missing" rows, which went to the backlog as the first eval targets.
- **Patches stay small.** `3.1.1/README.md` is 24 lines. It names its cause, lists its changes, and states that the owner decides whether a patch needs a human test.
- **Errors in earlier artifacts get corrected forward.** `3.3.1/README.md` says a claim in `3.2.0/REVIEW.md` "held only for the design D42 replaced," and leaves the review as written.
- **Real data stays out.** `3.3.0/README.md` states that the human test's run data is real campaign data, so it stays in the gitignored `tmp/` and never enters the file or a test.

### Where it goes in the scaffold

The scaffold's design keeps process out of `template/`: only `PATHWAYS.md` holds suggestions (spec, "Success criteria"). The version README carries process, such as writing the design before code. Two ways to fit it:

- **A new `pathways/` folder in the scaffold repository** holds starter files that a project copies when a trigger fires: `pathways/versions/README.md`, the skeleton of a version README with the close-out checklist, and `pathways/DECISIONS.md`. `PATHWAYS.md` rows point to them. This keeps `template/` free of process and gives the pathways real starting material instead of `archive/formal-v1/`.
- **Put `docs/versions/` in `template/`.** Every project releases, so the trigger always fires. It breaks the spec's rule that no template file except `PATHWAYS.md` holds process.

The owner chose the template: every project starts with `docs/versions/`. That overrides the rule in the lean scaffold spec (`docs/superpowers/specs/2026-09-27-lean-scaffold-design.md`, "Success criteria"), which this report leaves as written because the spec is an artifact.

### With or without superpowers

A project can write its specs and plans with superpowers, or with a similar tool, or without one. Either way, everything for a release lives in its version folder, and the project has no `docs/superpowers/` folder. One flat `docs/superpowers/specs/` folder grows to hundreds of files over a project's life. Version folders split the same files by release.

```text
docs/versions/3.2.0/
├── README.md     Always. Without superpowers, it holds the design. With superpowers, it links the spec and plan.
│                 Either way, it holds the human test and the results.
├── specs/        superpowers brainstorming, when the project uses it
├── plans/        superpowers writing-plans, when the project uses it
└── reviews/      orko-review runs, one <doc-stem>/<timestamp>/ folder for each run
```

`specs/` and `plans/` sit directly in the version folder, not in a `superpowers/` subfolder, because of how orko-review chooses where to write. `reviews_dir()` in `orko_review.py` checks three rules in order:

1. If a folder named `superpowers` contains the document, at any level up to the repository root, it writes to that folder's `reviews/`.
2. If the document's folder is named `specs` or `plans`, it writes to `reviews/` in the folder one level up.
3. Otherwise, it writes to `reviews/` next to the document.

With `specs/` and `plans/` directly in the version folder, rules 2 and 3 send a review of the spec, the plan, or the version `README.md` to the same `docs/versions/3.2.0/reviews/`. With a `superpowers/` subfolder, rule 1 sends spec and plan reviews to `superpowers/reviews/` and rule 3 sends `README.md` reviews to the version's own `reviews/`, so one release would have two review folders.

What makes it work:

- **superpowers takes the location from the project.** brainstorming and writing-plans both say "User preferences for spec location override this default" (and the same for plans). The project's `AGENTS.md` names `docs/versions/<version>/specs/` and `docs/versions/<version>/plans/`.
- **orko-review needs no change.** Its existing rules land reviews in the version folder.
- **The timestamp hook needs one change.** `~/.claude/hooks/superpowers-doc-timestamps.py` stamps only paths that contain `/docs/superpowers/` (line 18), and the global `CLAUDE.md` line about timestamps names the same path. Both need to cover `docs/versions/*/specs/` and `docs/versions/*/plans/`.
- **subagent-driven-development needs no change.** It keeps its ledger in the gitignored `.superpowers/sdd/`, keyed by the plan's path.

The aeo-opps `REVIEW.md`, written by hand from two reviewers, is what `reviews/` replaces in a project that uses orko-review.

The recommendation is the `pathways/` folder, with the trigger "The first roadmap milestone starts." The decisions list at the end of this report includes it.

## The handoff issue

### What happened

On 2026-10-07, the v3.3.0 session started inside the v3.2.0 worktree. v3.2.0 was released in the changelog and fully tested, but no one had closed it out: its worktree and branch were still there, and `jf/v3` didn't have its commits. A `ROADMAP.md` note said the v3.2.0 pull request waited for v3.3.0, which the session read as v3.2.0 not being done. The owner corrected it: the pull request waits, but the version is finished.

The session then couldn't do the close-out itself. A session started inside a worktree can't run git against the main checkout or another worktree, and `!` commands run through it fail the same way. The owner called it "a messy run."

### What changed

The owner added a "Starting a Version" section to aeo-opps `AGENTS.md` (commit `e121d2b`):

1. A minor version starts by closing out the previous one, unless the owner says its work carries over. A patch skips the close-out.
2. The owner runs the close-out in a terminal outside Claude, or a session started in a parent folder runs it. The steps: fast-forward the integration branch, tag the release commit, create the new worktree, move gitignored files that the new version needs (`tmp/`, `dist/`), then remove the old worktree and delete its branch with `git branch -d`.
3. Start the new version's session in its own worktree or a parent folder, never in the previous version's worktree.
4. Closing out a version doesn't open a pull request.
5. A session can't read `~/Documents`, so the owner copies run output into the worktree's `tmp/`.

The v3.3.0 session then started in the parent folder, `rfs/`, from a handoff prompt. That prompt had to tell the session to read the worktree's `AGENTS.md` and the project's memory folder, because neither loads automatically from a parent folder.

### What the scaffold should take

- **Done includes close-out.** The root cause was that nothing said who closes out a version, or when. The version README skeleton should end with a close-out checklist, so the release that finishes is the one that cleans up.
- **Release and pull request are separate.** A pull request can wait. A version close-out can't.
- **Who can run what is a fact about the session, so write it down.** A worktree session can't touch other checkouts, a parent-folder session can, and neither can read `~/Documents`. These limits belong next to the close-out steps.
- **A parent-folder session needs a handoff prompt.** The scaffold's parent-repository row already says "Start sessions in the parent." It should add that `AGENTS.md` and memories don't load from a parent folder, so the opening prompt names them and gives a reading order. The aeo-opps prompt also named the sibling projects and what not to touch, such as never merging to `main`.

Keep project-specific values out of the starter file: the branch names (`jf/v3`, `jf/v3.X.0`), the worktree path, and the `3.X.0` numbering are aeo-opps choices.

## DECISIONS.md at scale

aeo-opps reached 46 rulings in two days, which tests the append-only rule more than the 24 seen on 2026-10-06.

- **Append-only held.** No entry was edited after the fact.
- **The `PATHWAYS.md` row contradicts itself.** It says to "mark the old entry superseded instead of editing it," and adding a mark is an edit. aeo-opps never marks old entries.
- **Forward-only links get hard to follow with partial replacements.** D34 replaces parts of D25, D26, D29, D31, and D32, and D42 then replaces D34 "for the search pass only." Read alone, D25 gives the wrong answer about who dispatches the search pass, and nothing in D25 says so. Each version README's `Rulings:` line was the working index.
- **Entries follow one format:** a numbered heading, **Date**, **Ruling**, and **Why**. A ruling that replaces another starts with "Replaces Dn."

The recommendation for the row: append-only, with one allowed addition to an old entry, a final line `- **Replaced:** in part by D34, D42`. That line adds information and changes none, so the ruling's text stays as written.

## Not for the scaffold

- **The control, detect, and document tiers** (`resources/planning/approach.md`). They're strong, but they only apply to software that runs on machines the team doesn't control. Revisit if a second project like that comes along.
- **The "Why TypeScript" section** in `AGENTS.md`. Recording why a project departs from its organization's default language is good practice, but the content is specific to aeo-opps.
- **Stages inside a version** (Stage A, B, and C in v3.2.0, each with its own review-fix commit). This worked for the largest release, but one example isn't enough to suggest it.

## Owner rulings, 2026-10-07

| Question | Ruling | Applied in |
|---|---|---|
| Where the version folder lives | Every project starts with it, in the template | `template/docs/versions/README.md`, `template/AGENTS.md` |
| superpowers specs and plans | A project can use superpowers, or a similar tool, or neither. With superpowers, specs and plans go in the version folder, the project has no `docs/superpowers/`, and the release `README.md` is at least an index of the folder | `template/docs/versions/README.md`, `template/AGENTS.md` |
| orko-review output | Its `reviews/` folder sits inside the version folder | `template/docs/versions/README.md` |
| Whether to commit `reviews/` | Commit each review run, and ignore only orko-review's `.lock` file | `template/.gitignore` |
| Where the timestamp rule applies | `docs/superpowers/`, plus `specs/` and `plans/` in each version folder. A version `README.md` and `reviews/` stay unstamped | `~/.claude/hooks/superpowers-doc-timestamps.py`, global `CLAUDE.md` |
| How `DECISIONS.md` handles replaced entries | One appended `Replaced:` line on the old entry | `template/PATHWAYS.md` |
| Whether close-out assumes worktrees | A branch per version, with the worktree steps as a variant | `template/docs/versions/README.md` |

## Open decisions

1. **Items 4 to 6 and 9 to 11 in the recommendations table.** Recommendation: apply 4 to 6 in the template, and 9 to 11 in the global `CLAUDE.md` as a separate change.
2. **Whether every release gets a tag.** The close-out tags a release "when the project tags releases," because `PATHWAYS.md` still suggests tags only for a release with rollback stakes. aeo-opps tagged every release at no cost. Recommendation: tag every release, and remove the tags row from `PATHWAYS.md`.
3. **The parent-repository row in `PATHWAYS.md`.** It says "Start sessions in the parent" without saying that a parent-folder session doesn't load the project's `AGENTS.md`. Recommendation: add that sentence to the row.
