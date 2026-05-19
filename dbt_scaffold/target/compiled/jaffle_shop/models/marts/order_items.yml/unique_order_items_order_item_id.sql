
    
    

select
    order_item_id as unique_field,
    count(*) as n_records

from DEV.DATAFOLD_TMP.order_items_6753cba2
where order_item_id is not null
group by order_item_id
having count(*) > 1


