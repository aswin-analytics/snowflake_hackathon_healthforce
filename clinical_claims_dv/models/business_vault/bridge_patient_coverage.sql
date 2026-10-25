-- Bridge: patient -> payer coverage periods (from payer transitions)
select
    l.PATIENT_HK,
    l.PAYER_HK,
    l.PAYER_TRANSITION_HK,
    s.MEMBER_ID,
    s.START_YEAR as COVERAGE_START,
    s.END_YEAR   as COVERAGE_END,
    s.SECONDARY_PAYER_ID,
    s.OWNERSHIP_TYPE,
    current_timestamp() as BRIDGE_BUILT_AT
from {{ ref('lnk_payer_transition_patient_payer') }} l
join {{ ref('sat_payer_transition_details') }} s
  on s.PAYER_TRANSITION_HK = l.PAYER_TRANSITION_HK
qualify row_number() over (partition by s.PAYER_TRANSITION_HK order by s.LOAD_DATETIME desc) = 1
