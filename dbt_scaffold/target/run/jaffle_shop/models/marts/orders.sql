
  create or replace   view DEV.datafold_tmp.orders
  
  
  
  
  as (
    /*
=========================================================================================
  TEMPORARY PLACEHOLDER MODEL: orders
  Note: this model points to static data in JAFFLE_SHOP.PROD.ORDERS (reference
  jaffle-shop implementation). It will be replaced with a real implementation.
=========================================================================================
*/



select * from JAFFLE_SHOP.PROD.orders
  );

