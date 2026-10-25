{%- set yaml_metadata -%}
source_model: base_claims_tx
derived_columns:
  RECORD_SOURCE: '!SYNTHEA_SILVER.CLAIMS_TX'
  LOAD_DATETIME: "{{ load_datetime() }}"
  EFFECTIVE_FROM: "COALESCE(TO_TIMESTAMP_NTZ(FROMDATE), {{ load_datetime() }})"
hashed_columns:
  CLAIM_TX_HK: CLAIMS_TX_ID
  CLAIM_HK: CLAIM_ID
  PATIENT_HK: PATIENT_ID
  LNK_CLAIM_TX_CLAIM_PATIENT_HK:
    - CLAIMS_TX_ID
    - CLAIM_ID
    - PATIENT_ID
  CLAIM_TX_HASHDIFF:
    is_hashdiff: true
    columns:
      - CHARGEID
      - TYPE
      - AMOUNT
      - METHOD
      - FROMDATE
      - TODATE
      - PLACE_OF_SERVICE_ID
      - PROCEDURECODE
      - MODIFIER1
      - MODIFIER2
      - DIAGNOSISREF1
      - DIAGNOSISREF2
      - DIAGNOSISREF3
      - DIAGNOSISREF4
      - UNITS
      - DEPARTMENTID
      - NOTES
      - UNITAMOUNT
      - TRANSFEROUTID
      - TRANSFERTYPE
      - PAYMENTS
      - ADJUSTMENTS
      - TRANSFERS
      - OUTSTANDING
      - ENCOUNTER_ID
      - LINENOTE
      - FEESCHEDULEID
      - PROVIDER_ID
      - SUPERVISING_PROVIDER_ID
      - SYNTHEA_CITY
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     null_columns=none,
                     hashed_columns=metadata_dict['hashed_columns'],
                     ranked_columns=none) }}
