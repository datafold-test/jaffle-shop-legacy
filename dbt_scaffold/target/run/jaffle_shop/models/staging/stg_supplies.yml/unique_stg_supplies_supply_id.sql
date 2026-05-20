

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    supply_id as unique_field,
    count(*) as n_records

from JAFFLE_SHOP.DATAFOLD_TMP.stg_supplies_4f463626f0a04380a6c8fc2aa2bbfa72
where supply_id is not null
group by supply_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
