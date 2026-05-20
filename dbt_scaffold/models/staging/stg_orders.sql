with source as (
    select * from {{ source('jaffle_raw', 'raw_orders') }}
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
        {{ cents_to_dollars('subtotal_cents') }} as subtotal,
        {{ cents_to_dollars('tax_paid_cents') }} as tax_paid,
        {{ cents_to_dollars('order_total_cents') }} as order_total,

        -- order timestamp with day truncation
        {{ dbt.date_trunc('day', 'ordered_at') }} as ordered_at

    from source
)

select * from renamed
