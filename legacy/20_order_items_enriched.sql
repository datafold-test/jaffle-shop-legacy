-- Mart: per order_item, attach product + roll-up of total supply cost.
-- Each order item gets the product's dollar price and the SUM of supply
-- costs for that SKU (since one product has many supplies).
--
-- Translates to: models/marts/order_items.sql
--   - ref('stg_order_items'), ref('stg_orders'), ref('stg_products'), ref('stg_supplies')
--   - aggregate supplies per product first in a CTE, then join
CREATE OR REPLACE TABLE JAFFLE_LEGACY_DB.PUBLIC.ORDER_ITEMS_ENRICHED AS
WITH
SUPPLY_COST_PER_PRODUCT AS (
    SELECT
        PRODUCT_ID,
        SUM(SUPPLY_COST) AS SUPPLY_COST
    FROM JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES
    GROUP BY PRODUCT_ID
)
SELECT
    OI.ORDER_ITEM_ID,
    OI.ORDER_ID,
    O.ORDERED_AT,
    OI.PRODUCT_ID,
    P.PRODUCT_NAME,
    P.PRODUCT_PRICE,
    P.IS_FOOD_ITEM,
    P.IS_DRINK_ITEM,
    SC.SUPPLY_COST
FROM JAFFLE_LEGACY_DB.PUBLIC.STG_ORDER_ITEMS OI
JOIN JAFFLE_LEGACY_DB.PUBLIC.STG_ORDERS    O  ON O.ORDER_ID    = OI.ORDER_ID
JOIN JAFFLE_LEGACY_DB.PUBLIC.STG_PRODUCTS  P  ON P.PRODUCT_ID  = OI.PRODUCT_ID
LEFT JOIN SUPPLY_COST_PER_PRODUCT SC          ON SC.PRODUCT_ID = OI.PRODUCT_ID;
