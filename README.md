# AI-Assisted Product Development Workspace

This workspace is a reusable foundation for building software with AI while preserving a clear connection between product intent and implementation.

It is organized around two separate repositories:

- `docs/` contains the product record: objectives, research, roadmap, decisions, specifications, delivery plans, reviews, acceptance evidence, and release history.
- `code/` contains the software record: source code, tests, technical design, architecture decisions, operational guidance, and build artifacts.

The separation is intentional. Product documentation and software often have different contributors, review requirements, release cycles, and access controls. Keeping them independent allows each repository to evolve under the governance appropriate to it without losing traceability between them.

Stable artifact IDs and release manifests connect the repositories. A release can be traced from its original evidence and product decisions through its specification, implementation plan, code revision, verification, and final acceptance. Immutable commit references preserve the exact documentation and code baselines associated with each release.

The included files provide default rules, boundaries, templates, and inline guidance for both human collaborators and AI agents. They are designed to make project state explicit, distinguish facts from assumptions, prevent requirements from being silently rewritten, and reduce the need for a new contributor or agent to reconstruct context from the entire project history.

This workspace is a starting point rather than a prescribed development process. Each project should adapt its delivery profile, required artifacts, approval rules, and operational practices to its complexity and risk. Small fixes may waive unnecessary artifacts with an explicit reason, while high-risk work may require additional security, privacy, migration, or acceptance review.

The scaffold contains no Git metadata or automation. The `docs/` and `code/` directories can be initialized, hosted, and governed independently when the project begins.