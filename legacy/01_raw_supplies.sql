-- Raw supplies catalog (ingredients / packaging tied to a product SKU).
-- Lands in JAFFLE_LEGACY_DB.PUBLIC.RAW_SUPPLIES.
-- DO NOT TRANSLATE: source table only.
CREATE OR REPLACE TABLE JAFFLE_LEGACY_DB.PUBLIC.RAW_SUPPLIES (
    ID          VARCHAR(20)  NOT NULL,
    NAME        VARCHAR(200) NOT NULL,
    COST        INTEGER      NOT NULL,   -- cents
    PERISHABLE  BOOLEAN      NOT NULL,
    SKU         VARCHAR(20)  NOT NULL    -- FK to RAW_PRODUCTS.SKU
);
