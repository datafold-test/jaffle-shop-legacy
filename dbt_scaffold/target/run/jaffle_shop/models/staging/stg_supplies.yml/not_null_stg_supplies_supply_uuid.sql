
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select supply_uuid
from DEV.DATAFOLD_TMP.stg_supplies_2e88025c_upstream
where supply_uuid is null



  
  
      
    ) dbt_internal_test