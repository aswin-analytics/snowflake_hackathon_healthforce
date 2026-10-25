{%- set source_model = "stg_allergies" -%}
{%- set src_pk = "ALLERGY_HK" -%}
{%- set src_hashdiff = "ALLERGY_HASHDIFF" -%}
{%- set src_payload = ["ALLERGY_START", "ALLERGY_STOP", "CODE", "SYSTEM", "DESCRIPTION", "TYPE", "CATEGORY", "REACTION1", "DESCRIPTION1", "SEVERITY1", "REACTION2", "DESCRIPTION2", "SEVERITY2", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}



