# Agent Instructions — Workspace

## Layout

This workspace holds two independent repositories:

- `docs/`: product intent, decisions, specifications, plans, reviews, acceptance, and release records.
- `code/`: implementation, tests, technical design, front-end style guide, operations, and the code-side release manifest.

The workspace directory itself is not a repository. Each repository has its own `AGENTS.md`, which governs work inside it and takes precedence for that repository.

## Session location

Start sessions at the workspace root by default. The normal workflow crosses the boundary: a specification is accepted in `docs/`, implemented in `code/`, then status, changelog, and release records are updated in `docs/`. A root session keeps that context across the handoff.

Sessions started inside `docs/` or `code/` alone remain valid for focused work in one repository.

## Editing and committing

- Product intent is edited and committed in `docs/`. Implementation is edited and committed in `code/`.
- A task given at the workspace root authorizes edits in whichever repository the task names or requires. This satisfies each repository's "unless the task explicitly includes it" clause.
- Read across repositories freely. Every edit and every git operation targets one repository explicitly, for example `git -C code commit` or by running from inside that directory.
- Never combine changes to both repositories in one commit. Commit each repository separately and cite the same stable IDs in both.
- Do not run git commands against the workspace directory.

## Releasing

Do not create a release tag until `code/scripts/release-check.sh` passes and the judgment items in `docs/policies/RELEASE.md` are confirmed by a human.

## Before finishing

Report which repository each change was committed to, and which cross-repository follow-ups remain.
