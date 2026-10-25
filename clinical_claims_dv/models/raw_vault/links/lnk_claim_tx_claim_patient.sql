{%- set source_model = "stg_claims_tx" -%}
{%- set src_pk = "LNK_CLAIM_TX_CLAIM_PATIENT_HK" -%}
{%- set src_fk = ["CLAIM_TX_HK", "CLAIM_HK", "PATIENT_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                     src_source=src_source, source_model=source_model) }}
