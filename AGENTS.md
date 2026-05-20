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

## Logical vs physical identifiers

The FQNs in this document — `JAFFLE_LEGACY_DB.PUBLIC.*` and `JAFFLE_DBT_DB.{STAGING,MARTS}.*` — are the project's **canonical logical identifiers**. They appear in:

- the per-file mapping table below;
- ticket titles and descriptions framed by the Lead;
- `record_translation_mapping` calls in the DKG (`source_paths` / `target_path`).

The **physical** Snowflake names backing them can differ per environment. A dev/test account may host the same data under `JAFFLE_SHOP.RAW.*` (raw) and `JAFFLE_SHOP.{PROD,STAGING,MARTS}.*` (built tiers). Two places carry physical names, and only these two:

- `dbt_scaffold/models/staging/__sources.yml` — the dbt source declaration; `profiles.yml` / `dbt_project.yml` / env overrides resolve it to the right physical FQN at build time.
- The data-diff **baseline** you pass to the diff tool at validation time — set by the goal, not by you.

**Do not rewrite logical identifiers to match physical ones, or vice versa.** If a logical FQN doesn't resolve in your Snowflake session, the answer is to ask the Lead — not to "fix" `__sources.yml` or the per-file mapping table to match what `INFORMATION_SCHEMA` shows.

## Do not modify `__sources.yml`

`dbt_scaffold/models/staging/__sources.yml` is pre-wired against the logical source identifiers. It can *look* inconsistent with the Snowflake `INFORMATION_SCHEMA` for the account you're on — that's by design; the resolution layer (profile / project config / env vars) closes the gap at build time. Touching this file to "match reality" breaks every downstream model in the same dispatch and gets the ticket bounced.

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

The `legacy/` directory uses numeric prefixes to indicate the layer. Most
legacy `.sql` scripts are `CREATE OR REPLACE TABLE … AS SELECT` and so
materialize ONE legacy warehouse table per file. The one exception is
`STG_SUPPLIES`, which the legacy system splits across two files: a DDL
file that defines the table and a DML file that populates it. Both files
participate in building the same `STG_SUPPLIES` target — translate them
into a single dbt model (`models/staging/stg_supplies.sql`), since dbt
combines the create and the populate. The translated dbt model
materializes ONE target warehouse table:

| Prefix | Legacy script | Legacy warehouse table (the *real* asset) | dbt file produced | Target warehouse table (the dbt-built asset) |
|---|---|---|---|---|
| `01_raw_*.sql` | DDL — **DO NOT translate** | source — declared in `__sources.yml` | (none) | (none — source-only) |
| `10_stg_customers.sql` | rename | `JAFFLE_LEGACY_DB.PUBLIC.STG_CUSTOMERS` | `models/staging/stg_customers.sql` | `JAFFLE_DBT_DB.STAGING.STG_CUSTOMERS` |
| `10_stg_orders.sql` | rename + macro | `JAFFLE_LEGACY_DB.PUBLIC.STG_ORDERS` | `models/staging/stg_orders.sql` | `JAFFLE_DBT_DB.STAGING.STG_ORDERS` |
| `10_stg_order_items.sql` | rename | `JAFFLE_LEGACY_DB.PUBLIC.STG_ORDER_ITEMS` | `models/staging/stg_order_items.sql` | `JAFFLE_DBT_DB.STAGING.STG_ORDER_ITEMS` |
| `10_stg_products.sql` | rename + flags | `JAFFLE_LEGACY_DB.PUBLIC.STG_PRODUCTS` | `models/staging/stg_products.sql` | `JAFFLE_DBT_DB.STAGING.STG_PRODUCTS` |
| `10_stg_supplies_ddl.sql` + `10_stg_supplies_dml.sql` | **DDL+DML split** — rename + cents | `JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES` | `models/staging/stg_supplies.sql` | `JAFFLE_DBT_DB.STAGING.STG_SUPPLIES` |
| `20_order_items_enriched.sql` | mart join | `JAFFLE_LEGACY_DB.PUBLIC.ORDER_ITEMS_ENRICHED` | `models/marts/order_items.sql` | `JAFFLE_DBT_DB.MARTS.ORDER_ITEMS` |
| `20_orders_summary.sql` | mart agg | `JAFFLE_LEGACY_DB.PUBLIC.ORDERS_SUMMARY` | `models/marts/orders.sql` | `JAFFLE_DBT_DB.MARTS.ORDERS` |
| `20_customers_summary.sql` | mart agg | `JAFFLE_LEGACY_DB.PUBLIC.CUSTOMERS_SUMMARY` | `models/marts/customers.sql` | `JAFFLE_DBT_DB.MARTS.CUSTOMERS` |

