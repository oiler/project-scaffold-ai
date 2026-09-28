# Archive

`formal-v1/` is the scaffold this repository shipped before the lean scaffold replaced it. It started every project as two repositories, `docs/` for the product record and `code/` for the software, connected by stable artifact IDs, controlled documents, and release gates. The [lean scaffold design](../docs/superpowers/specs/2026-09-27-lean-scaffold-design.md) explains why the lean scaffold replaced it.

Two tags preserve it:

| Tag | Points at |
|---|---|
| `formal-v1` | The last commit on `master` before the rebuild, with `project-name/` and its bootstrap script in place |
| `formal-v1-waivers` | The head of the unmerged `spec-release-gate-waivers` branch |

## Bootstrap a formal-v1 workspace

The bootstrap script on the current branch builds lean projects only. To build a formal-v1 workspace, run the script from the tag in a separate worktree:

```sh
git worktree add ../scaffold-formal-v1 formal-v1
../scaffold-formal-v1/scripts/new-project.sh <target-dir> <project-name> <organization> [--owner "<name>"] [--no-git]
```

## These files are material, not instructions

The `AGENTS.md` and `CLAUDE.md` files under `archive/` and `template/` are material for other projects. They don't apply to work in this repository, even when an agent loads them while reading nearby files.

Pathways in the lean scaffold's `PATHWAYS.md` point here for starting material, such as `formal-v1/code/SECURITY.md`, `formal-v1/code/CONTRIBUTING.md`, and `formal-v1/code/ARCHITECTURE.md`.
