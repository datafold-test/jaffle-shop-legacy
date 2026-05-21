# `legacy/` — Legacy Snowflake project

Source-of-truth for what's currently running in production on the legacy
warehouse `JAFFLE_LEGACY_DB.PUBLIC`. Treat these files as **read-only
inputs**: anything in this directory describes existing production
behavior; agents should not modify these files.

## File naming

Numeric prefixes encode the layer:

| Prefix | Layer | Output |
|---|---|---|
| `01_raw_*.sql` | Raw source-of-truth (DDL only). One legacy table per file. | `JAFFLE_LEGACY_DB.PUBLIC.RAW_*` |
| `10_stg_*.sql` | Staging (renames, type casts, cents → dollars). | `JAFFLE_LEGACY_DB.PUBLIC.STG_*` |
| `20_*.sql` | Mart aggregations and joins. | `JAFFLE_LEGACY_DB.PUBLIC.<MART_NAME>` |

Most files materialize one warehouse table. The exception is
`STG_SUPPLIES`, whose legacy build is split across
`10_stg_supplies_ddl.sql` (creates the table) and
`10_stg_supplies_dml.sql` (populates it). Both files participate in
producing the same `STG_SUPPLIES` target.

## Conventions in the legacy SQL

- Identifiers are UPPERCASE.
- Money columns are `INTEGER` cents (e.g. `SUBTOTAL`, `TAX_PAID`,
  `ORDER_TOTAL`, `PRICE`, `COST`). Look for `CAST(X AS NUMERIC(18,2)) / 100`
  patterns that convert cents to dollars.
- Date truncation uses `DATE_TRUNC('DAY', x)` (Snowflake-specific).
- Inter-table references are hard-coded fully-qualified names
  (`JAFFLE_LEGACY_DB.PUBLIC.*`).
- The legacy `CREATE OR REPLACE TABLE … AS SELECT` scripts stand in for
  cron'd ETL — there is no procedural code, every transform is a single
  `SELECT`.
