
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_id
from DEV.DATAFOLD_TMP.order_items_2624066d
where product_id is null



  
  
      
    ) dbt_internal_test