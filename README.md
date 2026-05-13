# jaffle-shop-legacy

A test bed for Thunderbolt's Snowflake → dbt SQL translation. Contains:

- **`legacy/`** — raw Snowflake DDL + `CREATE OR REPLACE TABLE … AS SELECT`
  scripts that represent the current state of the warehouse.
- **`dbt_scaffold/`** — a pre-configured dbt project skeleton. Translated
  models drop into `dbt_scaffold/models/{staging,marts}/`.
- **`AGENTS.md`** — translation rules and the legacy→dbt file map. Agents
  working in this repo should read it first.

The end-state mirrors the upstream
[jaffle-shop](https://github.com/datafold-test/jaffle-shop-sergeyk)
reference, scoped down to a focused subset (customers, orders, order
items, products, supplies).
