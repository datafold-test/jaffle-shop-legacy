with source as (
    select * from JAFFLE_SHOP.RAW.raw_orders
),

renamed as (
    select
        id as order_id,
        store_id as location_id,
        customer as customer_id,

        -- raw cent columns preserved for auditing
        subtotal as subtotal_cents,
        tax_paid as tax_paid_cents,
        order_total as order_total_cents,

        -- dollar conversions using the cents_to_dollars macro
        
    cast(subtotal_cents as numeric(18, 2)) / 100
 as subtotal,
        
    cast(tax_paid_cents as numeric(18, 2)) / 100
 as tax_paid,
        
    cast(order_total_cents as numeric(18, 2)) / 100
 as order_total,

        -- order timestamp with day truncation
        date_trunc('day', ordered_at) as ordered_at

    from source
)

select * from renamed