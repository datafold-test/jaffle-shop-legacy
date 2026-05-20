

with source as (

    select * from JAFFLE_SHOP.RAW.raw_items

),

renamed as (

    select
        id          as order_item_id,
        order_id    as order_id,
        sku         as product_id

    from source

)

select * from renamed