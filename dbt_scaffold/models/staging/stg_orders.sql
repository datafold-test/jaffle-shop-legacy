/*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_orders
  Note: this model points to the reference production data in JAFFLE_SHOP.PROD.
  It will be replaced with a real implementation once ticket ab7b726c-119b-4337-8c9d-6c531e962a79
  (translating JAFFLE_LEGACY_DB.PUBLIC.STG_ORDERS) lands.
=========================================================================================
*/

{{ config(
    materialized='view'
) }}

select * from {{ source('jaffle_tmp', 'stg_orders') }}
