---
id: SPEC-001
title: "Release gate honors recorded artifact waivers"
status: draft
product_version: "scaffold"
owner: "Justen"
approved_at: null
supersedes: null
---

# SPEC-001 — Release gate honors recorded artifact waivers

## Problem and intended outcome

`policies/RELEASE.md` says a version may waive artifacts and record each waiver in the version README with a reason and approver. `scripts/release-check.sh` does not read those waivers, so a version that legitimately waived the acceptance record can never pass the gate. The first project to adopt the gate, vegas 0.1, hit this on day one: its README waives the acceptance record for the import baseline, and the gate fails on exactly that check.

The outcome: a waiver recorded correctly in the version README is enough for the gate to pass the corresponding check, visibly, without editing the script or fabricating the artifact. Waivers that are incomplete or name something the gate does not recognize fail the gate rather than silently passing.

## Users and scenarios

- **Release owner** running `release-check.sh` before tagging a `quick-fix` version whose README waives the acceptance record. Expects the gate to report the waiver and pass.
- **Reviewer** reading the gate output in a release review. Expects every waived check to be visible with reason, approver, and date so the judgment item "every waiver has a reason a future reader will accept" can be confirmed from the output alone.
- **Agent** preparing a release. Must not be able to add a waiver row to clear the gate without a human name and date on it.

## Evidence and classification

Verified facts, checked 2026-09-06:

- vegas `docs/versions/0.1/README.md` waives delivery plan, implementation review, and acceptance record, each with reason, approver, and date.
- `release-check.sh 0.1.0` in vegas fails with `no acceptance record with candidate_tag v0.1.0`. The delivery-plan waiver has no gate effect because `spec-check.sh` only warns on a missing plan.
- `RELEASE.md` item 10 and `policies/README.md` both describe waivers as a supported mechanism.

Product decision: waivers are read from the version README, not from a flag or a separate file. The README is already the declared home for them, and a flag would let a waiver be applied without being recorded.

Assumption: the `### Waivers` table format in the version README template is stable enough to parse. If the template changes, the parser and this spec change together.

## Scope

- `release-check.sh` reads the `### Waivers` table from `docs/versions/MAJOR.MINOR/README.md`.
- Waivable checks and the artifact name that waives each.
- Validation of waiver rows.
- Output format for waived checks.
- Placeholder rows are ignored.

## Non-goals

- Waiving the specification acceptance check. A draft specification is never releasable; the README waiver mechanism must not be able to clear it.
- Waiving the release record, manifest, changelog, STATUS, clean-tree, or tag checks. These are the release itself, not supporting artifacts.
- Waivers in `spec-check.sh`. Its plan check is already advisory.
- Expiring or per-release waivers. A waiver applies to the whole minor version, matching the README's scope.
- Reading waivers from anywhere other than the version README.

## Requirements

### R1 — Recognized artifact names

The gate recognizes exactly these `Artifact` values, matched case-insensitively after trimming: `Acceptance record`, `Implementation review`, `Delivery plan`. Only `Acceptance record` maps to a gate check today; the other two are accepted so that a README waiver the policy already allows does not fail R3. The gate prints the recognized list when it rejects a name.

### R2 — Waived acceptance record

Given the version README waives `Acceptance record` with a valid row, when the gate runs and no acceptance record with the candidate tag exists, then the acceptance checks are reported as waived and do not count as failures. If an acceptance record for the candidate tag does exist, the waiver is ignored and the record is checked normally.

### R3 — Waiver rows must be complete

A waiver row whose `Reason`, `Approved by`, or `Date` cell is empty, or whose `Date` is not `YYYY-MM-DD`, or whose `Artifact` is not recognized under R1, fails the gate with a message naming the row. A row whose `Artifact` cell is the template placeholder `[None]` is ignored.

### R4 — Waivers are visible in output

Each applied waiver is printed on its own line in the form `waive <check>: <reason> (<approver>, <date>)`, in the same position the `ok` or `FAIL` line for that check would have appeared. The final line reads `READY to tag vX.Y.Z with N waiver(s)` when N is greater than zero.

### R5 — Release record when acceptance is waived

Given `Acceptance record` is waived, when the gate checks the docs release record, then an empty `acceptance_records` list is not a failure, and the record must contain at least one entry under `accepted_risks`. A waived acceptance is an accepted risk and the release record is where releases carry those.

### R6 — Missing or unparseable waiver table

If the version README has no `### Waivers` heading, or the table under it has no rows, the gate behaves exactly as it does today. A malformed table that has rows but not the four expected columns fails the gate with a message pointing at the README.

## Failure and recovery behavior

- Unrecognized artifact name: gate fails, prints the row and the recognized names. Fix the row or remove it.
- Incomplete row: gate fails, prints the row. Fix the row.
- Waiver present but the artifact also exists: artifact is checked, waiver line is not printed. No error; a stale waiver row is a documentation nit for the release review.
- README missing entirely: existing behavior, `STATUS.md` and dossier checks already fail.

## Data, privacy, security, and accessibility

No data beyond the README already in the repository. The approver name is already public in the README. Output is plain text on stdout, same as today.

Threat: an agent adds a waiver row to clear the gate. Mitigation: R3 requires a human name and date, and R4 makes every waiver visible in the output the reviewer reads. The judgment items in `RELEASE.md` remain the actual control; the gate makes evasion visible, not impossible.

## Compatibility and migration

- Versions with no waivers see no change in output or exit status.
- Versions with the template placeholder row `[None]` see no change.
- vegas 0.1 can pass the gate after adding one `accepted_risks` entry to its release record. No script flag, no README edit.
- Rollback: revert the script. Waiver rows in READMEs are harmless documentation without it.

## Acceptance criteria

- Given a version README with a complete `Acceptance record` waiver row and no ACCEPT record, when `release-check.sh` runs with every other check passing, then it prints a `waive` line for the acceptance check, prints `READY to tag vX.Y.Z with 1 waiver(s)`, and exits 0.
- Given the same README and an ACCEPT record for the candidate tag, when the gate runs, then the ACCEPT record is checked normally and no `waive` line is printed.
- Given a waiver row with an empty `Approved by` cell, when the gate runs, then it prints a `FAIL` naming that row and exits 1.
- Given a waiver row naming `Specification`, when the gate runs, then it fails, prints the recognized names, and exits 1.
- Given a README with only the `[None]` placeholder row, when the gate runs, then output and exit status are identical to the current script.
- Given `Acceptance record` is waived and the release record has `accepted_risks: []`, when the gate runs, then it fails on the release record with a message naming `accepted_risks`.
- Given `Acceptance record` is waived and the release record lists one accepted risk and no acceptance records, when the gate runs, then the release record check passes.

## Measures

None. The gate either passes or fails; the measure is that vegas 0.1 reaches READY without a fabricated acceptance record.

## Dependencies, risks, and open questions

- Depends on the version README template keeping the four-column `### Waivers` table. Owner: Justen.
- Risk: parsing a markdown table in `sed`/`awk` is brittle if a reason cell contains a pipe. Mitigation: state in the template that reason cells must not contain `|`, or accept `\|` escaping. Decide at implementation.
- Open question: `spec-check.sh` prints `READY` for a `draft` spec because status is a warning. Separate from waivers, but the same reviewer will read both outputs. Proposed: print `READY (draft)` or `NOT ACCEPTED` so the summary line cannot be mistaken for release readiness. Owner: Justen.
- Open question: should `Implementation review` waive anything once a review check exists in the gate? Not today; recorded so the name is reserved.

## Amendments

None.
