with workbook_table_reference as (

    select * from {{ ref('stg_tableau_wrangler__workbook_table_reference') }}

)

select * from workbook_table_reference