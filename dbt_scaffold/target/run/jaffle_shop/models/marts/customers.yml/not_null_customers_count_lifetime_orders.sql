
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select count_lifetime_orders
from DEV.datafold_tmp.customers_4039c1cc
where count_lifetime_orders is null



  
  
      
    ) dbt_internal_test