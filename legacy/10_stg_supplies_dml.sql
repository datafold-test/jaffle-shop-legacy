-- DML — populates STG_SUPPLIES from RAW_SUPPLIES.
-- Pairs with 10_stg_supplies_ddl.sql, which defines the table. The legacy
-- system runs this INSERT every night after the raw load.
--
-- Translates to: models/staging/stg_supplies.sql (the dbt model SQL is the
-- source of both the create and the populate — same target model file as
-- the DDL pair).
INSERT INTO JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES (
    SUPPLY_ID, SUPPLY_UUID, SUPPLY_NAME, PRODUCT_ID,
    SUPPLY_COST_CENTS, SUPPLY_COST, IS_PERISHABLE_SUPPLY
)
SELECT
    MD5(CONCAT(ID, '-', SKU))           AS SUPPLY_ID,
    ID                                  AS SUPPLY_UUID,
    NAME                                AS SUPPLY_NAME,
    SKU                                 AS PRODUCT_ID,
    COST                                AS SUPPLY_COST_CENTS,
    CAST(COST AS NUMERIC(18, 2)) / 100  AS SUPPLY_COST,
    PERISHABLE                          AS IS_PERISHABLE_SUPPLY
FROM JAFFLE_LEGACY_DB.PUBLIC.RAW_SUPPLIES;
