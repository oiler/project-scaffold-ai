# Project Scaffold

This workspace contains two independent repository candidates:

- `docs/` holds product intent, evidence, decisions, specifications, plans, reviews, acceptance records, and release records.
- `code/` holds implementation, tests, technical design, operational guidance, and the code-side release manifest.

The scaffold contains no `.git` directories. When starting a project, rename this directory, replace bracketed placeholders, and initialize `docs/` and `code/` independently if version control is desired.

## Starting a project

1. Define the durable product purpose in `docs/OBJECTIVE.md`.
2. Replace `[project-name]`, repository references, owners, and dates.
3. Rename `docs/versions/0.1/` if the first planned minor version is different.
4. Declare the delivery profile and any waived artifacts in the version README.
5. Create or accept specifications before implementation begins.
6. Keep product decisions in `docs/decisions/` and technical decisions in `code/docs/adr/`.
7. At release time, create a docs release record and a code release manifest that reference immutable commits and the same specification IDs.

`AGENTS.md` is authoritative in each repository. `CLAUDE.md` exists only as a compatibility pointer.
