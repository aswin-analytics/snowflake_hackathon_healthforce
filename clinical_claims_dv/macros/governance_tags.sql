{#
  Syncs dbt metadata into Snowflake Horizon tags after each model builds.
    model meta:  data_domain, data_owner          -> DATA_DOMAIN / DATA_OWNER on the table/view
    folder:      +meta.data_layer (dbt_project.yml) -> DATA_LAYER on the table/view
    column meta: sensitivity                       -> SENSITIVITY on the column (drives tag-based masking)
  Tags live in <target.database>.GOVERNANCE.
#}
{% macro apply_governance_tags() %}
    {%- if not execute -%}{{ return('') }}{%- endif -%}
    {%- set gov = target.database ~ '.GOVERNANCE' -%}
    {%- set meta = model.config.get('meta', {}) -%}
    {%- set kind = 'VIEW' if model.config.materialized == 'view' else 'TABLE' -%}
    {%- set stmts = [] -%}

    {%- for key, tag in [('data_layer', 'DATA_LAYER'), ('data_domain', 'DATA_DOMAIN'), ('data_owner', 'DATA_OWNER')] -%}
        {%- if meta.get(key) -%}
            {%- do stmts.append("alter " ~ kind ~ " " ~ this ~ " set tag " ~ gov ~ "." ~ tag ~ " = '" ~ meta[key] ~ "'") -%}
        {%- endif -%}
    {%- endfor -%}

    {%- for col_name, col in model.columns.items() -%}
        {%- set sens = col.get('meta', {}).get('sensitivity') -%}
        {%- if sens -%}
            {%- do stmts.append("alter " ~ kind ~ " " ~ this ~ " modify column " ~ col_name ~ " set tag " ~ gov ~ ".SENSITIVITY = '" ~ sens ~ "'") -%}
        {%- endif -%}
    {%- endfor -%}

    {%- for s in stmts -%}
        {%- do run_query(s) -%}
    {%- endfor -%}
    {%- do attach_dmfs() -%}
    {{ return('select 1') }}
{% endmacro %}
