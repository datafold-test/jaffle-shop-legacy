
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select supply_id
from DEV.DATAFOLD_TMP.stg_supplies_2e88025c_upstream
where supply_id is null



  
  
      
    ) dbt_internal_test