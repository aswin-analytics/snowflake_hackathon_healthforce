{%- set source_model = "stg_observations" -%}
{%- set src_pk = "LNK_OBSERVATION_PATIENT_ENCOUNTER_HK" -%}
{%- set src_fk = ["OBSERVATION_HK", "PATIENT_HK", "ENCOUNTER_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                     src_source=src_source, source_model=source_model) }}
