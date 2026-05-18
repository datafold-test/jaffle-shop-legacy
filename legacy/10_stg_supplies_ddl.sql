-- DDL — defines the STG_SUPPLIES staging table.
-- Pairs with 10_stg_supplies_dml.sql, which populates the rows. The legacy
-- system split DDL from DML so the table could be created once and
-- repopulated nightly without re-issuing CREATE.
--
-- Translates to: models/staging/stg_supplies.sql (single dbt model in the
-- target; dbt doesn't separate DDL from DML — the model SQL is the source
-- of both).
CREATE TABLE JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES (
    SUPPLY_ID            VARCHAR(32) NOT NULL,
    SUPPLY_UUID          VARCHAR(36) NOT NULL,
    SUPPLY_NAME          VARCHAR(200),
    PRODUCT_ID           VARCHAR(36),
    SUPPLY_COST_CENTS    NUMERIC(18, 0),
    SUPPLY_COST          NUMERIC(18, 2),
    IS_PERISHABLE_SUPPLY BOOLEAN
);
