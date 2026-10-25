{%- set yaml_metadata -%}
source_model: base_claims
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.CLAIMS'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(SERVICEDATE), {{ load_datetime() }})"
hashed_columns:
  CLAIM_HK: CLAIM_ID
  PATIENT_HK: PATIENT_ID
  PROVIDER_HK: PROVIDER_ID
  ENCOUNTER_HK: ENCOUNTER_ID
  LNK_CLAIM_PATIENT_PROVIDER_ENCOUNTER_HK:
    - CLAIM_ID
    - PATIENT_ID
    - PROVIDER_ID
    - ENCOUNTER_ID
  CLAIM_HASHDIFF:
    is_hashdiff: true
    columns:
      - PRIMARY_PATIENT_INSURANCE_ID
      - SECONDARY_PATIENT_INSURANCE_ID
      - DEPARTMENTID
      - PATIENTDEPARTMENTID
      - DIAGNOSIS1
      - DIAGNOSIS2
      - DIAGNOSIS3
      - DIAGNOSIS4
      - DIAGNOSIS5
      - DIAGNOSIS6
      - DIAGNOSIS7
      - DIAGNOSIS8
      - REFERRING_PROVIDER_ID
      - CURRENTILLNESSDATE
      - SERVICEDATE
      - SUPERVISING_PROVIDER_ID
      - STATUS1
      - STATUS2
      - STATUSP
      - OUTSTANDING1
      - OUTSTANDING2
      - OUTSTANDINGP
      - LASTBILLEDDATE1
      - LASTBILLEDDATE2
      - LASTBILLEDDATEP
      - HEALTHCARECLAIMTYPEID1
      - HEALTHCARECLAIMTYPEID2
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
