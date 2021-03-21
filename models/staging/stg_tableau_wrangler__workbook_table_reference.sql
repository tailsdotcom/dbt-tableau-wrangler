with source as (

    select * from {{ source('tableau_wrangler', 'workbook_table_reference') }}

),

fields as (

    select
        id,
        ref,
        updated_at,
        conn_id,
        ds_id,
        rel_id,
        wb_id
    from source

)

select * from fields
