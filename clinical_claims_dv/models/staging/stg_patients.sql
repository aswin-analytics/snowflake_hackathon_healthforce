{%- set yaml_metadata -%}
source_model: base_patients
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.PATIENTS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(BIRTHDATE), {{ load_datetime() }})"
hashed_columns:
  PATIENT_HK: PATIENT_ID
  PATIENT_HASHDIFF:
    is_hashdiff: true
    columns:
      - BIRTHDATE
      - DEATHDATE
      - PREFIX
      - SUFFIX
      - MARITAL
      - RACE
      - ETHNICITY
      - GENDER
      - BIRTHPLACE
      - CITY
      - STATE
      - COUNTY
      - FIPS
      - HEALTHCARE_EXPENSES
      - HEALTHCARE_COVERAGE
      - INCOME
      - SYNTHEA_CITY
  PATIENT_PII_HASHDIFF:
    is_hashdiff: true
    columns:
      - SSN
      - DRIVERS
      - PASSPORT
      - FIRST
      - MIDDLE
      - LAST
      - MAIDEN
      - ADDRESS
      - LAT
      - LON
      - ZIP
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
