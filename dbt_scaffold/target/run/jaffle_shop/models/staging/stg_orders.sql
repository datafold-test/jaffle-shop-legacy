
  create or replace   view DEV.DATAFOLD_TMP.stg_orders
  
  
  
  
  as (
    /*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_orders
  Note: this model points to a static copy of production data in DEV.DATAFOLD_TMP.
  It will be replaced with a real implementation once ticket ab7b726c-119b-4337-8c9d-6c531e962a79
  (translating JAFFLE_LEGACY_DB.PUBLIC.STG_ORDERS) lands.
=========================================================================================
*/



select * from JAFFLE_SHOP.PROD.stg_orders
  );

