-- Raw orders from the POS export.
-- Lands in JAFFLE_SHOP.RAW.RAW_ORDERS.
-- DO NOT TRANSLATE: source table only.
CREATE OR REPLACE TABLE JAFFLE_SHOP.RAW.RAW_ORDERS (
    ID            VARCHAR(36)  NOT NULL,   -- order UUID
    CUSTOMER      VARCHAR(36)  NOT NULL,   -- FK to RAW_CUSTOMERS.ID
    STORE_ID      VARCHAR(36)  NOT NULL,   -- store/location uuid
    ORDERED_AT    TIMESTAMP_NTZ,
    SUBTOTAL      INTEGER,                  -- cents
    TAX_PAID      INTEGER,                  -- cents
    ORDER_TOTAL   INTEGER                   -- cents
);
