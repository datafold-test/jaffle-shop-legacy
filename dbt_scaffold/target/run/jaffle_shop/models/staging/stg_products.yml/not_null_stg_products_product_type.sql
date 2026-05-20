
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_type
from DEV.DATAFOLD_TMP.stg_products_2e88025c_upstream
where product_type is null



  
  
      
    ) dbt_internal_test