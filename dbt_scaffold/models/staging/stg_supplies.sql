/*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_supplies
  Note: this model points to static data from raw_supplies, applying the same
  transformations as the legacy 10_stg_supplies_ddl.sql + 10_stg_supplies_dml.sql.
  It will be replaced by the real implementation when ticket
  afd7f3dd-c271-47ab-8ec9-fb1ff7e15c09 is completed.
=========================================================================================
*/

with

source as (
    select * from {{ source('jaffle_raw', 'raw_supplies') }}
),

renamed as (
    select
        md5(concat(id, '-', sku))           as supply_id,
        id                                  as supply_uuid,
        name                                as supply_name,
        sku                                 as product_id,
        cost                                as supply_cost_cents,
        {{ cents_to_dollars('cost') }}       as supply_cost,
        perishable                          as is_perishable_supply
    from source
)

select * from renamed
