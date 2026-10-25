{%- set yaml_metadata -%}
source_model: base_conditions
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.CONDITIONS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(CONDITION_START), {{ load_datetime() }})"
hashed_columns:
  CONDITION_HK: CONDITION_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_CONDITION_PATIENT_ENCOUNTER_HK:
    - CONDITION_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  CONDITION_HASHDIFF:
    is_hashdiff: true
    columns:
      - CONDITION_START
      - CONDITION_STOP
      - SYSTEM
      - CODE
      - DESCRIPTION
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
