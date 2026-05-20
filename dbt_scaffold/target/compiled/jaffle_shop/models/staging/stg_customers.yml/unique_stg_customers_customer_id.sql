
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from DEV.DATAFOLD_TMP.stg_customers_2e88025c_upstream
where customer_id is not null
group by customer_id
having count(*) > 1


