
    
    

select
    supply_id as unique_field,
    count(*) as n_records

from DEV.DATAFOLD_TMP.stg_supplies_2e88025c_upstream
where supply_id is not null
group by supply_id
having count(*) > 1


