# Jaffle Shop Legacy

Test-bed repository for translating a legacy Snowflake project (plain SQL
`CREATE OR REPLACE TABLE … AS SELECT` scripts) into an idiomatic dbt
project on the same Snowflake account.

## What's in this repo

Everything lives in the single `JAFFLE_SHOP` Snowflake database, split into
schemas:

- `JAFFLE_SHOP.RAW.*` — shared raw source tables (Fivetran-managed; the same
  rows feed legacy and dbt).
- `JAFFLE_SHOP.LEGACY_PUBLIC.*` — legacy materialization target (where the
  `legacy/*.sql` scripts write).
- `JAFFLE_SHOP.STAGING.*` (views) + `JAFFLE_SHOP.MARTS.*` (tables) — dbt
  materialization target.

- `legacy/` — the legacy Snowflake project: 14 SQL files that read from
  the shared `JAFFLE_SHOP.RAW.*` sources and materialize into
  `JAFFLE_SHOP.LEGACY_PUBLIC.*`. This directory is the source-of-truth for
  what runs today; the files are inputs to the translation, not outputs.
  See [`legacy/AGENTS.md`](./legacy/AGENTS.md) for naming conventions and
  per-file metadata.

- `dbt_scaffold/` — the target dbt project. Pre-wired with
  `dbt_project.yml`, `profiles.yml`, `packages.yml`, the
  `cents_to_dollars` macro, and `models/staging/__sources.yml`.
  Translated models land under `models/staging/` (views) and
  `models/marts/` (tables) and materialize into `JAFFLE_SHOP.STAGING.*`
  and `JAFFLE_SHOP.MARTS.*`. See [`dbt_scaffold/AGENTS.md`](./dbt_scaffold/AGENTS.md)
  for project structure and the conventions translated SQL must follow.

Goal-specific instructions (what to build, what to verify, how to
decompose work) live in the goal's initial task — not here.
