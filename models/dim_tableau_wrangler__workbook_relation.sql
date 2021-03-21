with workbook_relation as (

    select * from {{ ref('stg_tableau_wrangler__workbook_relation') }}

)

select * from workbook_relation