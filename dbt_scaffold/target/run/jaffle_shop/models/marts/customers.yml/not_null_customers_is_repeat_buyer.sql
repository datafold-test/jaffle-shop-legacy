
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select is_repeat_buyer
from DEV.datafold_tmp.customers_4039c1cc
where is_repeat_buyer is null



  
  
      
    ) dbt_internal_test