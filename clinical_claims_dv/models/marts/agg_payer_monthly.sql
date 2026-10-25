-- Monthly payer performance: volume, cost and coverage
select
    f.ENCOUNTER_MONTH,
    f.PAYER_ID,
    p.PAYER_NAME,
    count(*)                                          as ENCOUNTER_COUNT,
    count(distinct f.PATIENT_ID)                      as PATIENT_COUNT,
    sum(f.TOTAL_CLAIM_COST)                           as TOTAL_CLAIM_COST,
    sum(f.PAYER_COVERAGE)                             as TOTAL_PAYER_COVERAGE,
    sum(f.PATIENT_RESPONSIBILITY)                     as TOTAL_PATIENT_RESPONSIBILITY,
    div0(sum(f.PAYER_COVERAGE), sum(f.TOTAL_CLAIM_COST)) as COVERAGE_RATIO
from {{ ref('fct_encounter') }} f
left join {{ ref('dim_payer') }} p on p.PAYER_ID = f.PAYER_ID
group by 1, 2, 3
