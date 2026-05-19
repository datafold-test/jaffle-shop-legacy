
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select supply_id
from JAFFLE_SHOP.DATAFOLD_TMP.stg_supplies_9abd86f1
where supply_id is null



  
  
      
    ) dbt_internal_test