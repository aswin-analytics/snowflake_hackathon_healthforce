{%- set source_model = "stg_payer_transitions" -%}
{%- set src_pk = "PAYER_TRANSITION_HK" -%}
{%- set src_hashdiff = "PAYER_TRANSITION_HASHDIFF" -%}
{%- set src_payload = ["MEMBER_ID", "START_YEAR", "END_YEAR", "SECONDARY_PAYER_ID", "OWNERSHIP_TYPE", "OWNER_NAME", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
