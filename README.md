# AI-Assisted Product Development Workspace

This workspace is a reusable foundation for building software with AI while preserving a clear connection between product intent and implementation.

It is organized around two separate repositories:

- `docs/` contains the product record: objectives, research, roadmap, decisions, specifications, delivery plans, reviews, acceptance evidence, and release history.
- `code/` contains the software record: source code, tests, technical design, architecture decisions, front-end style guide, operational guidance, and build artifacts.

The separation is intentional. Product documentation and software often have different contributors, review requirements, release cycles, and access controls. Keeping them independent allows each repository to evolve under the governance appropriate to it without losing traceability between them.

Stable artifact IDs and release manifests connect the repositories. A release can be traced from its original evidence and product decisions through its specification, implementation plan, code revision, verification, and final acceptance. Immutable commit references preserve the exact documentation and code baselines associated with each release.

The included files provide default rules, boundaries, templates, and inline guidance for both human collaborators and AI agents. They are designed to make project state explicit, distinguish facts from assumptions, prevent requirements from being silently rewritten, and reduce the need for a new contributor or agent to reconstruct context from the entire project history.

This workspace is a starting point rather than a prescribed development process. Each project should adapt its delivery profile, required artifacts, approval rules, and operational practices to its complexity and risk. Small fixes may waive unnecessary artifacts with an explicit reason, while high-risk work may require additional security, privacy, migration, or acceptance review.

## Layout

- `project-name/`: the scaffold. Copy it; never edit it in place for a project. Its root holds a workspace-level `AGENTS.md` that routes work between `docs/` and `code/`; the workspace directory is not itself a repository.
- `scripts/new-project.sh`: deterministic bootstrap for a new workspace.

`AGENTS.md` is authoritative at each level. `CLAUDE.md` imports it and adds nothing else; the workspace `CLAUDE.md` imports all three.

## Placeholder convention

Every value a project must supply is written as a bracketed token, for example `[project-name]`, `[owner]`, `[YYYY-MM-DD]`. Bracketed tokens are the only use of square brackets outside markdown links and task checkboxes, so a leftover can always be found with:

```sh
grep -rnoE '\[[^]]+\]' . | grep -vE '\]\(|\[ \]|\[x\]'
```

Pattern descriptions such as `versions/MAJOR.MINOR/` in prose are not placeholders and are left unbracketed.

## Starting a project

Run the bootstrap script from this directory:

```sh
scripts/new-project.sh ~/files/repo/my-app my-app my-org --owner "Justen"
```

The script:

1. Copies `project-name/` to the target directory and strips macOS metadata.
2. Replaces the identity placeholders: project name, organization, repository references, owner (if given), and today's date for `[YYYY-MM-DD]`.
3. Initializes `docs/` and `code/` as independent git repositories on `master` with an initial commit. Pass `--no-git` to skip.
4. Prints every remaining bracketed placeholder so nothing is missed.

Then, in the new workspace. Start sessions at the workspace root so one session carries context from specification through implementation to release records; sessions inside `docs/` or `code/` alone are fine for focused work.

1. Define the durable product purpose in `docs/OBJECTIVE.md`.
2. Resolve the placeholders the script listed. Owners and dates are safe to fill immediately; scope, outcomes, and requirements need real product input.
3. Rename `docs/versions/0.1/` if the first planned minor version is different.
4. Declare the delivery profile and any waived artifacts in the version README.
5. Add hosting remotes and rename `CODEOWNERS.example` to `CODEOWNERS` in each repository when the platform supports it.
6. Create or accept specifications before implementation begins.
7. Keep product decisions in `docs/decisions/` and technical decisions in `code/docs/adr/`.
8. At release time, create a docs release record and a code release manifest that reference immutable commits and the same specification IDs.

The scaffold itself contains no `.git` directories inside `project-name/` and no CI automation. Enforcement is by review discipline; add protected branches and tags on the hosting platform.
