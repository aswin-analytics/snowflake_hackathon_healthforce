{{ config(materialized='pit_incremental') }}

{%- set source_model = "hub_patient" -%}
{%- set src_pk = "PATIENT_HK" -%}
{%- set as_of_dates_table = "as_of_date" -%}
{%- set satellites = {
    "sat_patient_details": {"pk": {"PK": "PATIENT_HK"}, "ldts": {"LDTS": "LOAD_DATETIME"}},
    "sat_patient_pii":     {"pk": {"PK": "PATIENT_HK"}, "ldts": {"LDTS": "LOAD_DATETIME"}}
} -%}
{%- set stage_tables_ldts = {"stg_patients": "LOAD_DATETIME"} -%}
{%- set src_ldts = "LOAD_DATETIME" -%}

{{ automate_dv.pit(source_model=source_model, src_pk=src_pk,
                   as_of_dates_table=as_of_dates_table,
                   satellites=satellites,
                   stage_tables_ldts=stage_tables_ldts,
                   src_ldts=src_ldts) }}


select * from CLINICAL_CLAIMS_DV.BUSINESS_VAULT.PIT_PATIENT;