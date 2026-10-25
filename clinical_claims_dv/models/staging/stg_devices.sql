{%- set yaml_metadata -%}
source_model: base_devices
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.DEVICES'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(DEVICE_START), {{ load_datetime() }})"
hashed_columns:
  DEVICE_HK: DEVICE_ID
  PATIENT_HK: PATIENT_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_DEVICE_PATIENT_ENCOUNTER_HK:
    - DEVICE_ID
    - PATIENT_ID
    - ENCOUNTER_ID
  DEVICE_HASHDIFF:
    is_hashdiff: true
    columns:
      - DEVICE_START
      - DEVICE_STOP
      - CODE
      - DESCRIPTION
      - UDI
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
