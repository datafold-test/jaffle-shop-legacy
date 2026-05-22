-- Staging-layer order cleanup. Renames the POS columns to the analytics
-- naming convention and converts cents → dollars on the money columns.
--
-- Translates to: models/staging/stg_orders.sql
--   - source: source('jaffle_raw', 'raw_orders')
--   - use the `cents_to_dollars` macro from the dbt project (see macros/)
--   - keep both the *_cents and the dollar variants the way jaffle-shop does
CREATE OR REPLACE TABLE JAFFLE_SHOP.LEGACY_PUBLIC.STG_ORDERS AS
SELECT
    ID          AS ORDER_ID,
    STORE_ID    AS LOCATION_ID,
    CUSTOMER    AS CUSTOMER_ID,

    -- raw cent columns preserved for auditing
    SUBTOTAL    AS SUBTOTAL_CENTS,
    TAX_PAID    AS TAX_PAID_CENTS,
    ORDER_TOTAL AS ORDER_TOTAL_CENTS,

    -- dollar conversions
    CAST(SUBTOTAL    AS NUMERIC(18, 2)) / 100 AS SUBTOTAL,
    CAST(TAX_PAID    AS NUMERIC(18, 2)) / 100 AS TAX_PAID,
    CAST(ORDER_TOTAL AS NUMERIC(18, 2)) / 100 AS ORDER_TOTAL,

    DATE_TRUNC('DAY', ORDERED_AT) AS ORDERED_AT
FROM JAFFLE_SHOP.RAW.RAW_ORDERS;
