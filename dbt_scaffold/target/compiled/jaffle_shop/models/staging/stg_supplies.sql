

with source as (

    select * from JAFFLE_SHOP.RAW.raw_supplies

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