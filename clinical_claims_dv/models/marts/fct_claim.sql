-- Claim fact: claim header with rolled-up transaction financials
select
    c.CLAIM_ID,
    hp.PATIENT_ID,
    hpr.PROVIDER_ID,
    he.ENCOUNTER_ID,
    c.SERVICEDATE::date                        as SERVICE_DATE,
    date_trunc('month', c.SERVICEDATE)::date   as SERVICE_MONTH,
    c.STATUS1                                  as PRIMARY_STATUS,
    c.STATUS2                                  as SECONDARY_STATUS,
    c.STATUSP                                  as PATIENT_STATUS,
    coalesce(c.TX_COUNT, 0)                    as TRANSACTION_COUNT,
    coalesce(c.TOTAL_CHARGED, 0)               as TOTAL_CHARGED,
    coalesce(c.TOTAL_PAYMENTS, 0)              as TOTAL_PAYMENTS,
    coalesce(c.TOTAL_ADJUSTMENTS, 0)           as TOTAL_ADJUSTMENTS,
    coalesce(c.TOTAL_OUTSTANDING, 0)           as TOTAL_OUTSTANDING,
    coalesce(c.OUTSTANDING1, 0) + coalesce(c.OUTSTANDING2, 0) + coalesce(c.OUTSTANDINGP, 0) as HEADER_OUTSTANDING
from {{ ref('bv_claim_financials') }} c
left join {{ ref('hub_patient') }} hp on hp.PATIENT_HK = c.PATIENT_HK
left join {{ ref('hub_provider') }} hpr on hpr.PROVIDER_HK = c.PROVIDER_HK
left join {{ ref('hub_encounter') }} he on he.ENCOUNTER_HK = c.ENCOUNTER_HK
