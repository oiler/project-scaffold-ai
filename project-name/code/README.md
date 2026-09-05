# [Project Name] — Software

This repository contains the implementation, tests, technical design, build material, and operational guidance for `[project-name]`.

Product documentation repository: `[organization/project-docs]`

## Development

<!-- Add prerequisites, setup, local run, test, lint, build, and troubleshooting commands. Commands must be safe to copy and reflect the supported environment. -->

## Repository layout

- `src/`: production source
- `tests/`: automated and manual verification support
- `docs/architecture/`: current technical architecture
- `docs/adr/`: historical technical decisions
- `docs/operations/`: deployment, observability, recovery, and support
- `release/`: code-side release linkage
- `dist/`: generated distributable output, subject to the policy documented in `DESIGN.md`

## Product traceability

Behavioral work should cite stable IDs from the docs repository. Release tags use `vMAJOR.MINOR.PATCH`; each release manifest locks the product version and documentation baseline used for the build.
