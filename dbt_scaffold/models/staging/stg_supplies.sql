with source as (

    select * from {{ source('jaffle_raw', 'raw_supplies') }}

),

renamed as (

    select
        md5(concat(id, '-', sku))           as supply_id,
        id                                  as supply_uuid,
        name                                as supply_name,
        sku                                 as product_id,

        -- raw cost preserved for auditing
        cost                                as supply_cost_cents,

        -- dollar conversion
        {{ cents_to_dollars('cost') }}      as supply_cost,

        perishable                          as is_perishable_supply

    from source

)

select * from renamed
