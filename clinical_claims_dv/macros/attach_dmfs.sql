{#
  Attaches Snowflake system Data Metric Functions declared in dbt meta:
    model meta:  dmfs: [ROW_COUNT]                       -> table-level DMFs (no column)
    column meta: dmfs: [NULL_COUNT, DUPLICATE_COUNT]     -> column DMFs
  Sets DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES' and skips DMFs already attached,
  so it is safe on incremental models and on tables recreated every run. Views are skipped.
#}
{% macro attach_dmfs() %}
    {%- if not execute or model.config.materialized == 'view' -%}{{ return('') }}{%- endif -%}
    {%- set wanted = [] -%}
    {%- for fn in model.config.get('meta', {}).get('dmfs', []) -%}
        {%- do wanted.append((fn | upper, none)) -%}
    {%- endfor -%}
    {%- for col_name, col in model.columns.items() -%}
        {%- for fn in col.get('meta', {}).get('dmfs', []) -%}
            {%- do wanted.append((fn | upper, col_name | upper)) -%}
        {%- endfor -%}
    {%- endfor -%}
    {%- if wanted | length == 0 -%}{{ return('') }}{%- endif -%}

    {%- set existing_sql -%}
        select metric_name, coalesce(parse_json(ref_arguments)[0]:name::string, '') as col
        from table({{ this.database }}.information_schema.data_metric_function_references(
            ref_entity_name => '{{ this }}', ref_entity_domain => 'table'))
    {%- endset -%}
    {%- set existing = [] -%}
    {%- for r in run_query(existing_sql).rows -%}
        {%- do existing.append(r[0] ~ '|' ~ r[1]) -%}
    {%- endfor -%}

    {%- do run_query("alter table " ~ this ~ " set data_metric_schedule = 'TRIGGER_ON_CHANGES'") -%}
    {%- for fn, col in wanted -%}
        {%- if (fn ~ '|' ~ (col or '')) not in existing -%}
            {%- do run_query("alter table " ~ this ~ " add data metric function snowflake.core." ~ fn ~ " on (" ~ (col or '') ~ ")") -%}
        {%- endif -%}
    {%- endfor -%}
    {{ return('') }}
{% endmacro %}
