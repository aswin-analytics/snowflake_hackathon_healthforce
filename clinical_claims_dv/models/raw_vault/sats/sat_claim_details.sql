{%- set source_model = "stg_claims" -%}
{%- set src_pk = "CLAIM_HK" -%}
{%- set src_hashdiff = "CLAIM_HASHDIFF" -%}
{%- set src_payload = ["PRIMARY_PATIENT_INSURANCE_ID", "SECONDARY_PATIENT_INSURANCE_ID", "DEPARTMENTID", "PATIENTDEPARTMENTID", "DIAGNOSIS1", "DIAGNOSIS2", "DIAGNOSIS3", "DIAGNOSIS4", "DIAGNOSIS5", "DIAGNOSIS6", "DIAGNOSIS7", "DIAGNOSIS8", "REFERRING_PROVIDER_ID", "CURRENTILLNESSDATE", "SERVICEDATE", "SUPERVISING_PROVIDER_ID", "STATUS1", "STATUS2", "STATUSP", "OUTSTANDING1", "OUTSTANDING2", "OUTSTANDINGP", "LASTBILLEDDATE1", "LASTBILLEDDATE2", "LASTBILLEDDATEP", "HEALTHCARECLAIMTYPEID1", "HEALTHCARECLAIMTYPEID2", "SYNTHEA_CITY"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                    src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model) }}
