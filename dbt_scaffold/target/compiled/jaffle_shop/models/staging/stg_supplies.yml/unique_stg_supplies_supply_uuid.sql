
    
    

select
    supply_uuid as unique_field,
    count(*) as n_records

from JAFFLE_SHOP.DATAFOLD_TMP.stg_supplies_9abd86f1
where supply_uuid is not null
group by supply_uuid
having count(*) > 1


