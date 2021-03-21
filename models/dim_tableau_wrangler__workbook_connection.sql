with workbook_connection as (

    select * from {{ ref('stg_tableau_wrangler__workbook_connection') }}

)

select * from workbook_connection