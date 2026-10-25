{%- set yaml_metadata -%}
source_model: base_procedures
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.PROCEDURES'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(PROC_START), {{ load_datetime() }})"
hashed_columns:
  PROCEDURE_HK: PROCEDURE_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_PROCEDURE_PATIENT_ENCOUNTER_HK:
    - PROCEDURE_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  PROCEDURE_HASHDIFF:
    is_hashdiff: true
    columns:
      - PROC_START
      - PROC_STOP
      - CODE
      - DESCRIPTION
      - BASE_COST
      - REASONCODE
      - REASONDESCRIPTION
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
