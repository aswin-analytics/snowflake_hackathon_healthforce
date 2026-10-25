{%- set yaml_metadata -%}
source_model: base_care_plans
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.CARE_PLANS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(CAREPLAN_START), {{ load_datetime() }})"
hashed_columns:
  CARE_PLAN_HK: CARE_PLAN_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_CARE_PLAN_PATIENT_ENCOUNTER_HK:
    - CARE_PLAN_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  CARE_PLAN_HASHDIFF:
    is_hashdiff: true
    columns:
      - CAREPLAN_START
      - CAREPLAN_STOP
      - CODE
      - DESCRIPTION
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
