# Pathways

Files to add as the project grows. These are unproven suggestions: the canonical copy lives in the scaffold repository, and starting material for several of them is in that repository's `archive/formal-v1/`.

| Trigger | Add | Used by |
|---|---|---|
| UI work starts | `DESIGN.md` | `front-end-design` |
| A second builder joins | `CONTRIBUTING.md`, a PR template, and a CI workflow | Collaborators, GitHub |
| First internet-facing deployment, real users, or sensitive data | `SECURITY.md`, and a security review before each release | GitHub (`SECURITY.md`), `web-security` (the review) |
| A release with rollback stakes | Version tags | `git-tagging` |
| A decision gets relitigated | `DECISIONS.md` | People and agents reading the project |
| An architectural choice needs its reasoning kept | `ARCHITECTURE.md` | `orko-review` |
| The code must be public and the documents private | A private parent git repository that holds the documents and ignores `code/`, with the code as a public repository in `code/`. Start sessions in the parent. If the code already has history, start fresh history and scan for secrets first. | GitHub |
