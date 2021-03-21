with connection as (

    select * from {{ ref('dim_tableau_wrangler__workbook_connection') }}

),

relation as (

    select * from {{ ref('dim_tableau_wrangler__workbook_relation') }}

),

table_refs as (

    select * from {{ ref('dim_tableau_wrangler__workbook_table_reference') }}

),

relation_table_refs as (

    select
        relation.wb_id,
        relation.ds_id,
        relation.conn_id,
        relation.id as rel_id,
        connection.dbname as conn_dbname,
        split(lower(
            replace(
                replace(
                    relation."TABLE", '[', ''
                ),
                ']', ''
            )
        ), '.') as table_ref
    from relation
        left join connection on relation.conn_id = connection.id
    where
        relation."TYPE" in ('table')
        and connection.class_ in ('mysql', 'snowflake', 'postgres')

),

text_table_refs as (

    select
        relation.wb_id,
        relation.ds_id,
        relation.conn_id,
        relation.id as rel_id,
        connection.dbname as conn_dbname,
        split(lower(table_refs.ref), '.') as table_ref
    from table_refs
        left join relation on table_refs.rel_id = relation.id
        left join connection on table_refs.conn_id = connection.id
    where
        connection.class_ in ('mysql', 'snowflake', 'postgres')
),

combined_table_refs as (

    select * from relation_table_refs
    union distinct
    select * from text_table_refs

),

expanded_table_refs as (

    select
        wb_id,
        ds_id,
        conn_id,
        rel_id,
        coalesce(
            table_ref[array_size(table_ref)-3]::varchar,
            lower(conn_dbname)
        ) as ref_database,
        coalesce(
            table_ref[array_size(table_ref)-2]::varchar,
            'public'
        ) as ref_schema,
        table_ref[array_size(table_ref)-1]::varchar as ref_table
    from combined_table_refs

),

base_table_refs as (

    select
        wb_id,
        ds_id,
        conn_id,
        rel_id,
        regexp_replace(ref_database, '[^0-9a-zA-Z_]+', '') as ref_database,
        regexp_replace(ref_schema, '[^0-9a-zA-Z_]+', '') as ref_schema,
        regexp_replace(ref_table, '[^0-9a-zA-Z_]+', '') as ref_table
    from expanded_table_refs

),

workbook_table as (

    select
        *,
        ref_database || '.' || ref_schema || '.' || ref_table as relation
    from base_table_refs
)

select * from workbook_table