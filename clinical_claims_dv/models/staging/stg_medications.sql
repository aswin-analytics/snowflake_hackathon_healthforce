{%- set yaml_metadata -%}
source_model: base_medications
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.MEDICATIONS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(MED_START), {{ load_datetime() }})"
hashed_columns:
  MEDICATION_HK: MEDICATION_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_MEDICATION_PATIENT_ENCOUNTER_HK:
    - MEDICATION_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  MEDICATION_HASHDIFF:
    is_hashdiff: true
    columns:
      - MED_START
      - MED_STOP
      - PAYER_ID
      - CODE
      - DESCRIPTION
      - BASE_COST
      - PAYER_COVERAGE
      - DISPENSES
      - TOTALCOST
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
