with source as (

    select * from {{ source('tableau_wrangler', 'workbook') }}

),

fields as (

    select
        id,
        "NAME",
        created_at,
        updated_at,
        size,
        source_build,
        source_platform,
        tags,
        project_id,
        project_name,
        content_url,
        webpage_url
    from source

)

select * from fields
