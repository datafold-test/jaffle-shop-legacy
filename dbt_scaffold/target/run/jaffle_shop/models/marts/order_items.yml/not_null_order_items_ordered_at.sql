
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ordered_at
from DEV.DATAFOLD_TMP.order_items_6753cba2
where ordered_at is null



  
  
      
    ) dbt_internal_test