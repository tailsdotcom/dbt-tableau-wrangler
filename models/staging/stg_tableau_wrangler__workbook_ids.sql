with source as (

    select * from {{ source('tableau_wrangler', 'workbook_ids') }}

),

fields as (

    select
        observed_at,
        workbook_ids
    from source

)

select * from fields