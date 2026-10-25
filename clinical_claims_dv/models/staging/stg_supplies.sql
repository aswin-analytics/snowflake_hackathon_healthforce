{%- set yaml_metadata -%}
source_model: base_supplies
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.SUPPLIES'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(SUPPLY_DATE), {{ load_datetime() }})"
hashed_columns:
  SUPPLY_HK: SUPPLY_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_SUPPLY_PATIENT_ENCOUNTER_HK:
    - SUPPLY_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  SUPPLY_HASHDIFF:
    is_hashdiff: true
    columns:
      - SUPPLY_DATE
      - CODE
      - DESCRIPTION
      - QUANTITY
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
