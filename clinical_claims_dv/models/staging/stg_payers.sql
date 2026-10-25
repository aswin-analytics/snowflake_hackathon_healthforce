{%- set yaml_metadata -%}
source_model: base_payers
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.PAYERS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "{{ load_datetime() }}"
hashed_columns:
  PAYER_HK: PAYER_ID
  PAYER_HASHDIFF:
    is_hashdiff: true
    columns:
      - NAME
      - ADDRESS
      - CITY
      - STATE_HEADQUARTERED
      - ZIP
      - PHONE
      - AMOUNT_COVERED
      - AMOUNT_UNCOVERED
      - REVENUE
      - COVERED_ENCOUNTERS
      - UNCOVERED_ENCOUNTERS
      - COVERED_MEDICATIONS
      - UNCOVERED_MEDICATIONS
      - COVERED_PROCEDURES
      - UNCOVERED_PROCEDURES
      - COVERED_IMMUNIZATIONS
      - UNCOVERED_IMMUNIZATIONS
      - UNIQUE_CUSTOMERS
      - QOLS_AVG
      - MEMBER_MONTHS
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
