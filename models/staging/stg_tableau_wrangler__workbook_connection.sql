with source as (

    select * from {{ source('tableau_wrangler', 'workbook_connection') }}

),

fields as (

    select
        id,
        "NAME",
        caption,
        "AUTHENTICATION",
        updated_at,
        class_,
        dataserver_permissions,
        dbname,
        directory,
        initial_sql,
        channel,
        query_band,
        "SERVER",
        port,
        server_oauth,
        workgroup_auth_mode,
        lower(username) as username,
        wb_id,
        ds_id
    from source

)

select * from fields
