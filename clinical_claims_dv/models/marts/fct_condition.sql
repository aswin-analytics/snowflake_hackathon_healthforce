-- Condition (diagnosis) fact: one row per diagnosed condition
with s as (
    select * from {{ ref('sat_condition_details') }}
    qualify row_number() over (partition by CONDITION_HK order by LOAD_DATETIME desc) = 1
)
select
    h.CONDITION_ID,
    hp.PATIENT_ID,
    he.ENCOUNTER_ID,
    s.CODE                         as CONDITION_CODE,
    s.SYSTEM                       as CODE_SYSTEM,
    s.DESCRIPTION                  as CONDITION_DESCRIPTION,
    s.CONDITION_START,
    s.CONDITION_STOP,
    s.CONDITION_STOP is null       as IS_ACTIVE
from {{ ref('hub_condition') }} h
join s on s.CONDITION_HK = h.CONDITION_HK
left join {{ ref('lnk_condition_patient_encounter') }} l on l.CONDITION_HK = h.CONDITION_HK
left join {{ ref('hub_patient') }} hp on hp.PATIENT_HK = l.PATIENT_HK
left join {{ ref('hub_encounter') }} he on he.ENCOUNTER_HK = l.ENCOUNTER_HK
