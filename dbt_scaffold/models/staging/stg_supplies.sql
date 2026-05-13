with

source as (

    select * from {{ source('jaffle_raw', 'raw_supplies') }}

),

renamed as (

    select

        ----------  ids
        md5(concat(id, '-', sku))           as supply_id,
        id                                  as supply_uuid,
        sku                                 as product_id,

        ----------  text
        name                                as supply_name,

        ----------  numerics
        cost                                as supply_cost_cents,
        {{ cents_to_dollars('cost') }}      as supply_cost,

        ----------  booleans
        perishable                          as is_perishable_supply

    from source

)

select * from renamed
