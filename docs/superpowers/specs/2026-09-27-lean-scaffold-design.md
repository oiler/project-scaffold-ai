# Lean scaffold design

- **Date:** 2026-09-27
- **Status:** Implemented on branch `lean-scaffold-design`, 2026-09-28. See [Implementation record](#implementation-record).
- **Replaces:** the `project-name/` scaffold, archived as `formal-v1`

## Problem

The scaffold starts a project at its heaviest: two repositories, ten ID types, controlled documents, and release gates, all before any software runs. On a small project, that front-loaded structure delays the first working version and creates work that keeps documents consistent without improving the product.

The scaffold should start lean: enough structure to build a first version that runs for real, and then iterate. Structure grows when the project needs it. A change in who's involved or in risk unlocks governance. A pain that actually happened unlocks the single piece that would have prevented it.

### Evidence

A review of three recent projects:

| Finding | Evidence |
|---|---|
| Front-loaded documents delayed working software | One project spent a week on documents only. Its first spec's acceptance criteria grew from 38 to 101 across five reviews. The formal build planned 61 tasks, completed 42, and never deployed. |
| One controlling doc and early deployment worked | The same project then switched to a single roadmap, deployed on day one, cut scope, and met two milestones within two days. It kept code review and wrote an implementation plan for each large milestone. |
| Every document with authority adds places for contradictions | That project ended up with four roadmaps and two backlogs. Another had decision-ID collisions across repositories. |
| Formality returns through rules, not only through this scaffold | Two projects never used the scaffold and still accumulated review folds, decision-ID families, prose-pinning tests, and a "fix nothing before its spec is approved" rule. |
| Real use found the bugs that mattered | The first deployment ran into ten environment traps. A live run of another project surfaced 14 bugs. |

A first draft of this spec repeated the pattern: it wrote working rules into the template, and one review round produced 71 findings, most of them conflicts between those rules and the tools the project uses.

## Principle

**The scaffold is structure: files. Each file has a one-line purpose and a skeleton of headings.** It holds no working rules.

The work gets done by the tools: Claude Code, superpowers, `orko-review`, `orko-sdd`, `front-end-design`, `git-tagging`, and the global `CLAUDE.md`. The scaffold's job is to give those tools the files and paths they already expect, and to stay out of their way. Rules that apply to every project (testing, process choice) live in one place, the global `CLAUDE.md`, and are never copied into a project.

The scaffold does own **prompts**: headings that ask for the v1 definition, the principles, the design vision, and any project-specific rules, such as when code review happens. No tool supplies those, and a question doesn't conflict with a rule.

## Audience

Projects start small, with one owner and Claude as the builder. The same project grows without a restart into:

- **Readers:** collaborators who read the documents but don't build. They need nothing beyond `README.md` and `PROJECT.md`.
- **Governed:** other people and agents build, and some governance is necessary.

Growth means adding files from `PATHWAYS.md`. Most are files the tools already know.

## Template

```
template/
├── .gitignore
├── README.md
├── AGENTS.md
├── CLAUDE.md
├── ROADMAP.md
├── BACKLOG.md
├── CHANGELOG.md
├── PROJECT.md
├── PATHWAYS.md
└── docs/
    └── context/
        └── .gitkeep
```

| File | Purpose | Headings |
|---|---|---|
| `README.md` | How to run the project, with a one-line description that links to `PROJECT.md` | How to run it |
| `AGENTS.md` | A map of the project's files, one line for each row of this table, and the project's own rules | Files, Project rules |
| `CLAUDE.md` | Imports `AGENTS.md` | None. The file contains only `@AGENTS.md`. |
| `ROADMAP.md` | What's being done now | v1 scope (What it includes, How to know it works), Milestones, Status log |
| `BACKLOG.md` | Everything not promised yet | Items |
| `CHANGELOG.md` | What shipped, for someone who uses it | Keep a Changelog format, as `git-tagging` expects: `# Changelog` and an empty `## [Unreleased]` section |
| `PROJECT.md` | Why the product exists and what guides its tradeoffs | Purpose, Who it's for, Principles, Design vision |
| `PATHWAYS.md` | Files to add as the project grows | A table of triggers |
| `.gitignore` | Keeps local and secret files out of git | `.env`, `.env.*` except `.env.example`, `.DS_Store`, `CLAUDE.local.md`, `.claude/settings.local.json` |
| `docs/context/` | Background: kickoff notes, research, briefs | None |

The `AGENTS.md` map describes each file in the same words as the Purpose column. It names `ROADMAP.md` as the controlling document and `PROJECT.md` as evergreen, so once follow-on 2 lands, the global `CLAUDE.md` authority table applies without extra rules.

The **Project rules** heading in `AGENTS.md` holds a prompt, not a rule: for example, `[When does code review happen, and who reviews? Any other rules this project needs?]`. The owner fills it in when the project needs it.

The template doesn't include `DESIGN.md`. That file belongs to the `front-end-design` skill, which applies a root `DESIGN.md` to front-end work with visual direction. A pathway adds it when UI work starts. The design vision, in prose, lives in `PROJECT.md`. Once `DESIGN.md` exists, it owns the visual specifics, and the `PROJECT.md` heading stays at the level of intent.

## Tool compatibility

| Tool | Expects | The scaffold provides |
|---|---|---|
| Claude Code | `CLAUDE.md`. From v2.1.277, `AGENTS.md` only when no `CLAUDE.md` exists, and not on Bedrock, Vertex, or Foundry | `AGENTS.md`, plus a `CLAUDE.md` that imports it. `CLAUDE.md` wins when both exist, so the import is what loads `AGENTS.md` |
| Codex and other agents | `AGENTS.md` at the git root | `AGENTS.md` |
| superpowers | `docs/superpowers/specs/` and `docs/superpowers/plans/` | Nothing in advance. superpowers creates them. |
| `orko-review` | Evergreen names at the root or in `docs/`; writes reviews to `docs/superpowers/reviews/` | `AGENTS.md`, `CLAUDE.md`, and `PROJECT.md` |
| `front-end-design` | `DESIGN.md` at the root in its own format | Nothing until the UI pathway adds it |
| `git-tagging` | `CHANGELOG.md` in Keep a Changelog format, and git tags | `CHANGELOG.md` with an `[Unreleased]` section |
| Global `CLAUDE.md` authority table | Evergreen names and a controlling document | `PROJECT.md` now, and `ROADMAP.md` after follow-on 2 |

## Pathways

`PATHWAYS.md` opens with one line: these are unproven suggestions, the canonical copy lives in the scaffold repository, and starting material for several of them is in that repository's `archive/formal-v1/`.

| Trigger | Add | Used by |
|---|---|---|
| UI work starts | `DESIGN.md` | `front-end-design` |
| A second builder joins | `CONTRIBUTING.md`, a PR template, and a CI workflow | Collaborators, GitHub |
| First internet-facing deployment, real users, or sensitive data | `SECURITY.md`, and a security review before each release | GitHub (`SECURITY.md`), `web-security` (the review) |
| A release with rollback stakes | Version tags | `git-tagging` |
| A decision gets relitigated | `DECISIONS.md` | People and agents reading the project |
| An architectural choice needs its reasoning kept | `ARCHITECTURE.md` | `orko-review` |
| The code must be public and the documents private | A private parent git repository that holds the documents and ignores `code/`, with the code as a public repository in `code/`. Start sessions in the parent. If the code already has history, start fresh history and scan for secrets first. | GitHub |

The table has no **Used on** column. Recording project names in the canonical copy would name projects in this repository and copy those names into every new project, so the owner dropped the column during review.

## Bootstrap

`scripts/new-project.sh <target-dir> <project-name> [--owner "<name>"] [--no-git]`

1. The script rejects a project name that doesn't match `^[a-z0-9][a-z0-9-]*$`, and refuses a target that already exists.
2. The script copies `template/` into a temporary directory created next to the target, so the final move is a rename on one filesystem. It moves the project into place only after every step succeeds, and removes the temporary directory on failure.
3. The script replaces `[project-name]`, `[Project Name]`, and `[YYYY-MM-DD]`, and replaces `[owner]` when `--owner` is given. Replacement values are literal data, so characters such as `&` and `|` come through unchanged. A placeholder with no matches isn't an error.
4. Unless `--no-git` is set, the script initializes one git repository on `master` with an initial commit.
5. The script prints every remaining placeholder with its file and line. A placeholder is a bracketed token outside markdown links, task checkboxes, fenced code, inline code, and Keep a Changelog version headings such as `[Unreleased]` and `[1.2.3]`.

## Archive

1. Tag the unmerged `hub/spec-release-gate-waivers` branch head (`3326436`) as `formal-v1-waivers`, so the work survives if the branch is deleted.
2. Create an annotated tag `formal-v1` on `c28474f`, the `master` HEAD when this spec was written. Push both tags to `hub` with the owner's approval.
3. Move `project-name/` to `archive/formal-v1/`.
4. Add `archive/README.md`: what `formal-v1` was, a link to this spec, how to bootstrap a formal-v1 workspace (check out tag `formal-v1` and run its `scripts/new-project.sh`), and a note that the `CLAUDE.md` and `AGENTS.md` files under `archive/` and `template/` are material, not instructions for work in this repository.

The repository then holds `.gitignore`, `README.md` (rewritten), `template/`, `scripts/new-project.sh`, `docs/superpowers/`, and `archive/`.

## Global follow-ons

Rules that apply to every project move to the global `CLAUDE.md`. The owner approved each edit as a drafted diff, and all three landed on 2026-09-27, before the rebuild. These edits live outside this repository, so this spec describes them and doesn't store the global text.

| # | Section | Change |
|---|---|---|
| 1 | Code defaults | Replace the red/green TDD bullet, including its trivial-change exemption, and the first sentence of the test-sizing bullet with a new Testing section holding the wording that follows this table. Keep the rule that scratch checks stay scratch. |
| 2 | Document authority | In the Controlling row, promote a root `ROADMAP.md` that the project's `AGENTS.md` names as controlling. If the current work contradicts its v1 scope or current milestone, the agent stops and asks whether the roadmap is stale or the work is off course, then records the answer in the status log. Projects without one keep the rule that the controlling layer may be absent. |
| 3 | Skills to use | Replace the rule that building means subagent-driven development with: when asked to build, choose the process the work needs (build directly, or plan and execute with superpowers), state the choice in one line, and proceed unless the user objects. This overrides the superpowers approval gate and its spec-and-plan requirement for architectural work. |

The global file names only skills the model can invoke on its own. `orko-sdd` and `orko-review` stay out of it, because they run only when the user invokes them explicitly.

Code review rules aren't global. Each project sets them under **Project rules** in its `AGENTS.md`.

These changes apply to existing projects too. That's intended: the owner chose to lighten the global rules. The Mutation verification section of the global `CLAUDE.md` stays where it is.

The testing wording for item 1, approved verbatim:

> **Every test goes red before it goes green.** Write the test, run it, see it fail for the expected reason, then write the code or fix that makes it pass. A test that has never failed hasn't proven anything.
>
> **Write tests where they pay off:**
> - the observable proof that a milestone works (an end-to-end run with an artifact)
> - a regression test for every real bug, at the lowest level that reproduces it
> - isolated tests on high-risk boundaries (parsing, validation, security, idempotency, money), with failure modes listed first
>
> **Don't write** tests that restate code, check prose, or only ever run against fakes when the real thing is reachable.
>
> **Testing existing code with no test,** for example before a refactor: prove the test can fail by temporarily breaking the code it covers, then restore it.

## Out of scope

- The parent `orko` skill, which the owner is reworking separately. Until then, it expects the formal-v1 layout and doesn't work on lean projects. Use `/orko-sdd` with a superpowers plan instead.
- Migrating existing projects.
- A `--public` script flag. The public-code case is a pathway.

## How to know it works

- `git rev-parse 'formal-v1^{commit}'` prints `c28474f42ba87cb3f223c5889b764e796a969352`.
- `archive/formal-v1/` holds the former `project-name/` tree.
- `new-project.sh` produces the files in [Template](#template), initializes one repository, and prints the remaining placeholders with file and line. A bad project name or an existing target exits non-zero and creates nothing.
- In a new project, `.env` is ignored and `.env.example` isn't.
- `--owner 'A & B|C'` appears literally in the output files, and a run that fails partway leaves no target directory.
- No template file other than `PATHWAYS.md` contains testing, review, or process instructions. `AGENTS.md` only prompts for project rules, and `PATHWAYS.md` rows are suggestions.
- No file in this repository names a specific project, client, person, or local filesystem path.
- The next real project deploys its v1, or uses it end to end, before it adds any pathway file.

## Implementation record

Implemented on 2026-09-28 in commits `3f267b6` (archive), `02426c0` (template, script, and README), `b47b273` (fixes from a whole-branch review), and the commit that records this section. The owner approved pushing both tags with the merge.

Choices the spec left open:

- `formal-v1-waivers` is an annotated tag, like `formal-v1`.
- `PROJECT.md` carries **Owner** and **Started** lines, and the `ROADMAP.md` status log starts with a "Project created" entry, so `[owner]` and `[YYYY-MM-DD]` have somewhere to land. No template file uses `[project-name]`; the slug reaches only the initial commit message.
- The script rejects a blank or multi-line `--owner` value, an empty target, and a target whose parent directory doesn't exist.
- The script builds the placeholder report before the move, so a failure in any step, including the report, creates nothing.

Changes from review:

- The owner dropped the **Used on** column from `PATHWAYS.md`, as described in [Pathways](#pathways).
- The Claude Code row in [Tool compatibility](#tool-compatibility) now states the v2.1.277 fallback correctly: Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists.

Known limits left in place: the script copies the working tree of `template/`, including untracked files; the placeholder report doesn't recognize escaped brackets, HTML comments, indented code, or shortcut reference links; and the "material, not instructions" note for `template/` and `archive/` lives only in READMEs, which agents don't load automatically.
