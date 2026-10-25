{{ config(materialized='view') }}

-- Current state of each patient: latest details + PII satellite rows
with det as (
    select * from {{ ref('sat_patient_details') }}
    qualify row_number() over (partition by PATIENT_HK order by LOAD_DATETIME desc, EFFECTIVE_FROM desc) = 1
),
pii as (
    select * from {{ ref('sat_patient_pii') }}
    qualify row_number() over (partition by PATIENT_HK order by LOAD_DATETIME desc, EFFECTIVE_FROM desc) = 1
)
select
    h.PATIENT_HK,
    h.PATIENT_ID,
    det.BIRTHDATE, det.DEATHDATE, det.GENDER, det.RACE, det.ETHNICITY, det.MARITAL,
    datediff(year, det.BIRTHDATE, coalesce(det.DEATHDATE, current_date())) as AGE,
    det.DEATHDATE is null as IS_ALIVE,
    det.CITY, det.STATE, det.COUNTY,
    det.HEALTHCARE_EXPENSES, det.HEALTHCARE_COVERAGE, det.INCOME,
    pii.FIRST, pii.LAST, pii.ADDRESS, pii.ZIP
from {{ ref('hub_patient') }} h
left join det on det.PATIENT_HK = h.PATIENT_HK
left join pii on pii.PATIENT_HK = h.PATIENT_HK
