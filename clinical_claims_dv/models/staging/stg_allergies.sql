{%- set yaml_metadata -%}
source_model: base_allergies
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.ALLERGIES'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(ALLERGY_START), {{ load_datetime() }})"
hashed_columns:
  ALLERGY_HK: ALLERGY_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_ALLERGY_PATIENT_ENCOUNTER_HK:
    - ALLERGY_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  ALLERGY_HASHDIFF:
    is_hashdiff: true
    columns:
      - ALLERGY_START
      - ALLERGY_STOP
      - CODE
      - SYSTEM
      - DESCRIPTION
      - TYPE
      - CATEGORY
      - REACTION1
      - DESCRIPTION1
      - SEVERITY1
      - REACTION2
      - DESCRIPTION2
      - SEVERITY2
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
