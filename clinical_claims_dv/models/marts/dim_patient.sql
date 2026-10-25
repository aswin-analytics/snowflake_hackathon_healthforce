{{ config(materialized='view') }}

-- Patient dimension. A view (not a table) so tag-based masking is evaluated for the querying role.
select
    PATIENT_ID,
    PATIENT_HK,
    GENDER,
    RACE,
    ETHNICITY,
    MARITAL                                   as MARITAL_STATUS,
    BIRTHDATE,
    DEATHDATE,
    AGE,
    case
        when AGE < 18 then '0-17'
        when AGE < 35 then '18-34'
        when AGE < 50 then '35-49'
        when AGE < 65 then '50-64'
        else '65+'
    end                                       as AGE_BAND,
    IS_ALIVE,
    CITY,
    COUNTY,
    STATE,
    ZIP,
    INCOME,
    HEALTHCARE_EXPENSES,
    HEALTHCARE_COVERAGE,
    FIRST                                     as FIRST_NAME,
    LAST                                      as LAST_NAME
from {{ ref('bv_patient_current') }}
