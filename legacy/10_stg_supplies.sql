-- Staging-layer supplies cleanup. Renames ID → SUPPLY_UUID, SKU → PRODUCT_ID,
-- converts cost (cents → dollars), derives a synthetic SUPPLY_ID that's
-- unique per (supply uuid, product) pair — supplies link to products N:1 in
-- the raw table.
--
-- Translates to: models/staging/stg_supplies.sql
--   - source: source('jaffle_raw', 'raw_supplies')
CREATE OR REPLACE TABLE JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES AS
SELECT
    MD5(CONCAT(ID, '-', SKU))                AS SUPPLY_ID,
    ID                                       AS SUPPLY_UUID,
    NAME                                     AS SUPPLY_NAME,
    SKU                                      AS PRODUCT_ID,
    COST                                     AS SUPPLY_COST_CENTS,
    CAST(COST AS NUMERIC(18, 2)) / 100       AS SUPPLY_COST,
    PERISHABLE                               AS IS_PERISHABLE_SUPPLY
FROM JAFFLE_LEGACY_DB.PUBLIC.RAW_SUPPLIES;
