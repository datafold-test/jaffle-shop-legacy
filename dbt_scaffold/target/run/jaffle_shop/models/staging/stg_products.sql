
  create or replace   view DEV.DATAFOLD_TMP.stg_products_b2ad6c28
  
  
  
  
  as (
    

with

source as (

    select * from JAFFLE_SHOP.RAW.raw_products

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
        
    cast(price as numeric(18, 2)) / 100
 as product_price,

        ----------  booleans
        case when type = 'jaffle'   then true else false end as is_food_item,
        case when type = 'beverage' then true else false end as is_drink_item

    from source

)

select * from renamed
  );

