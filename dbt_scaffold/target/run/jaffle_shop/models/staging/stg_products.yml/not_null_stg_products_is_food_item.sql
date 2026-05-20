
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select is_food_item
from DEV.DEV.DATAFOLD_TMP_staging.stg_products
where is_food_item is null



  
  
      
    ) dbt_internal_test