
    
    

select
    supply_id as unique_field,
    count(*) as n_records

from JAFFLE_SHOP.DATAFOLD_TMP.stg_supplies_9abd86f1
where supply_id is not null
group by supply_id
having count(*) > 1


