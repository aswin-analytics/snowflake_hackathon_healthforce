{{ config(materialized='table', grants={'select': ['PARTNER_ANALYST']}) }}

-- Simulated partner upload: the payer partner's own member list, hashed with the agreed salt.
-- In a real two-account clean room this table lives in the partner's account.
-- Here: 1-in-3 sampled patients plus 2,000 keys we don't have, so overlap is realistic.
select sha2(PATIENT_ID::string || '{{ var("cleanroom_salt") }}', 256) as MEMBER_JOIN_KEY,
       'PARTNER_PAYER_CO' as PARTNER_NAME
from {{ ref('dim_patient') }}
where mod(PATIENT_ID, 3) = 0
union all
select sha2(('non_member_' || seq4())::string || '{{ var("cleanroom_salt") }}', 256), 'PARTNER_PAYER_CO'
from table(generator(rowcount => 2000))
