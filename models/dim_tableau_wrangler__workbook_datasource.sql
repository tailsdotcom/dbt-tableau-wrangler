with workbook_datasource as (

    select * from {{ ref('stg_tableau_wrangler__workbook_datasource') }}

)

select * from workbook_datasource