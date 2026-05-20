
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select supply_id
from JAFFLE_SHOP.DATAFOLD_TMP.stg_supplies_4f463626f0a04380a6c8fc2aa2bbfa72
where supply_id is null



  
  
      
    ) dbt_internal_test