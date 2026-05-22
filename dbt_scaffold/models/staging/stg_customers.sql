{{ config(
    materialized='view',
    database='JAFFLE_SHOP',
    schema='DATAFOLD_TMP',
    alias='stg_customers_7fa9bf3b'
) }}

with source as (
    select * from {{ source('jaffle_raw', 'raw_customers') }}
),

renamed as (
    select
        id   as customer_id,
        name as customer_name
    from source
)

select * from renamed
