with source as (
    select
        id,
        order_id,
        sku
    from {{ source('jaffle_raw', 'raw_items') }}
),

renamed as (
    select
        id as order_item_id,
        order_id,
        sku as product_id
    from source
)

select * from renamed
