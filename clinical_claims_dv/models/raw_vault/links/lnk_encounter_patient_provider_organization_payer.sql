{%- set source_model = "stg_encounters" -%}
{%- set src_pk = "LNK_ENCOUNTER_PATIENT_PROVIDER_ORGANIZATION_PAYER_HK" -%}
{%- set src_fk = ["ENCOUNTER_HK", "PATIENT_HK", "PROVIDER_HK", "ORGANIZATION_HK", "PAYER_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                     src_source=src_source, source_model=source_model) }}
