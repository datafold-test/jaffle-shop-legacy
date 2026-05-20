with customers as (
    select * from DEV.JAFFLE_DBT_DB_staging.stg_customers
),

orders as (
    select * from DEV.JAFFLE_DBT_DB_marts.orders
),

customer_orders_summary as (
    select
        customer_id,
        count(distinct order_id) as count_lifetime_orders,
        case when count(distinct order_id) > 1 then true else false end as is_repeat_buyer,
        min(ordered_at) as first_ordered_at,
        max(ordered_at) as last_ordered_at,
        sum(subtotal) as lifetime_spend_pretax,
        sum(tax_paid) as lifetime_tax_paid,
        sum(order_total) as lifetime_spend
    from orders
    group by customer_id
),

joined as (
    select
        c.customer_id,
        c.customer_name,
        coalesce(cos.count_lifetime_orders, 0) as count_lifetime_orders,
        coalesce(cos.is_repeat_buyer, false) as is_repeat_buyer,
        cos.first_ordered_at,
        cos.last_ordered_at,
        coalesce(cos.lifetime_spend_pretax, 0) as lifetime_spend_pretax,
        coalesce(cos.lifetime_tax_paid, 0) as lifetime_tax_paid,
        coalesce(cos.lifetime_spend, 0) as lifetime_spend
    from customers c
    left join customer_orders_summary cos on cos.customer_id = c.customer_id
)

select * from joined