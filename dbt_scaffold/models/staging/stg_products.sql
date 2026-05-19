with

source as (

    select * from {{ source('jaffle_raw', 'raw_products') }}

),

renamed as (

    select
        sku as product_id,
        name as product_name,
        type as product_type,
        description as product_description,

        -- audit: raw integer cents preserved for parity with legacy
        price as product_price_cents,

        -- dollar conversion via shared macro
        {{ cents_to_dollars('price') }} as product_price,

        -- product-kind flags consumed by the marts layer
        case when type = 'jaffle'   then true else false end as is_food_item,
        case when type = 'beverage' then true else false end as is_drink_item

    from source

)

select * from renamed
