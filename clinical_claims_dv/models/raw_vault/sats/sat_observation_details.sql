{%- set source_model = "stg_observations" -%}
{%- set src_pk = "OBSERVATION_HK" -%}
{%- set src_hashdiff = "OBSERVATION_HASHDIFF" -%}
{%- set src_payload = ["OBSERVATION_DATE", "CATEGORY", "CODE", "DESCRIPTION", "VALUE", "UNITS", "TYPE", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
