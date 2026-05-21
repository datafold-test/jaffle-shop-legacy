# Jaffle Shop Legacy

Test-bed repository for translating a legacy Snowflake project (plain SQL
`CREATE OR REPLACE TABLE … AS SELECT` scripts) into an idiomatic dbt
project on the same Snowflake account.

## What's in this repo

- `legacy/` — the legacy Snowflake project: 14 SQL files that materialize
  the current production tables under `JAFFLE_LEGACY_DB.PUBLIC.*`. This
  directory is the source-of-truth for what runs today; the files are
  inputs to the translation, not outputs. See [`legacy/AGENTS.md`](./legacy/AGENTS.md)
  for naming conventions and per-file metadata.

- `dbt_scaffold/` — the target dbt project. Pre-wired with
  `dbt_project.yml`, `profiles.yml`, `packages.yml`, the
  `cents_to_dollars` macro, and `models/staging/__sources.yml`.
  Translated models land under `models/staging/` (views) and
  `models/marts/` (tables) and materialize into `JAFFLE_DBT_DB.STAGING.*`
  and `JAFFLE_DBT_DB.MARTS.*`. See [`dbt_scaffold/AGENTS.md`](./dbt_scaffold/AGENTS.md)
  for project structure and the conventions translated SQL must follow.

## Working in this repo

If your goal involves translating legacy SQL to dbt models:
[`TRANSLATION_MAP.md`](./TRANSLATION_MAP.md) carries the per-file
legacy → target mapping (which legacy script becomes which dbt model and
which target table), plus the validation contract.

Goal-specific instructions (what to build, what to verify, how to
decompose work) live in the goal's initial task — not here.
