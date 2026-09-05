# Traceability Policy

Use stable IDs so product intent can be traced without copying entire documents:

`research → decision → specification → plan → code review → test/acceptance → release`

## Identifier conventions

| Artifact | Example |
| --- | --- |
| Product decision | `DEC-001` |
| Specification | `SPEC-001` |
| Delivery plan | `PLAN-001` |
| Review | `REVIEW-001` |
| Acceptance record | `ACCEPT-001` |
| Fix record | `FIX-001` |
| Technical decision | `ADR-001` |

IDs are never reused. Renaming a title does not change its ID.

## Expected references

- Specifications cite relevant evidence and decisions.
- Plans identify every implemented specification and map requirements to verification.
- Code branches, pull requests, or change descriptions cite relevant IDs.
- Acceptance records map results to requirement IDs.
- Release records list included specifications, fixes, acceptance records, code tag, and immutable commits.

Git already records individual commits. Product release records should identify the final tagged commit rather than duplicate the entire commit history.
