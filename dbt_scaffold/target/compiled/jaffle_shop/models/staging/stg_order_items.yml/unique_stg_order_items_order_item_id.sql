
    
    

select
    order_item_id as unique_field,
    count(*) as n_records

from DEV.DATAFOLD_TMP.stg_order_items_2e88025c_upstream
where order_item_id is not null
group by order_item_id
having count(*) > 1


