
  create or replace   view JAFFLE_SHOP.DATAFOLD_TMP.stg_supplies_4f463626f0a04380a6c8fc2aa2bbfa72
  
  
  
  
  as (
    

with source as (

    -- NOTE: For test build only, using JAFFLE_SHOP.RAW (equivalent to JAFFLE_LEGACY_DB.PUBLIC in production).
    -- The final model uses JAFFLE_LEGACY_DB.PUBLIC.raw_supplies.
    select * from JAFFLE_SHOP.RAW.RAW_SUPPLIES

),

renamed as (

    select
        md5(concat(id, '-', sku))       as supply_id,
        id                              as supply_uuid,
        name                            as supply_name,
        sku                             as product_id,
        cost                            as supply_cost_cents,
        
    cast(cost as numeric(18, 2)) / 100
  as supply_cost,
        perishable                      as is_perishable_supply

    from source

)

select * from renamed
  );
