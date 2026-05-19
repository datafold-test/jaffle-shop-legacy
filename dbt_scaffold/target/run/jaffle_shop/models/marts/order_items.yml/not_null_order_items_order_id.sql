
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_id
from DEV.DATAFOLD_TMP.order_items_6753cba2
where order_id is null



  
  
      
    ) dbt_internal_test