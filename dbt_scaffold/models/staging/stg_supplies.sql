with

source as (

    select * from {{ source('jaffle_raw', 'raw_supplies') }}

),

renamed as (

    select

        ----------  ids
        md5(concat(id, '-', sku)) as supply_id,
        id                        as supply_uuid,
        sku                       as product_id,

        ----------  attributes
        name                      as supply_name,
        perishable                as is_perishable_supply,

        ----------  raw cent column preserved for auditing
        cost                      as supply_cost_cents,

        ----------  dollar conversion
        {{ cents_to_dollars('cost') }} as supply_cost

    from source

)

select * from renamed
