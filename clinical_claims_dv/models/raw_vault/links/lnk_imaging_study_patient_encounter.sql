{%- set source_model = "stg_imaging_studies" -%}
{%- set src_pk = "LNK_IMAGING_STUDY_PATIENT_ENCOUNTER_HK" -%}
{%- set src_fk = ["IMAGING_STUDY_HK", "PATIENT_HK", "ENCOUNTER_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                     src_source=src_source, source_model=source_model) }}
