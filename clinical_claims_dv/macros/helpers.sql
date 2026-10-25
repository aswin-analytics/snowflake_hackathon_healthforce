{# Write models to the exact custom schema (STAGING / RAW_VAULT / BUSINESS_VAULT) instead of <target>_<custom>. #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim | upper }}
    {%- endif -%}
{%- endmacro %}

{# Source has no load timestamp, so every row in a run gets the run start time. #}
{% macro load_datetime() -%}
    TO_TIMESTAMP_NTZ('{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}')
{%- endmacro %}

{# Key-aligned dev sample: keep every row belonging to 1-in-N patients so hubs, links and sats join.
   Tables without PATIENT_ID (providers, organizations, payers) are loaded in full.
   Set var patient_sample_mod to none for a full load. #}
{% macro dev_sample(has_patient=true) -%}
    {%- set n = var('patient_sample_mod', none) -%}
    {%- if n is not none and has_patient -%} where mod(PATIENT_ID, {{ n }}) = 0 {%- endif -%}
{%- endmacro %}
