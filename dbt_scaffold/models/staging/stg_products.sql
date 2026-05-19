/*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_products
  Note: this model points to the reference production data in JAFFLE_SHOP.PROD.
  It will be replaced with a real implementation once ticket b2ad6c28-faa2-4159-a42a-0b616f354c5f
  (translating JAFFLE_LEGACY_DB.PUBLIC.STG_PRODUCTS) lands.
=========================================================================================
*/

{{ config(
    materialized='view'
) }}

select * from {{ source('jaffle_tmp', 'stg_products') }}
