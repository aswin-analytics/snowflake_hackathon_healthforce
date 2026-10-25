-- Claim-level financials: claim header + rolled-up transaction amounts
with claim as (
    select * from {{ ref('sat_claim_details') }}
    qualify row_number() over (partition by CLAIM_HK order by LOAD_DATETIME desc) = 1
),
tx as (
    select
        l.CLAIM_HK,
        count(*)            as TX_COUNT,
        sum(s.AMOUNT)       as TOTAL_CHARGED,
        sum(s.PAYMENTS)     as TOTAL_PAYMENTS,
        sum(s.ADJUSTMENTS)  as TOTAL_ADJUSTMENTS,
        sum(s.OUTSTANDING)  as TOTAL_OUTSTANDING
    from {{ ref('lnk_claim_tx_claim_patient') }} l
    join {{ ref('sat_claim_tx_details') }} s on s.CLAIM_TX_HK = l.CLAIM_TX_HK
    group by l.CLAIM_HK
)
select
    h.CLAIM_HK,
    h.CLAIM_ID,
    lc.PATIENT_HK,
    lc.PROVIDER_HK,
    lc.ENCOUNTER_HK,
    claim.SERVICEDATE,
    claim.STATUS1, claim.STATUS2, claim.STATUSP,
    claim.OUTSTANDING1, claim.OUTSTANDING2, claim.OUTSTANDINGP,
    tx.TX_COUNT, tx.TOTAL_CHARGED, tx.TOTAL_PAYMENTS, tx.TOTAL_ADJUSTMENTS, tx.TOTAL_OUTSTANDING
from {{ ref('hub_claim') }} h
left join {{ ref('lnk_claim_patient_provider_encounter') }} lc on lc.CLAIM_HK = h.CLAIM_HK
left join claim on claim.CLAIM_HK = h.CLAIM_HK
left join tx on tx.CLAIM_HK = h.CLAIM_HK
