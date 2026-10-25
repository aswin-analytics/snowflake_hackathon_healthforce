-- Payer (insurer) dimension
with s as (
    select * from {{ ref('sat_payer_details') }}
    qualify row_number() over (partition by PAYER_HK order by LOAD_DATETIME desc) = 1
)
select
    h.PAYER_ID,
    h.PAYER_HK,
    s.NAME                   as PAYER_NAME,
    s.STATE_HEADQUARTERED,
    s.UNIQUE_CUSTOMERS,
    s.MEMBER_MONTHS,
    s.REVENUE                as PAYER_REVENUE
from {{ ref('hub_payer') }} h
left join s on s.PAYER_HK = h.PAYER_HK
