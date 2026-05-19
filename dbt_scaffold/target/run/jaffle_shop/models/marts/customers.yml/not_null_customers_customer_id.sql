
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_id
from DEV.datafold_tmp.customers_4039c1cc
where customer_id is null



  
  
      
    ) dbt_internal_test