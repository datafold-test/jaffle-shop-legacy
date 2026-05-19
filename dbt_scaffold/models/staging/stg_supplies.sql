/*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_supplies
  Note: this model points to the reference production data in JAFFLE_SHOP.PROD.
  It will be replaced with a real implementation once ticket 9abd86f1-d606-45ce-9a7a-817c3b46f173
  (translating JAFFLE_LEGACY_DB.PUBLIC.STG_SUPPLIES via DDL+DML scripts) lands.
=========================================================================================
*/

{{ config(
    materialized='view'
) }}

select * from {{ source('jaffle_tmp', 'stg_supplies') }}
