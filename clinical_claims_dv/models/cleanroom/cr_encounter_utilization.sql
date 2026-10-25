{{ config(
    post_hook=[
      "alter view {{ this }} set aggregation policy {{ target.database }}.GOVERNANCE.CLEANROOM_MIN_GROUP_25 force",
      "alter view {{ this }} modify column MEMBER_JOIN_KEY set projection policy {{ target.database }}.GOVERNANCE.CLEANROOM_NO_PROJECT_JOIN_KEY force"
    ]
) }}

-- Clean room: encounter-level utilisation and cost, keyed by the same hashed member key.
select
    sha2(f.PATIENT_ID::string || '{{ var("cleanroom_salt") }}', 256) as MEMBER_JOIN_KEY,
    f.ENCOUNTER_MONTH,
    f.ENCOUNTER_CLASS,
    p.PAYER_NAME,
    f.TOTAL_CLAIM_COST,
    f.PAYER_COVERAGE,
    f.PATIENT_RESPONSIBILITY
from {{ ref('fct_encounter') }} f
left join {{ ref('dim_payer') }} p on p.PAYER_ID = f.PAYER_ID
