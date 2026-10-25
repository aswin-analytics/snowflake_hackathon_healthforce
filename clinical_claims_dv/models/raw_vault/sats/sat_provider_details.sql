{%- set source_model = "stg_providers" -%}
{%- set src_pk = "PROVIDER_HK" -%}
{%- set src_hashdiff = "PROVIDER_HASHDIFF" -%}
{%- set src_payload = ["NAME", "GENDER", "SPECIALITY", "ADDRESS", "CITY", "STATE", "ZIP", "LAT", "LON", "ENCOUNTERS", "PROCEDURES", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
