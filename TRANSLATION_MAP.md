# Translation Map: legacy → dbt

This file is context for goals that translate the legacy Snowflake
project under `legacy/` into the dbt project under `dbt_scaffold/`. It
documents the asset-level correspondence: which legacy table maps to
which dbt model, and which target warehouse table the dbt model
produces.

For dbt-side conventions (macros, identifier casing, `ref()`/`source()`
patterns), see [`dbt_scaffold/AGENTS.md`](./dbt_scaffold/AGENTS.md).
For legacy-side conventions (file prefixes, money-in-cents, etc.), see
[`legacy/AGENTS.md`](./legacy/AGENTS.md).

## Asset mapping

The legacy warehouse table on the left is the *real* asset (the table
the production system maintains today). The dbt file in the middle is
the file that will be authored under `dbt_scaffold/models/…`. The
target warehouse table on the right is what `dbt build` materializes.

| Legacy script | Legacy warehouse table | dbt file | Target warehouse table |
|---|---|---|---|
| `legacy/01_raw_*.sql` (DDL only) | `JAFFLE_SHOP.RAW.RAW_*` (source — declared in `__sources.yml`) | *(none — sources, not models)* | *(none — source-only)* |
| `legacy/10_stg_customers.sql` | `JAFFLE_SHOP.STAGING.STG_CUSTOMERS` | `models/staging/stg_customers.sql` | `JAFFLE_SHOP.STAGING.STG_CUSTOMERS` |
| `legacy/10_stg_orders.sql` | `JAFFLE_SHOP.STAGING.STG_ORDERS` | `models/staging/stg_orders.sql` | `JAFFLE_SHOP.STAGING.STG_ORDERS` |
| `legacy/10_stg_order_items.sql` | `JAFFLE_SHOP.STAGING.STG_ORDER_ITEMS` | `models/staging/stg_order_items.sql` | `JAFFLE_SHOP.STAGING.STG_ORDER_ITEMS` |
| `legacy/10_stg_products.sql` | `JAFFLE_SHOP.STAGING.STG_PRODUCTS` | `models/staging/stg_products.sql` | `JAFFLE_SHOP.STAGING.STG_PRODUCTS` |
| `legacy/10_stg_supplies_ddl.sql` + `legacy/10_stg_supplies_dml.sql` (DDL+DML pair) | `JAFFLE_SHOP.STAGING.STG_SUPPLIES` | `models/staging/stg_supplies.sql` (single model) | `JAFFLE_SHOP.STAGING.STG_SUPPLIES` |
| `legacy/20_order_items_enriched.sql` | `JAFFLE_SHOP.MARTS.ORDER_ITEMS` | `models/marts/order_items.sql` | `JAFFLE_SHOP.MARTS.ORDER_ITEMS` |
| `legacy/20_orders_summary.sql` | `JAFFLE_SHOP.MARTS.ORDERS` | `models/marts/orders.sql` | `JAFFLE_SHOP.MARTS.ORDERS` |
| `legacy/20_customers_summary.sql` | `JAFFLE_SHOP.MARTS.CUSTOMERS` | `models/marts/customers.sql` | `JAFFLE_SHOP.MARTS.CUSTOMERS` |

Notes on the table:

- **`01_raw_*` files are sources, not models** — they're declared in
  `dbt_scaffold/models/staging/__sources.yml` and referenced via
  `{{ source('jaffle_raw', '…') }}`. They produce no dbt file.
- **Mart files are renamed**: `ORDER_ITEMS_ENRICHED → order_items`,
  `ORDERS_SUMMARY → orders`, `CUSTOMERS_SUMMARY → customers`. Drop the
  `_ENRICHED` / `_SUMMARY` suffix.
- **`STG_SUPPLIES` is a DDL+DML pair**: the legacy system splits
  table-creation and table-population into two files; dbt combines them
  in one model.

## Validation contract

Per translated model, the standard of correctness is **semantic
equivalence with the legacy table**:

- Run a row-level data-diff between the legacy table and the dbt-built
  table on the same Snowflake account.
- **Pass**: 0 differing rows on business columns.
- **Warn (not fail)**: differences only in audit columns. Anything
  ending in `_CENTS` is kept on the dbt side for parity but is not
  business-significant.
- **Fail**: any business-column difference.

The validation runs after `dbt build` materializes the target table.
Validation is per-model, not project-wide — finish translating and
validating one model before moving to the next.