> **CRITICAL — warehouse FQNs, not file paths.** The MAPS_TO edges you
> record (see "Done definition" below) describe the **warehouse table
> assets**, not the `.sql` files. Use the database FQN tuples from the
> *Legacy warehouse table* and *Target warehouse table* columns above.
> **Never** pass `["legacy", "10_stg_orders.sql"]` or `["dbt_scaffold",
> "models", "staging", "stg_orders.sql"]` to the mapping tool — those
> are file paths, not data assets, and they produce graph nodes no
> downstream consumer can resolve. The mart-layer files follow the
> same rule: e.g. `legacy/20_orders_summary.sql` produces the table
> `JAFFLE_LEGACY_DB.PUBLIC.ORDERS_SUMMARY`, and the dbt model
> `models/marts/orders.sql` produces the table
> `JAFFLE_DBT_DB.MARTS.ORDERS`. Those two FQNs are what the MAPS_TO
> edge connects.
>
> These FQNs are the project's **logical / DKG identifiers**; they need
> not resolve in the physical Snowflake account you're connected to.
> `record_translation_mapping` accepts them by design — do not query
> `INFORMATION_SCHEMA` to "verify they exist" before recording the
> mapping. See **Logical vs physical identifiers** above.

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
| `JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES` (built by `10_stg_supplies_ddl.sql` + `10_stg_supplies_dml.sql`) | `JAFFLE_DBT_DB.STAGING.STG_SUPPLIES` |
| `JAFFLE_LEGACY_DB.PUBLIC.ORDER_ITEMS_ENRICHED` | `JAFFLE_DBT_DB.MARTS.ORDER_ITEMS` |
| `JAFFLE_LEGACY_DB.PUBLIC.ORDERS_SUMMARY` | `JAFFLE_DBT_DB.MARTS.ORDERS` |
| `JAFFLE_LEGACY_DB.PUBLIC.CUSTOMERS_SUMMARY` | `JAFFLE_DBT_DB.MARTS.CUSTOMERS` |

Acceptance criteria: every pair returns 0 differing rows on the business
columns. Audit columns (anything ending in `_CENTS`) are kept on the dbt
side for parity but are NOT business-significant — flag those as `warn`
rather than `fail` if they diverge.

> **Diff baseline = physical Snowflake.** The "Legacy table" column above shows the **logical** identifier (what goes into the DKG mapping). The actual diff runs against whichever **physical** baseline the goal has provisioned in this account — for the current dev/test account that has been `JAFFLE_SHOP.PROD.STG_<NAME>` (staging) / `JAFFLE_SHOP.PROD.<UPPERCASE_NAME>` (marts), per the precedent set by approved sibling tickets. The Lead pins the per-goal baseline in the ticket description; if it isn't there, ask before running diffs — do not guess from `INFORMATION_SCHEMA`.

## Conventions

