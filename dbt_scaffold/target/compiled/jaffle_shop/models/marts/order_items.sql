

with

order_items as (

    select * from DEV.DATAFOLD_TMP.stg_order_items

),

orders as (

    select * from DEV.DATAFOLD_TMP.stg_orders

),

products as (

    select * from DEV.DATAFOLD_TMP.stg_products

),

supplies as (

    select * from DEV.DATAFOLD_TMP.stg_supplies

),

order_supplies_summary as (

    select
        product_id,
        sum(supply_cost) as supply_cost

    from supplies

    group by product_id

),

joined as (

    select
        order_items.order_item_id,
        order_items.order_id,
        orders.ordered_at,
        order_items.product_id,
        products.product_name,
        products.product_price,
        products.is_food_item,
        products.is_drink_item,
        order_supplies_summary.supply_cost

    from order_items

    inner join orders
        on orders.order_id = order_items.order_id

    inner join products
        on products.product_id = order_items.product_id

    left join order_supplies_summary
        on order_supplies_summary.product_id = order_items.product_id

)

select * from joined