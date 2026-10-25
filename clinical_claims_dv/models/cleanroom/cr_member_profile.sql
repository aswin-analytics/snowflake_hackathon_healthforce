{{ config(
    post_hook=[
      "alter view {{ this }} set aggregation policy {{ target.database }}.GOVERNANCE.CLEANROOM_MIN_GROUP_25 force",
      "alter view {{ this }} modify column MEMBER_JOIN_KEY set projection policy {{ target.database }}.GOVERNANCE.CLEANROOM_NO_PROJECT_JOIN_KEY force"
    ]
) }}

-- Clean room: de-identified member profile shared with a payer partner.
-- Partners may only aggregate (>= 25 members per group) and can join on, but never select, MEMBER_JOIN_KEY.
select
    sha2(PATIENT_ID::string || '{{ var("cleanroom_salt") }}', 256) as MEMBER_JOIN_KEY,
    AGE_BAND,
    GENDER,
    RACE,
    ETHNICITY,
    STATE,
    COUNTY,
    IS_ALIVE
from {{ ref('dim_patient') }}
