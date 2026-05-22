{{ config(
    materialized='table',
    database='JAFFLE_SHOP',
    schema='DATAFOLD_TMP',
    alias='order_items_7fa9bf3b'
) }}

with supply_cost_per_product as (
    select
        product_id,
        sum(supply_cost) as supply_cost
    from {{ ref('stg_supplies') }}
    group by product_id
),

order_items_enriched as (
    select
        oi.order_item_id,
        oi.order_id,
        o.ordered_at,
        oi.product_id,
        p.product_name,
        p.product_price,
        p.is_food_item,
        p.is_drink_item,
        sc.supply_cost
    from {{ ref('stg_order_items') }} oi
    join {{ ref('stg_orders') }}      o  on o.order_id   = oi.order_id
    join {{ ref('stg_products') }}    p  on p.product_id = oi.product_id
    left join supply_cost_per_product sc on sc.product_id = oi.product_id
)

select * from order_items_enriched
