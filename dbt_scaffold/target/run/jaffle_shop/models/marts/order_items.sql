
  
    

create or replace transient table DEV.DATAFOLD_TMP.order_items_2e88025c_upstream
    
    
    
    as (

with order_items as (

    select * from DEV.DATAFOLD_TMP.stg_order_items_2e88025c_upstream

),

orders as (

    select * from DEV.DATAFOLD_TMP.stg_orders_2e88025c_upstream

),

products as (

    select * from DEV.DATAFOLD_TMP.stg_products_2e88025c_upstream

),

supplies as (

    select * from DEV.DATAFOLD_TMP.stg_supplies_2e88025c_upstream

),

supply_cost_per_product as (

    select
        product_id,
        sum(supply_cost) as supply_cost

    from supplies

    group by product_id

),

enriched as (

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
    join orders          o  on o.order_id   = oi.order_id
    join products        p  on p.product_id = oi.product_id
    left join supply_cost_per_product sc
                            on sc.product_id = oi.product_id

)

select * from enriched
    )
;


  