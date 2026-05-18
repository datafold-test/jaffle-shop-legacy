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

order_items_enriched as (
    select
        order_items.order_item_id,
        order_items.order_id,
        orders.ordered_at,
        order_items.product_id,
        products.product_name,
        products.product_price,
        products.is_food_item,
        products.is_drink_item,
        supply_cost_per_product.supply_cost
    from order_items
    inner join orders
        on order_items.order_id = orders.order_id
    inner join products
        on order_items.product_id = products.product_id
    left join supply_cost_per_product
        on order_items.product_id = supply_cost_per_product.product_id
)

select * from order_items_enriched
