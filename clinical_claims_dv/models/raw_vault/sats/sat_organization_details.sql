{%- set source_model = "stg_organizations" -%}
{%- set src_pk = "ORGANIZATION_HK" -%}
{%- set src_hashdiff = "ORGANIZATION_HASHDIFF" -%}
{%- set src_payload = ["NAME", "ADDRESS", "CITY", "STATE", "ZIP", "LAT", "LON", "PHONE", "REVENUE", "UTILIZATION", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
