with

order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

supplies as (
    select * from {{ ref('stg_supplies') }}
),

supply_cost_per_product as (
    select
        product_id,
        sum(supply_cost) as supply_cost
    from supplies
    group by product_id
),

joined as (
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
    from order_items oi
    inner join orders                  o  on o.order_id   = oi.order_id
    inner join products                p  on p.product_id = oi.product_id
    left  join supply_cost_per_product sc on sc.product_id = oi.product_id
)

select * from joined
