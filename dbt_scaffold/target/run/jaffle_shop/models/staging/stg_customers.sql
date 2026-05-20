
  create or replace   view DEV.DATAFOLD_TMP.stg_customers_2e88025c_upstream
  
  
  
  
  as (
    

with source as (

    select * from JAFFLE_SHOP.RAW.raw_customers

),

renamed as (

    select
        id   as customer_id,
        name as customer_name

    from source

)

select * from renamed
  );

