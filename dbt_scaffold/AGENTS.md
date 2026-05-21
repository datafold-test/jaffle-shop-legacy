# `dbt_scaffold/` — Target dbt project

This is the dbt project the translated SQL lands in. Materializes to
`JAFFLE_DBT_DB` on the same Snowflake account as the legacy warehouse.

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
    │   ├── stg_<entity>.sql # staging models (materialize as views in JAFFLE_DBT_DB.STAGING)
    │   └── stg_<entity>.yml # column docs + tests
    └── marts/
        ├── <entity>.sql     # mart models (materialize as tables in JAFFLE_DBT_DB.MARTS)
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
    hard-code `JAFFLE_LEGACY_DB.PUBLIC.RAW_*`.
- **Schema split**: legacy `PUBLIC` → dbt `STAGING` (views) and `MARTS`
  (tables). Cross-schema joins always go through `ref()`/`source()`.
- **One model per legacy table** (with one exception: `STG_SUPPLIES`
  collapses the legacy DDL+DML pair into a single dbt model).

## Per-model docs

Each `.sql` model file has a matching `.yml` declaring column
descriptions and at least one `not_null` / `unique` test on the primary
key. Test coverage beyond that is welcome but not required.
