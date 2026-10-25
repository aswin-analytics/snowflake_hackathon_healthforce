{%- set source_model = "stg_devices" -%}
{%- set src_pk = "DEVICE_HK" -%}
{%- set src_hashdiff = "DEVICE_HASHDIFF" -%}
{%- set src_payload = ["DEVICE_START", "DEVICE_STOP", "CODE", "DESCRIPTION", "UDI", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
