with

source as (

    select * from {{ source('jaffle_raw', 'raw_products') }}

),

renamed as (

    select

        ----------  ids
        sku as product_id,

        ----------  text
        name as product_name,
        type as product_type,
        description as product_description,

        ----------  numerics
        price as product_price_cents,
        {{ cents_to_dollars('price') }} as product_price,

        ----------  booleans
        case when type = 'jaffle'   then true else false end as is_food_item,
        case when type = 'beverage' then true else false end as is_drink_item

    from source

)

select * from renamed
