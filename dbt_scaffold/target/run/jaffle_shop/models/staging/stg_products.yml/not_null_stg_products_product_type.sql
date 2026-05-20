
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_type
from DEV.DEV.DATAFOLD_TMP_staging.stg_products
where product_type is null



  
  
      
    ) dbt_internal_test