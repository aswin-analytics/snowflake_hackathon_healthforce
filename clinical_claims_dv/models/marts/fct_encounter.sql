-- Encounter fact: one row per encounter with business keys of all participants
select
    he.ENCOUNTER_ID,
    hp.PATIENT_ID,
    hpr.PROVIDER_ID,
    ho.ORGANIZATION_ID,
    hpy.PAYER_ID,
    e.ENCOUNTER_START,
    e.ENCOUNTER_STOP,
    e.ENCOUNTER_START::date                  as ENCOUNTER_DATE,
    date_trunc('month', e.ENCOUNTER_START)::date as ENCOUNTER_MONTH,
    e.DURATION_MIN,
    e.ENCOUNTERCLASS                         as ENCOUNTER_CLASS,
    e.CODE                                   as ENCOUNTER_CODE,
    e.DESCRIPTION                            as ENCOUNTER_DESCRIPTION,
    e.REASONDESCRIPTION                      as REASON_DESCRIPTION,
    e.BASE_ENCOUNTER_COST,
    e.TOTAL_CLAIM_COST,
    e.PAYER_COVERAGE,
    e.PATIENT_RESPONSIBILITY
from {{ ref('bv_encounter_enriched') }} e
join {{ ref('hub_encounter') }} he on he.ENCOUNTER_HK = e.ENCOUNTER_HK
left join {{ ref('hub_patient') }} hp on hp.PATIENT_HK = e.PATIENT_HK
left join {{ ref('hub_provider') }} hpr on hpr.PROVIDER_HK = e.PROVIDER_HK
left join {{ ref('hub_organization') }} ho on ho.ORGANIZATION_HK = e.ORGANIZATION_HK
left join {{ ref('hub_payer') }} hpy on hpy.PAYER_HK = e.PAYER_HK
