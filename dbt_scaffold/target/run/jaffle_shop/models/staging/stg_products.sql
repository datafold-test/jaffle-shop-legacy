
  create or replace   view DEV.DATAFOLD_TMP.stg_products
  
  
  
  
  as (
    /*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: stg_products
  Note: this model points to a static copy of production data in DEV.DATAFOLD_TMP.
  It will be replaced with a real implementation once ticket b2ad6c28-faa2-4159-a42a-0b616f354c5f
  (translating JAFFLE_LEGACY_DB.PUBLIC.STG_PRODUCTS) lands.
=========================================================================================
*/



select * from JAFFLE_SHOP.PROD.stg_products
  );

