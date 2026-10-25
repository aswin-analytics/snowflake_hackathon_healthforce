-- Encounter fact with resolved patient / provider / organization / payer keys and latest attributes
with det as (
    select * from {{ ref('sat_encounter_details') }}
    qualify row_number() over (partition by ENCOUNTER_HK order by LOAD_DATETIME desc) = 1
)
select
    h.ENCOUNTER_HK,
    h.ENCOUNTER_ID,
    l.PATIENT_HK, l.PROVIDER_HK, l.ORGANIZATION_HK, l.PAYER_HK,
    det.ENCOUNTER_START, det.ENCOUNTER_STOP,
    datediff(minute, det.ENCOUNTER_START, det.ENCOUNTER_STOP) as DURATION_MIN,
    det.ENCOUNTERCLASS, det.CODE, det.DESCRIPTION,
    det.BASE_ENCOUNTER_COST, det.TOTAL_CLAIM_COST, det.PAYER_COVERAGE,
    det.TOTAL_CLAIM_COST - det.PAYER_COVERAGE as PATIENT_RESPONSIBILITY,
    det.REASONCODE, det.REASONDESCRIPTION
from {{ ref('hub_encounter') }} h
left join {{ ref('lnk_encounter_patient_provider_organization_payer') }} l on l.ENCOUNTER_HK = h.ENCOUNTER_HK
left join det on det.ENCOUNTER_HK = h.ENCOUNTER_HK
