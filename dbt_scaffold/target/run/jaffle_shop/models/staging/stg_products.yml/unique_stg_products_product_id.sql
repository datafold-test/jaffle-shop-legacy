
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    product_id as unique_field,
    count(*) as n_records

from DEV.DATAFOLD_TMP.stg_products_b2ad6c28
where product_id is not null
group by product_id
having count(*) > 1



  
  
      
    ) dbt_internal_test