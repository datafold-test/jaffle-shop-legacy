
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_name
from JAFFLE_SHOP.DATAFOLD_TMP.stg_products_87ccd74e
where product_name is null



  
  
      
    ) dbt_internal_test