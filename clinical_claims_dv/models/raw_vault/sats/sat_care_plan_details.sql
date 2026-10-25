{%- set source_model = "stg_care_plans" -%}
{%- set src_pk = "CARE_PLAN_HK" -%}
{%- set src_hashdiff = "CARE_PLAN_HASHDIFF" -%}
{%- set src_payload = ["CAREPLAN_START", "CAREPLAN_STOP", "CODE", "DESCRIPTION", "REASONCODE", "REASONDESCRIPTION", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
