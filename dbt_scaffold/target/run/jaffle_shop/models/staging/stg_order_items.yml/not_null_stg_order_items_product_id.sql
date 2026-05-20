
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_id
from JAFFLE_SHOP.DATAFOLD_TMP_DATAFOLD_TMP.stg_order_items_af9983e1
where product_id is null



  
  
      
    ) dbt_internal_test