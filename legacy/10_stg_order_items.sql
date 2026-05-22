-- Staging-layer order-items cleanup. Renames ID → ORDER_ITEM_ID and
-- preserves the FK relationships to RAW_ORDERS / RAW_PRODUCTS.
--
-- Translates to: models/staging/stg_order_items.sql
--   - source: source('jaffle_raw', 'raw_items')
CREATE OR REPLACE TABLE JAFFLE_SHOP.LEGACY_PUBLIC.STG_ORDER_ITEMS AS
SELECT
    ID        AS ORDER_ITEM_ID,
    ORDER_ID  AS ORDER_ID,
    SKU       AS PRODUCT_ID
FROM JAFFLE_SHOP.RAW.RAW_ITEMS;
