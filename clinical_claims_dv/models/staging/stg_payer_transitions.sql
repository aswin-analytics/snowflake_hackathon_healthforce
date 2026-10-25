{%- set yaml_metadata -%}
source_model: base_payer_transitions
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.PAYER_TRANSITIONS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(START_YEAR), {{ load_datetime() }})"
hashed_columns:
  PAYER_TRANSITION_HK: PAYER_TRANSITIONS_ID
  PATIENT_HK: PATIENT_ID
  PAYER_HK: PAYER_ID
  LNK_PAYER_TRANSITION_PATIENT_PAYER_HK:
    - PAYER_TRANSITIONS_ID
    - PATIENT_ID
    - PAYER_ID
  PAYER_TRANSITION_HASHDIFF:
    is_hashdiff: true
    columns:
      - MEMBER_ID
      - START_YEAR
      - END_YEAR
      - SECONDARY_PAYER_ID
      - OWNERSHIP_TYPE
      - OWNER_NAME
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
