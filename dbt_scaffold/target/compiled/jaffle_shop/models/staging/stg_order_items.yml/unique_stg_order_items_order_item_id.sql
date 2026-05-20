
    
    

select
    order_item_id as unique_field,
    count(*) as n_records

from JAFFLE_SHOP.DATAFOLD_TMP_DATAFOLD_TMP.stg_order_items_af9983e1
where order_item_id is not null
group by order_item_id
having count(*) > 1


