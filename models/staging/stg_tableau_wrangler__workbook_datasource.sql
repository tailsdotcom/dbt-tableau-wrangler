with source as (

    select * from {{ source('tableau_wrangler', 'workbook_datasource') }}

),

fields as (

    select
        id,
        name,
        caption,
        updated_at,
        version,
        wb_id
    from source

)

select * from fields
