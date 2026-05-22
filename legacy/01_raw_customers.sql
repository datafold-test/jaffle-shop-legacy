-- Raw customer dump from the operational store.
-- Lands in JAFFLE_SHOP.RAW.RAW_CUSTOMERS via a nightly Fivetran job.
-- DO NOT TRANSLATE: this is a source table; the translated dbt project
-- references it via `{{ source('jaffle_raw', 'raw_customers') }}`.
CREATE OR REPLACE TABLE JAFFLE_SHOP.RAW.RAW_CUSTOMERS (
    ID         VARCHAR(36)  NOT NULL,    -- UUID
    NAME       VARCHAR(200) NOT NULL
);
