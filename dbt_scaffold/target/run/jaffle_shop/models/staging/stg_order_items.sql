
  create or replace   view DEV.DATAFOLD_TMP.stg_order_items_2e88025c_upstream
  
  
  
  
  as (
    

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
  );

