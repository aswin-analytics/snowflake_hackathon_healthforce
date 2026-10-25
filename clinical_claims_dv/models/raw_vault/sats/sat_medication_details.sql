{%- set source_model = "stg_medications" -%}
{%- set src_pk = "MEDICATION_HK" -%}
{%- set src_hashdiff = "MEDICATION_HASHDIFF" -%}
{%- set src_payload = ["MED_START", "MED_STOP", "PAYER_ID", "CODE", "DESCRIPTION", "BASE_COST", "PAYER_COVERAGE", "DISPENSES", "TOTALCOST", "REASONCODE", "REASONDESCRIPTION", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
