with stg_workbook as (

    select * from {{ ref('stg_tableau_wrangler__workbook') }}

),

stg_workbook_ids as (

    select * from {{ ref('stg_tableau_wrangler__workbook_ids') }}

),

latest_workbook_ids as (

    select
        trim(f.value, '"') as workbook_id,
        False as is_deleted
    from stg_workbook_ids,
        lateral flatten(stg_workbook_ids.workbook_ids) f
    where
        observed_at = (select max(observed_at) from stg_workbook_ids)

),

int_workbook as (

    select
        wb.*,
        case
            when lwb.is_deleted is Null then True
            else lwb.is_deleted
        end as is_deleted
    from stg_workbook as wb
        left join latest_workbook_ids as lwb on wb.id = lwb.workbook_id

)

select * from int_workbook