with

stg_orders as (

    select * from {{ ref('stg_orders') }}

),

order_items as (

    select * from {{ ref('order_items') }}

),

order_items_summary as (

    select
        order_id,
        sum(supply_cost)                                  as order_cost,
        sum(product_price)                                as order_items_subtotal,
        count(order_item_id)                              as count_order_items,
        sum(case when is_food_item  then 1 else 0 end)    as count_food_items,
        sum(case when is_drink_item then 1 else 0 end)    as count_drink_items

    from order_items
    group by order_id

),

final as (

    select
        o.order_id,
        o.location_id,
        o.customer_id,
        o.ordered_at,
        o.subtotal,
        o.tax_paid,
        o.order_total,
        ois.order_cost,
        ois.order_items_subtotal,
        ois.count_order_items,
        ois.count_food_items,
        ois.count_drink_items,
        coalesce(ois.count_food_items,  0) > 0 as is_food_order,
        coalesce(ois.count_drink_items, 0) > 0 as is_drink_order

    from stg_orders o
    left join order_items_summary ois on ois.order_id = o.order_id

)

select * from final
