
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_price_cents
from DEV.DEV.DATAFOLD_TMP_staging.stg_products
where product_price_cents is null



  
  
      
    ) dbt_internal_test