- **Snake-case** identifiers everywhere in the dbt project (`customer_id`, `ordered_at`).
- **Schema mapping**: legacy `PUBLIC` schema splits into dbt `STAGING` (views) and `MARTS` (tables).
- **No procedural code**: every transform is a single `SELECT`. The legacy `CREATE OR REPLACE TABLE` scripts are stand-ins for cron'd ETL — the dbt rewrites are pure transforms.
- **One model per legacy table.** Do not merge or split. Many-to-many split-or-merge cases can be revisited later, but for this first pass keep it 1-to-1 at the staging layer.
- The marts layer renames are intentional: `legacy/ORDER_ITEMS_ENRICHED → models/marts/order_items.sql`, `legacy/ORDERS_SUMMARY → models/marts/orders.sql`, `legacy/CUSTOMERS_SUMMARY → models/marts/customers.sql`. See the table above for the full map.

## What NOT to do

- Don't translate `legacy/01_raw_*.sql` — those define dbt **sources**, not models.
- Don't add new seed CSVs. The raw tables are already populated in the legacy DB; sources point at them directly.
- Don't change `dbt_project.yml`, `profiles.yml`, or `packages.yml`. They're pre-wired. (`__sources.yml` has its own dedicated section above — read it.)
- Don't introduce snapshot or seed logic for this first migration pass.

## Done definition for one translated model

1. New `.sql` file at the correct `dbt_scaffold/models/{staging,marts}/` path.
2. Matching `.yml` file declaring columns + at least one `not_null` / `unique` test on the primary key.
3. `dbt build --select <model>` runs clean.
4. Row-level data-diff against the legacy counterpart returns 0 differing rows on business columns.
5. **One `record_translation_mapping` call** publishing the
   `(legacy → target)` mapping into the knowledge graph. Use the warehouse
   FQN tuples (NOT file paths):
   - **Staging tickets**: `source_paths=[["JAFFLE_LEGACY_DB", "PUBLIC", "STG_<NAME>"]]`,
     `target_path=["JAFFLE_DBT_DB", "STAGING", "STG_<NAME>"]`, `target_kind="dataset"`.
   - **Mart tickets**: legacy table is
     `JAFFLE_LEGACY_DB.PUBLIC.<UPPERCASE_NAME>`, target is
     `JAFFLE_DBT_DB.MARTS.<UPPERCASE_NAME>` (see the per-file table for
     exact mapping). `target_kind="dataset"`.
   - **Validation fields**: `validation_status="pass"` when the diff is
     clean, `"warn"` only if it's an audit-column-only difference (e.g.
     `*_CENTS` columns), `"fail"` if business columns diverge. Set
     `validation_type="datadiff"` and `diff_id=<int>` whenever you ran
     a row-level diff. If data-source credentials weren't available for
     this goal, fall back to `validation_type="manual"` with a `notes`
     line explaining the gap (or omit `validation_status` entirely — a
     mapping with no Validation node is still useful bookkeeping).
   - The tool is idempotent — re-running with the same arguments is a
     no-op. Call it ONCE per target asset.
6. (Optional) `attach_migration_artifact` for the existing per-ticket
   bookkeeping. That's a pre-DKG record kept around for the UI; the
   DKG mapping in step 5 is the authoritative bookkeeping going forward.

## Verify before claiming a fix

Before posting a "FIXED" comment about a config file you think you modified, run `git diff <file>` or call the `changed_files` tool. If the file is **unchanged from the goal work branch**, do not claim a fix — the apparent inconsistency is intentional (see "Logical vs physical identifiers" above) and you should escalate to the Lead instead of silently rewriting it. A claim-without-a-diff cascades: the reviewer rejects the ticket on the alleged change, the next developer reverts a change that never happened, and the goal stalls on a misperception.

**For reviewers**: before rejecting on a "developer modified file X" basis, verify the file was actually modified. If `changed_files` shows no diff against the goal work branch, the developer's narrative is wrong and the rejection rests on a misperception — re-check the ticket instead of bouncing it.

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

When you set up a goal, **pin the physical diff baseline** for this account in the goal description or initial-task body (e.g. *"diff left side = `JAFFLE_SHOP.PROD.STG_<NAME>` for staging, `JAFFLE_SHOP.PROD.<UPPERCASE_NAME>` for marts"*). Without it, developers fall back to the logical FQNs from the per-file table, which won't resolve, and the validation step blocks.
