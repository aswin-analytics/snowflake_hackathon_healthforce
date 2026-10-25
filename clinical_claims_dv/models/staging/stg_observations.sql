{%- set yaml_metadata -%}
source_model: base_observations
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.OBSERVATIONS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(OBSERVATION_DATE), {{ load_datetime() }})"
hashed_columns:
  OBSERVATION_HK: OBSERVATION_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_OBSERVATION_PATIENT_ENCOUNTER_HK:
    - OBSERVATION_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  OBSERVATION_HASHDIFF:
    is_hashdiff: true
    columns:
      - OBSERVATION_DATE
      - CATEGORY
      - CODE
      - DESCRIPTION
      - VALUE
      - UNITS
      - TYPE
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
