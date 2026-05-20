
    
    

select
    product_id as unique_field,
    count(*) as n_records

from JAFFLE_SHOP.DATAFOLD_TMP.stg_products_87ccd74e
where product_id is not null
group by product_id
having count(*) > 1


