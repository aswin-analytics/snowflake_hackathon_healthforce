{%- set yaml_metadata -%}
source_model: base_immunizations
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.IMMUNIZATIONS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(IMMUNIZATION_DATE), {{ load_datetime() }})"
hashed_columns:
  IMMUNIZATION_HK: IMMUNIZATION_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_IMMUNIZATION_PATIENT_ENCOUNTER_HK:
    - IMMUNIZATION_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  IMMUNIZATION_HASHDIFF:
    is_hashdiff: true
    columns:
      - IMMUNIZATION_DATE
      - PATIENT
      - ENCOUNTER
      - CODE
      - DESCRIPTION
      - BASE_COST
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
