/*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_orders
  Note: this model points to a static copy of production data replicated in
  DEV.DATAFOLD_TMP.STG_ORDERS. It will be replaced with a real implementation
  from source('jaffle_raw', 'raw_orders') once source connectivity is established.
=========================================================================================
*/

with source as (

    select * from {{ source('jaffle_raw', 'raw_orders') }}

),

renamed as (

    select
        id          as order_id,
        store_id    as location_id,
        customer    as customer_id,

        -- raw cent columns preserved for auditing
        subtotal    as subtotal_cents,
        tax_paid    as tax_paid_cents,
        order_total as order_total_cents,

        -- dollar conversions
        {{ cents_to_dollars('subtotal') }}    as subtotal,
        {{ cents_to_dollars('tax_paid') }}    as tax_paid,
        {{ cents_to_dollars('order_total') }} as order_total,

        {{ dbt.date_trunc('day', 'ordered_at') }} as ordered_at

    from source

)

select * from renamed
