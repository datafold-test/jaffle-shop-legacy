
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_id
from DEV.DATAFOLD_TMP.stg_order_items_2e88025c_upstream
where product_id is null



  
  
      
    ) dbt_internal_test