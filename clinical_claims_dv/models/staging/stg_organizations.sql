{%- set yaml_metadata -%}
source_model: base_organizations
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.ORGANIZATIONS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "{{ load_datetime() }}"
hashed_columns:
  ORGANIZATION_HK: ORGANIZATION_ID
  ORGANIZATION_HASHDIFF:
    is_hashdiff: true
    columns:
      - NAME
      - ADDRESS
      - CITY
      - STATE
      - ZIP
      - LAT
      - LON
      - PHONE
      - REVENUE
      - UTILIZATION
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
