{%- set source_model = "stg_claims" -%}
{%- set src_pk = "LNK_CLAIM_PATIENT_PROVIDER_ENCOUNTER_HK" -%}
{%- set src_fk = ["CLAIM_HK", "PATIENT_HK", "PROVIDER_HK", "ENCOUNTER_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                     src_source=src_source, source_model=source_model) }}
