-- Staging-layer product cleanup. Renames SKU → PRODUCT_ID, converts cents
-- to dollars, derives the is_food_item / is_drink_item booleans the
-- analytics layer relies on.
--
-- Translates to: models/staging/stg_products.sql
--   - source: source('jaffle_raw', 'raw_products')
CREATE OR REPLACE TABLE JAFFLE_SHOP.LEGACY_PUBLIC.STG_PRODUCTS AS
SELECT
    SKU                                            AS PRODUCT_ID,
    NAME                                           AS PRODUCT_NAME,
    TYPE                                           AS PRODUCT_TYPE,
    DESCRIPTION                                    AS PRODUCT_DESCRIPTION,

    -- raw price preserved for auditing
    PRICE                                          AS PRODUCT_PRICE_CENTS,

    -- dollar conversion
    CAST(PRICE AS NUMERIC(18, 2)) / 100            AS PRODUCT_PRICE,

    -- product-kind flags
    CASE WHEN TYPE = 'jaffle'   THEN TRUE ELSE FALSE END AS IS_FOOD_ITEM,
    CASE WHEN TYPE = 'beverage' THEN TRUE ELSE FALSE END AS IS_DRINK_ITEM
FROM JAFFLE_SHOP.RAW.RAW_PRODUCTS;
