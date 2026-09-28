# Scripts

Store repeatable development, validation, build, migration, and release helpers here. `spec-check.sh` reports readiness gaps in a specification and its plan. `release-check.sh` is the mechanical release gate defined in the docs repository's `policies/RELEASE.md`. Scripts should fail safely, validate destructive targets, avoid embedded secrets, and document supported environments.
