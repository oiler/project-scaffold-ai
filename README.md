# Project scaffold

A lean starting point for software built with AI agents. A new project gets enough structure to build a first version that runs for real, and it adds structure only when the project needs it.

The scaffold is files, not rules. Each file has a one-line purpose and a skeleton of headings. Claude Code, superpowers, and the other tools a project uses supply the working rules. The [lean scaffold design](docs/superpowers/specs/2026-09-27-lean-scaffold-design.md) explains the reasoning.

## Layout

| Path | What it is |
|---|---|
| `template/` | The files every new project starts with |
| `scripts/new-project.sh` | Bootstraps a project from `template/` |
| `examples/` | Projects built from `template/`, with the placeholders answered |
| `docs/superpowers/` | Design specs for this repository |
| `docs/reports/` | Reports on how the scaffold held up in real projects |
| `archive/` | The formal-v1 scaffold that this one replaced |

The `AGENTS.md` and `CLAUDE.md` files under `template/`, `examples/`, and `archive/` are material for other projects, not instructions for work in this repository.

## Start a project

Run the bootstrap script from the root of this repository. It needs bash, perl, and git 2.28 or later:

```sh
scripts/new-project.sh <target-dir> <project-name> [--owner "<name>"] [--no-git]
```

For example:

```sh
scripts/new-project.sh ../my-app my-app --owner "Owner Name"
```

The script does the following:

1. Rejects a project name that doesn't match `^[a-z0-9][a-z0-9-]*$`, a target that already exists, and a target whose parent directory doesn't exist.
2. Copies `template/` into a temporary directory next to the target.
3. Replaces `[project-name]`, `[Project Name]`, and `[YYYY-MM-DD]`, and replaces `[owner]` when you pass `--owner`. Replacement values are literal, so characters such as `&` and `|` come through unchanged.
4. Initializes one git repository on `master` with an initial commit, unless you pass `--no-git`.
5. Moves the project into place. If any step fails, the script removes the temporary directory and creates no target.
6. Prints every remaining placeholder with its file and line.

A placeholder is a bracketed token outside markdown links, task checkboxes, fenced code, inline code, and Keep a Changelog version headings such as `[Unreleased]`. The placeholders left after a run are the questions the owner answers, such as what v1 includes, the principles, the design vision, and the project's own rules.

## Grow a project

`template/PATHWAYS.md` lists files to add when a trigger occurs. For example, it suggests `DESIGN.md` when UI work starts, and `SECURITY.md` at the first internet-facing deployment, real users, or sensitive data. The copy in `template/` is canonical.

## Document authority in a project

`template/AGENTS.md` labels each file with its layer in the global `CLAUDE.md` authority table.

| Layer | Files | What a conflict means |
|---|---|---|
| Evergreen | `AGENTS.md`, `CLAUDE.md` (which only imports `AGENTS.md`), `PROJECT.md`, plus `DESIGN.md` or `ARCHITECTURE.md` once a pathway adds them | Work that contradicts one stops, and the agent asks the owner before going on. |
| Controlling | `ROADMAP.md`, and always the current prompt and what the owner agreed in the session | The latest agreement wins. If work contradicts the v1 scope or current milestone, the agent asks whether the roadmap is stale. |
| Controlling, once added | `DECISIONS.md`, after `AGENTS.md` names it as controlling, as its pathway says to | A later entry that names an earlier one replaces it. |
| Not promised | `BACKLOG.md` | None. It's a holding list, and an item gains authority only when it moves into `ROADMAP.md`. |
| Artifact | `docs/context/`, `docs/history.md`, and the specs and plans under `docs/versions/` | Down-weighted against controlling docs and used for the reasoning behind decisions. |
| No label | `README.md`, `CHANGELOG.md`, `PATHWAYS.md` | Reference only. None of them directs work. |

## Formal-v1

The formal-v1 scaffold lives in `archive/formal-v1/` and at the `formal-v1` tag. [`archive/README.md`](archive/README.md) explains how to bootstrap a formal-v1 workspace.
