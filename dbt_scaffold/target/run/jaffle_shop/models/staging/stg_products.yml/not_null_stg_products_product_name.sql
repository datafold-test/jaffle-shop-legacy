
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_name
from DEV.DATAFOLD_TMP.stg_products_b2ad6c28
where product_name is null



  
  
      
    ) dbt_internal_test