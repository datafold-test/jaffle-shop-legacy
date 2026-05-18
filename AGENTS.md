# Jaffle Shop — Snowflake → dbt translation

This repo is a test bed for translating a legacy Snowflake project (plain
SQL `CREATE TABLE … AS SELECT` scripts) into an idiomatic dbt project on
the same Snowflake account. Inspired by the
[jaffle-shop-sergeyk](https://github.com/datafold-test/jaffle-shop-sergeyk)
reference repo — the desired end-state for the translated project
mirrors that structure.

## Source vs target

- **Source warehouse**: `JAFFLE_LEGACY_DB.PUBLIC` on Snowflake. Raw tables
  (`RAW_*`) and derived tables (`STG_*`, `ORDER_ITEMS_ENRICHED`,
  `ORDERS_SUMMARY`, `CUSTOMERS_SUMMARY`) all live there. The scripts under
  `legacy/` are the source-of-truth for what's running today.
- **Target warehouse**: `JAFFLE_DBT_DB` on the same Snowflake account.
  The dbt project will materialize:
  - staging models as **views** in `JAFFLE_DBT_DB.STAGING`
  - mart models as **tables** in `JAFFLE_DBT_DB.MARTS`
- **Same Snowflake account, separate databases.** No cross-account moves.

## File layout for the translation

Translated dbt files go under `dbt_scaffold/` — that's the dbt project
root. **Mirror the jaffle-shop convention exactly**:

```
dbt_scaffold/
├── dbt_project.yml          # already in place; do not rewrite
├── profiles.yml             # already in place; do not rewrite
├── packages.yml             # already in place; do not rewrite
├── macros/
│   └── cents_to_dollars.sql # use this macro for cents→dollars conversions
├── models/
│   ├── staging/
│   │   ├── __sources.yml    # already declares source('jaffle_raw', '...')
│   │   ├── stg_<entity>.sql # one per legacy/10_stg_*.sql script
│   │   └── stg_<entity>.yml # column docs + tests
│   └── marts/
│       ├── <entity>.sql     # one per legacy/20_*.sql script
│       └── <entity>.yml     # column docs + tests
└── seeds/                   # leave empty for now; raw tables come from the source DB
```

## Per-file translation rules

The `legacy/` directory uses numeric prefixes to indicate the layer. Each
legacy `.sql` script materializes ONE legacy warehouse table; the
translated dbt model materializes ONE target warehouse table:

| Prefix | Legacy script | Legacy warehouse table (the *real* asset) | dbt file produced | Target warehouse table (the dbt-built asset) |
|---|---|---|---|---|
| `01_raw_*.sql` | DDL — **DO NOT translate** | source — declared in `__sources.yml` | (none) | (none — source-only) |
| `10_stg_customers.sql` | rename | `JAFFLE_LEGACY_DB.PUBLIC.STG_CUSTOMERS` | `models/staging/stg_customers.sql` | `JAFFLE_DBT_DB.STAGING.STG_CUSTOMERS` |
| `10_stg_orders.sql` | rename + macro | `JAFFLE_LEGACY_DB.PUBLIC.STG_ORDERS` | `models/staging/stg_orders.sql` | `JAFFLE_DBT_DB.STAGING.STG_ORDERS` |
| `10_stg_order_items.sql` | rename | `JAFFLE_LEGACY_DB.PUBLIC.STG_ORDER_ITEMS` | `models/staging/stg_order_items.sql` | `JAFFLE_DBT_DB.STAGING.STG_ORDER_ITEMS` |
| `10_stg_products.sql` | rename + flags | `JAFFLE_LEGACY_DB.PUBLIC.STG_PRODUCTS` | `models/staging/stg_products.sql` | `JAFFLE_DBT_DB.STAGING.STG_PRODUCTS` |
| `10_stg_supplies.sql` | rename + cents | `JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES` | `models/staging/stg_supplies.sql` | `JAFFLE_DBT_DB.STAGING.STG_SUPPLIES` |
| `20_order_items_enriched.sql` | mart join | `JAFFLE_LEGACY_DB.PUBLIC.ORDER_ITEMS_ENRICHED` | `models/marts/order_items.sql` | `JAFFLE_DBT_DB.MARTS.ORDER_ITEMS` |
| `20_orders_summary.sql` | mart agg | `JAFFLE_LEGACY_DB.PUBLIC.ORDERS_SUMMARY` | `models/marts/orders.sql` | `JAFFLE_DBT_DB.MARTS.ORDERS` |
| `20_customers_summary.sql` | mart agg | `JAFFLE_LEGACY_DB.PUBLIC.CUSTOMERS_SUMMARY` | `models/marts/customers.sql` | `JAFFLE_DBT_DB.MARTS.CUSTOMERS` |

> **CRITICAL — asset paths vs file paths.** The MAPS_TO edges + migration
> artifacts (see "Done definition" below) describe the **warehouse table
> assets**, not the `.sql` files. When you fill `legacy_paths` and
> `asset_path`, use the database FQN tuples from the *Legacy warehouse
> table* and *Target warehouse table* columns above. **Never** put
> `("legacy", "10_stg_orders.sql")` or `("dbt_scaffold", "models",
> "staging", "stg_orders.sql")` into an artifact — those are file paths,
> not data assets, and they produce graph nodes that no consumer can
> resolve. The mart-layer files participate in the same rule: e.g.
> `legacy/20_orders_summary.sql` produces the table
> `JAFFLE_LEGACY_DB.PUBLIC.ORDERS_SUMMARY`, and the dbt model
> `models/marts/orders.sql` produces the table
> `JAFFLE_DBT_DB.MARTS.ORDERS`. Those two FQNs are what the MAPS_TO edge
> connects.

Inside each translated `.sql` file:

- Use the jaffle-shop CTE idiom: `with source as (...), renamed as (...) select * from renamed`. For marts, name CTEs after the role they play (`order_items_summary`, `customer_orders_summary`, etc. — see the reference repo for examples).
- **Lowercase** every identifier and keyword. The legacy SQL is UPPERCASE-heavy; the dbt project standard is lowercase.
- Replace inter-table references with `{{ ref('…') }}` for stg/mart models and `{{ source('jaffle_raw', '…') }}` for raw tables. Never hard-code `JAFFLE_LEGACY_DB.PUBLIC.*` in the dbt models.
- Replace ad-hoc cents→dollars division (`CAST(X AS NUMERIC(18,2)) / 100`) with the existing macro: `{{ cents_to_dollars('x') }}`.
- Replace `DATE_TRUNC('DAY', x)` with `{{ dbt.date_trunc('day', 'x') }}` so the project stays portable.

## Validation

For every translated model, validate semantic equivalence with a row-level
data-diff between the legacy table and the dbt-built table:

| Legacy table | dbt model |
|---|---|
| `JAFFLE_LEGACY_DB.PUBLIC.STG_CUSTOMERS` | `JAFFLE_DBT_DB.STAGING.STG_CUSTOMERS` |
| `JAFFLE_LEGACY_DB.PUBLIC.STG_ORDERS` | `JAFFLE_DBT_DB.STAGING.STG_ORDERS` |
| `JAFFLE_LEGACY_DB.PUBLIC.STG_ORDER_ITEMS` | `JAFFLE_DBT_DB.STAGING.STG_ORDER_ITEMS` |
| `JAFFLE_LEGACY_DB.PUBLIC.STG_PRODUCTS` | `JAFFLE_DBT_DB.STAGING.STG_PRODUCTS` |
| `JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES` | `JAFFLE_DBT_DB.STAGING.STG_SUPPLIES` |
| `JAFFLE_LEGACY_DB.PUBLIC.ORDER_ITEMS_ENRICHED` | `JAFFLE_DBT_DB.MARTS.ORDER_ITEMS` |
| `JAFFLE_LEGACY_DB.PUBLIC.ORDERS_SUMMARY` | `JAFFLE_DBT_DB.MARTS.ORDERS` |
| `JAFFLE_LEGACY_DB.PUBLIC.CUSTOMERS_SUMMARY` | `JAFFLE_DBT_DB.MARTS.CUSTOMERS` |

Acceptance criteria: every pair returns 0 differing rows on the business
columns. Audit columns (anything ending in `_CENTS`) are kept on the dbt
side for parity but are NOT business-significant — flag those as `warn`
rather than `fail` if they diverge.

## Conventions

- **Snake-case** identifiers everywhere in the dbt project (`customer_id`, `ordered_at`).
- **Schema mapping**: legacy `PUBLIC` schema splits into dbt `STAGING` (views) and `MARTS` (tables).
- **No procedural code**: every transform is a single `SELECT`. The legacy `CREATE OR REPLACE TABLE` scripts are stand-ins for cron'd ETL — the dbt rewrites are pure transforms.
- **One model per legacy table.** Do not merge or split. Many-to-many split-or-merge cases can be revisited later, but for this first pass keep it 1-to-1 at the staging layer.
- The marts layer renames are intentional: `legacy/ORDER_ITEMS_ENRICHED → models/marts/order_items.sql`, `legacy/ORDERS_SUMMARY → models/marts/orders.sql`, `legacy/CUSTOMERS_SUMMARY → models/marts/customers.sql`. See the table above for the full map.

## What NOT to do

- Don't translate `legacy/01_raw_*.sql` — those define dbt **sources**, not models.
- Don't add new seed CSVs. The raw tables are already populated in the legacy DB; sources point at them directly.
- Don't change `dbt_project.yml`, `profiles.yml`, `packages.yml`, or `models/staging/__sources.yml`. They're pre-wired.
- Don't introduce snapshot or seed logic for this first migration pass.

## Done definition for one translated model

1. New `.sql` file at the correct `dbt_scaffold/models/{staging,marts}/` path.
2. Matching `.yml` file declaring columns + at least one `not_null` / `unique` test on the primary key.
3. `dbt build --select <model>` runs clean.
4. Row-level data-diff against the legacy counterpart returns 0 differing rows on business columns.
5. A migration artifact is attached to the ticket with the warehouse FQN tuples (NOT file paths). For staging tickets, that's `legacy_paths=[("JAFFLE_LEGACY_DB", "PUBLIC", "STG_<NAME>")]` and `asset_path=("JAFFLE_DBT_DB", "STAGING", "STG_<NAME>")`. For mart tickets, the legacy table is `JAFFLE_LEGACY_DB.PUBLIC.<UPPERCASE_NAME>` and the target is `JAFFLE_DBT_DB.MARTS.<UPPERCASE_NAME>` (see the table above for the exact mapping). `target_kind="dataset"`. Validation entry should be `data_diff` citing the diff ID; when data sources aren't configured for the goal, fall back to `manual` with a brief `notes` line explaining the validation gap.

## Ticket-framing guidance for the Lead

When you (the Lead) create developer tickets from this AGENTS.md, **title
and describe them in terms of the warehouse table assets**, not the
`.sql` filenames. Use the *Legacy warehouse table* and *Target warehouse
table* columns in the per-file table above. For example:

- Good: *"Translate `JAFFLE_LEGACY_DB.PUBLIC.STG_ORDERS` → `JAFFLE_DBT_DB.STAGING.STG_ORDERS`"*
- Bad: *"Translate `legacy/10_stg_orders.sql` → `dbt_scaffold/models/staging/stg_orders.sql`"*

The implementation file paths still go in the description as a pointer
(*"implemented by writing `dbt_scaffold/models/staging/stg_orders.sql` from
`legacy/10_stg_orders.sql`"*), but they are secondary. Frame everything
the developer + reviewer touch downstream around the warehouse FQNs so
the migration artifact comes out correctly — see "Done definition"
above.
