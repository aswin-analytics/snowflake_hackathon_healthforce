{%- set yaml_metadata -%}
source_model: base_imaging_studies
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.IMAGING_STUDIES'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(IMAGE_DATE), {{ load_datetime() }})"
hashed_columns:
  IMAGING_STUDY_HK: IMAGING_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_IMAGING_STUDY_PATIENT_ENCOUNTER_HK:
    - IMAGING_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  IMAGING_STUDY_HASHDIFF:
    is_hashdiff: true
    columns:
      - ID
      - IMAGE_DATE
      - SERIES_UID
      - BODYSITE_CODE
      - BODYSITE_DESCRIPTION
      - MODALITY_CODE
      - MODALITY_DESCRIPTION
      - INSTANCE_UID
      - SOP_CODE
      - SOP_DESCRIPTION
      - PROCEDURE_CODE
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
