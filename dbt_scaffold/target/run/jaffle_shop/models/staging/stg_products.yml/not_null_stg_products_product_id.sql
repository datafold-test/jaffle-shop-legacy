
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_id
from JAFFLE_SHOP.DATAFOLD_TMP.stg_products_87ccd74e
where product_id is null



  
  
      
    ) dbt_internal_test