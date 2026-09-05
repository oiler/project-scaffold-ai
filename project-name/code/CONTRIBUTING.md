# Contributing

## Prerequisites and setup

<!-- List supported runtimes, package managers, external services, and exact setup commands. -->

## Change workflow

1. Identify the product artifact or technical decision that authorizes the change.
2. Use a focused branch or change set and preserve relevant stable IDs.
3. Add or update tests with the implementation.
4. Run the project validation commands below.
5. Explain behavior changes, risks, migrations, rollback, and documentation follow-up in review.

## Validation commands

<!-- Replace placeholders. Do not leave misleading commands that appear operational. -->

| Check | Command | Required for |
| --- | --- | --- |
| Tests | `[define command]` | All behavioral changes |
| Static analysis | `[define command]` | All source changes |
| Formatting | `[define command]` | All source changes |
| Build | `[define command]` | Release candidates |

## Review expectations

<!-- Define reviewers, evidence, change-size expectations, and high-risk approval requirements. -->

## Commit and change descriptions

Reference stable IDs where relevant, for example `SPEC-014: add scheduled synchronization`. Pull requests or equivalent reviews are the preferred traceability unit; Git retains individual commit history.
