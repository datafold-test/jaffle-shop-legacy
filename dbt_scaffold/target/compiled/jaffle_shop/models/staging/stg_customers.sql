with source as (
    select * from JAFFLE_LEGACY_DB.PUBLIC.raw_customers
),

renamed as (
    select
        id as customer_id,
        name as customer_name
    from source
)

select * from renamed