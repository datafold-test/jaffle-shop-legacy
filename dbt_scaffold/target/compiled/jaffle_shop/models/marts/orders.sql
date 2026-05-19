with

orders as (

    select * from DEV.DATAFOLD_TMP_staging.stg_orders

),

order_items as (

    select * from DEV.DATAFOLD_TMP_marts.order_items

),

order_items_summary as (

    select
        order_id,
        sum(supply_cost)                                       as order_cost,
        sum(product_price)                                     as order_items_subtotal,
        count(order_item_id)                                   as count_order_items,
        sum(case when is_food_item  then 1 else 0 end)         as count_food_items,
        sum(case when is_drink_item then 1 else 0 end)         as count_drink_items

    from order_items
    group by order_id

),

final as (

    select
        orders.order_id,
        orders.location_id,
        orders.customer_id,
        orders.ordered_at,
        orders.subtotal,
        orders.tax_paid,
        orders.order_total,
        order_items_summary.order_cost,
        order_items_summary.order_items_subtotal,
        order_items_summary.count_order_items,
        order_items_summary.count_food_items,
        order_items_summary.count_drink_items,
        case when coalesce(order_items_summary.count_food_items, 0)  > 0 then true else false end as is_food_order,
        case when coalesce(order_items_summary.count_drink_items, 0) > 0 then true else false end as is_drink_order

    from orders
    left join order_items_summary on order_items_summary.order_id = orders.order_id

)

select * from final