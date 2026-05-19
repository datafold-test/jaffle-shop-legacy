with

source as (
    select * from JAFFLE_LEGACY_DB.PUBLIC.raw_orders
),

renamed as (
    select

        ----------  ids
        id          as order_id,
        store_id    as location_id,
        customer    as customer_id,

        ----------  numerics (cents preserved + dollar variants)
        subtotal    as subtotal_cents,
        tax_paid    as tax_paid_cents,
        order_total as order_total_cents,

        
    cast(subtotal as numeric(18, 2)) / 100
    as subtotal,
        
    cast(tax_paid as numeric(18, 2)) / 100
    as tax_paid,
        
    cast(order_total as numeric(18, 2)) / 100
 as order_total,

        ----------  timestamps
        date_trunc('day', ordered_at) as ordered_at

    from source
)

select * from renamed