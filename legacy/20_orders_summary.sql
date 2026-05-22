-- Mart: orders rolled up with per-order item summary and food/drink counts.
-- Joins stg_orders with the order-items roll-up, and surfaces order_cost +
-- order_items_subtotal so the analytics layer can compute margins.
--
-- Translates to: models/marts/orders.sql
--   - ref('stg_orders'), ref('order_items') (the marts model from order_items_enriched)
CREATE OR REPLACE TABLE JAFFLE_SHOP.LEGACY_PUBLIC.ORDERS_SUMMARY AS
WITH
ORDER_ITEMS_SUMMARY AS (
    SELECT
        ORDER_ID,
        SUM(SUPPLY_COST)                                      AS ORDER_COST,
        SUM(PRODUCT_PRICE)                                    AS ORDER_ITEMS_SUBTOTAL,
        COUNT(ORDER_ITEM_ID)                                  AS COUNT_ORDER_ITEMS,
        SUM(CASE WHEN IS_FOOD_ITEM  THEN 1 ELSE 0 END)        AS COUNT_FOOD_ITEMS,
        SUM(CASE WHEN IS_DRINK_ITEM THEN 1 ELSE 0 END)        AS COUNT_DRINK_ITEMS
    FROM JAFFLE_SHOP.LEGACY_PUBLIC.ORDER_ITEMS_ENRICHED
    GROUP BY ORDER_ID
)
SELECT
    O.ORDER_ID,
    O.LOCATION_ID,
    O.CUSTOMER_ID,
    O.ORDERED_AT,
    O.SUBTOTAL,
    O.TAX_PAID,
    O.ORDER_TOTAL,
    OIS.ORDER_COST,
    OIS.ORDER_ITEMS_SUBTOTAL,
    OIS.COUNT_ORDER_ITEMS,
    OIS.COUNT_FOOD_ITEMS,
    OIS.COUNT_DRINK_ITEMS,

    -- A jaffle-shop convention: orders that contain at least one food item.
    CASE WHEN COALESCE(OIS.COUNT_FOOD_ITEMS, 0) > 0 THEN TRUE ELSE FALSE END AS IS_FOOD_ORDER,
    CASE WHEN COALESCE(OIS.COUNT_DRINK_ITEMS, 0) > 0 THEN TRUE ELSE FALSE END AS IS_DRINK_ORDER
FROM JAFFLE_SHOP.LEGACY_PUBLIC.STG_ORDERS O
LEFT JOIN ORDER_ITEMS_SUMMARY OIS ON OIS.ORDER_ID = O.ORDER_ID;
