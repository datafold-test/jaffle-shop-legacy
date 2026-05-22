-- Staging-layer customer cleanup. Renames ID/NAME → CUSTOMER_ID/CUSTOMER_NAME
-- and asserts the schema we hand to the analytics layer.
--
-- Translates to: models/staging/stg_customers.sql
--   - dbt source: source('jaffle_raw', 'raw_customers')
--   - keep the `with source / renamed / select * from renamed` jaffle-shop idiom
CREATE OR REPLACE TABLE JAFFLE_SHOP.LEGACY_PUBLIC.STG_CUSTOMERS AS
SELECT
    ID   AS CUSTOMER_ID,
    NAME AS CUSTOMER_NAME
FROM JAFFLE_SHOP.RAW.RAW_CUSTOMERS;
