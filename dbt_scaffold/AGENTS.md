# `dbt_scaffold/` — Target dbt project

This is the dbt project the translated SQL lands in. Materializes to
`JAFFLE_SHOP.STAGING.*` (views) and `JAFFLE_SHOP.MARTS.*` (tables),
reading from the shared `JAFFLE_SHOP.RAW.*` sources. The legacy
project (`../legacy/`) writes to `JAFFLE_SHOP.LEGACY_PUBLIC.*` from the
same shared raw schema.

## Layout

```
dbt_scaffold/
├── dbt_project.yml          # pre-wired; do not rewrite
├── profiles.yml             # pre-wired; do not rewrite
├── packages.yml             # pre-wired; do not rewrite
├── .gitignore               # excludes target/, logs/, dbt_packages/, .user.yml
├── macros/
│   └── cents_to_dollars.sql # macro used by every cent → dollar conversion
└── models/
    ├── staging/
    │   ├── __sources.yml    # pre-wired; declares `source('jaffle_raw', '...')` entries
    │   ├── stg_<entity>.sql # staging models (materialize as views in JAFFLE_SHOP.STAGING)
    │   └── stg_<entity>.yml # column docs + tests
    └── marts/
        ├── <entity>.sql     # mart models (materialize as tables in JAFFLE_SHOP.MARTS)
        └── <entity>.yml     # column docs + tests
```

`seeds/`, `snapshots/`, `analyses/`, `data-tests/` are scaffolded
empty — leave them empty unless a goal explicitly needs them.

## dbt conventions for this project

Code in this project follows these patterns:

- **Lowercase** every identifier and keyword. Staging and mart `.sql`
  files are lowercase even though the source legacy SQL is uppercase.
- **CTE idiom**: `with source as (...), renamed as (...) select * from renamed`.
  Marts use named CTEs reflecting their role (`order_items_summary`,
  `customer_orders_summary`, etc.).
- **Macro-driven money conversions**: `{{ cents_to_dollars('x') }}` replaces
  the legacy `CAST(X AS NUMERIC(18,2)) / 100`. Keep the original cents
  column alongside the dollar column (audit trail).
- **Portable date truncation**: `{{ dbt.date_trunc('day', 'x') }}`
  instead of Snowflake-specific `DATE_TRUNC('DAY', x)`.
- **dbt references everywhere**:
  - Inter-model: `{{ ref('stg_x') }}` or `{{ ref('order_items') }}`.
  - Raw source tables: `{{ source('jaffle_raw', 'raw_orders') }}` — never
    hard-code `JAFFLE_SHOP.RAW.RAW_*`.
- **Schema layout**: raw at `JAFFLE_SHOP.RAW.*` (shared with legacy), dbt
  outputs at `JAFFLE_SHOP.STAGING.*` (views) and `JAFFLE_SHOP.MARTS.*`
  (tables). Cross-schema joins always go through `ref()`/`source()`.
- **One model per legacy table** (with one exception: `STG_SUPPLIES`
  collapses the legacy DDL+DML pair into a single dbt model).
- **Mart filename drops legacy suffixes**: `_ENRICHED` and `_SUMMARY`
  come off when authoring the dbt mart. `ORDER_ITEMS_ENRICHED` →
  `order_items.sql`, `ORDERS_SUMMARY` → `orders.sql`,
  `CUSTOMERS_SUMMARY` → `customers.sql`.

## Per-model docs

Each `.sql` model file has a matching `.yml` declaring column
descriptions and at least one `not_null` / `unique` test on the primary
key. Test coverage beyond that is welcome but not required.

## Validation: legacy ↔ dbt parity

When a dbt model is translated from a legacy table, correctness is
measured by **semantic equivalence with the legacy table**:

- Row-level data-diff between the legacy table
  (`JAFFLE_SHOP.LEGACY_PUBLIC.*`) and the dbt-built table
  (`JAFFLE_SHOP.STAGING.*` / `JAFFLE_SHOP.MARTS.*`).
- **Pass**: 0 differing rows on business columns.
- **Warn (not fail)**: differences only in audit columns. Anything ending
  in `_CENTS` is kept on the dbt side for parity but is not
  business-significant.
- **Fail**: any business-column difference.

Validation is per-model — finish translating and validating one model
before moving to the next.
