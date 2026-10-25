{%- set yaml_metadata -%}
source_model: base_providers
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.PROVIDERS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "{{ load_datetime() }}"
hashed_columns:
  PROVIDER_HK: PROVIDER_ID
  ORGANIZATION_HK: ORGANIZATION_ID
  LNK_PROVIDER_ORGANIZATION_HK:
    - PROVIDER_ID
    - ORGANIZATION_ID
  PROVIDER_HASHDIFF:
    is_hashdiff: true
    columns:
      - NAME
      - GENDER
      - SPECIALITY
      - ADDRESS
      - CITY
      - STATE
      - ZIP
      - LAT
      - LON
      - ENCOUNTERS
      - PROCEDURES
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
