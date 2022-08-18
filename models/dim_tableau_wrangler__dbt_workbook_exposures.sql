
with workbook_table as (

    select * from {{ ref('int_tableau_wrangler__workbook_table') }}

),

workbook_connection as (

    select * from {{ ref('dim_tableau_wrangler__workbook_connection') }}

),

dbt_models as (

    select * from {{ ref('dim_dbt__models') }}

),

dbt_sources as (

    select * from {{ ref('dim_dbt__sources') }}

),

dbt_workbook_relations as (

    select
        workbook_table.wb_id,
        workbook_table.relation
    from workbook_table
        left join workbook_connection on workbook_table.conn_id = workbook_connection.id
    where
    {%- set tb_server = var('tableau_wrangler_dbt_connection_server', False) %}
    {%- if tb_server %}
        workbook_connection.server = '{{ tb_server }}'
    {% else %}
        workbook_connection.class_ = 'snowflake'
    {%- endif %}

),

dbt_nodes as (

    -- dbt models
    select
        model_execution_id as manifest_node_id,
        name as node_name,
        NULL::string as source_name,
    {%- if var("dbt_override_db", False) %}
        '{{ var("dbt_override_db") }}' || '.' || schema || '.' || name as relation,
    {% else %}
        model_database || '.' || schema || '.' || name as relation,
    {% endif -%}
        'model' as node_type
    from dbt_models
    where
        run_started_at = (select max(run_started_at) from dbt_models)

    union all

    -- dbt sources
    select
        source_execution_id as manifest_node_id,
        name as node_name,
        source_name,
        relation_name as relation,
        'source' as node_type
    from dbt_sources
    where
        run_started_at = (select max(run_started_at) from dbt_sources)

),

workbook_dbt_models as (

    select
        -- workbook details
        dbt_workbook_relations.wb_id,
        -- dbt model details
        dbt_nodes.node_name,
        dbt_nodes.source_name,
        dbt_nodes.node_type,
        dbt_nodes.manifest_node_id
    from dbt_workbook_relations
        inner join dbt_nodes on dbt_workbook_relations.relation = dbt_nodes.relation

)

select * from workbook_dbt_models