-- Raw product catalog.
-- Lands in JAFFLE_SHOP.RAW.RAW_PRODUCTS.
-- DO NOT TRANSLATE: source table only.
CREATE OR REPLACE TABLE JAFFLE_SHOP.RAW.RAW_PRODUCTS (
    SKU          VARCHAR(20)  NOT NULL,
    NAME         VARCHAR(200) NOT NULL,
    TYPE         VARCHAR(50)  NOT NULL,   -- 'jaffle' | 'beverage'
    PRICE        INTEGER      NOT NULL,   -- cents
    DESCRIPTION  VARCHAR(2000)
);
