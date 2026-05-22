{{ config(
    materialized='view',
    database='JAFFLE_SHOP',
    schema='DATAFOLD_TMP',
    alias='stg_order_items_7fa9bf3b'
) }}

with source as (
    select * from {{ source('jaffle_raw', 'raw_items') }}
),

renamed as (
    select
        id       as order_item_id,
        order_id as order_id,
        sku      as product_id
    from source
)

select * from renamed
