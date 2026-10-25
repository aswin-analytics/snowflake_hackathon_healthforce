{%- set source_model = "stg_claims_tx" -%}
{%- set src_pk = "CLAIM_TX_HK" -%}
{%- set src_hashdiff = "CLAIM_TX_HASHDIFF" -%}
{%- set src_payload = ["CHARGEID", "TYPE", "AMOUNT", "METHOD", "FROMDATE", "TODATE", "PLACE_OF_SERVICE_ID", "PROCEDURECODE", "MODIFIER1", "MODIFIER2", "DIAGNOSISREF1", "DIAGNOSISREF2", "DIAGNOSISREF3", "DIAGNOSISREF4", "UNITS", "DEPARTMENTID", "NOTES", "UNITAMOUNT", "TRANSFEROUTID", "TRANSFERTYPE", "PAYMENTS", "ADJUSTMENTS", "TRANSFERS", "OUTSTANDING", "ENCOUNTER_ID", "LINENOTE", "FEESCHEDULEID", "PROVIDER_ID", "SUPERVISING_PROVIDER_ID", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
