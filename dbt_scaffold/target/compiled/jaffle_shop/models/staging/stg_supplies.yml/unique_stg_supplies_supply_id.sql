
    
    

select
    supply_id as unique_field,
    count(*) as n_records

from DEV.STAGING_staging.stg_supplies
where supply_id is not null
group by supply_id
having count(*) > 1


