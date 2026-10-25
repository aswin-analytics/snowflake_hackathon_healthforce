{%- set yaml_metadata -%}
source_model: base_encounters
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.ENCOUNTERS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(ENCOUNTER_START), {{ load_datetime() }})"
hashed_columns:
  ENCOUNTER_HK: ENCOUNTER_ID
  PATIENT_HK: PATIENT_ID
  PROVIDER_HK: PROVIDER_ID
  ORGANIZATION_HK: ORGANIZATION_ID
  PAYER_HK: PAYER_ID
  LNK_ENCOUNTER_PATIENT_PROVIDER_ORGANIZATION_PAYER_HK:
    - ENCOUNTER_ID
    - PATIENT_ID
    - PROVIDER_ID
    - ORGANIZATION_ID
    - PAYER_ID
  ENCOUNTER_HASHDIFF:
    is_hashdiff: true
    columns:
      - ENCOUNTER_START
      - ENCOUNTER_STOP
      - ENCOUNTERCLASS
      - CODE
      - DESCRIPTION
      - BASE_ENCOUNTER_COST
      - TOTAL_CLAIM_COST
      - PAYER_COVERAGE
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
