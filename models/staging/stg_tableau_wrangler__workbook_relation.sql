with source as (

    select * from {{ source('tableau_wrangler', 'workbook_relation') }}

),

fields as (

    select
        id,
        "NAME",
        "TABLE",
        "TEXT",
        "TYPE",
        updated_at,
        connection,
        conn_id,
        ds_id,
        wb_id
    from source

)

select * from fields
