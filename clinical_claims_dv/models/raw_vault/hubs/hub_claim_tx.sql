{%- set source_model = "stg_claims_tx" -%}
{%- set src_pk = "CLAIM_TX_HK" -%}
{%- set src_nk = "CLAIMS_TX_ID" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                    src_source=src_source, source_model=source_model) }}
