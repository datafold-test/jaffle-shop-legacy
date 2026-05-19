/*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_order_items
  Note: this model points to the reference production data in JAFFLE_SHOP.PROD.
  It will be replaced with a real implementation once ticket c3afe117-d092-4744-9828-e4ec6cc61498
  (translating JAFFLE_LEGACY_DB.PUBLIC.STG_ORDER_ITEMS) lands.
=========================================================================================
*/

{{ config(
    materialized='view'
) }}

select * from {{ source('jaffle_tmp', 'stg_order_items') }}
