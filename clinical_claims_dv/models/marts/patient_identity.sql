{{ config(
    materialized='view',
    grants={'select': ['PHI_READER']},
    post_hook=["alter view {{ this }} add row access policy {{ target.database }}.GOVERNANCE.PHI_ONLY on (PATIENT_ID)"]
) }}

-- Identified patient lookup for the PHI agent: resolves names / birth date / location to PATIENT_ID.
-- Rows are returned only when PHI_READER is in session (row access policy PHI_ONLY);
-- name and birth-date columns are additionally masked by the SENSITIVITY tag.
select
    PATIENT_ID,
    FIRST_NAME,
    LAST_NAME,
    FIRST_NAME || ' ' || LAST_NAME as FULL_NAME,
    BIRTHDATE,
    GENDER,
    AGE,
    AGE_BAND,
    CITY,
    COUNTY,
    STATE,
    IS_ALIVE
from {{ ref('dim_patient') }}
