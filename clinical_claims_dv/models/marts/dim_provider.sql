-- Provider dimension with the provider's organization
with p as (
    select * from {{ ref('sat_provider_details') }}
    qualify row_number() over (partition by PROVIDER_HK order by LOAD_DATETIME desc) = 1
),
o as (
    select * from {{ ref('sat_organization_details') }}
    qualify row_number() over (partition by ORGANIZATION_HK order by LOAD_DATETIME desc) = 1
)
select
    h.PROVIDER_ID,
    h.PROVIDER_HK,
    p.NAME          as PROVIDER_NAME,
    p.GENDER        as PROVIDER_GENDER,
    p.SPECIALITY    as SPECIALTY,
    p.CITY          as PROVIDER_CITY,
    p.STATE         as PROVIDER_STATE,
    ho.ORGANIZATION_ID,
    o.NAME          as ORGANIZATION_NAME,
    o.CITY          as ORGANIZATION_CITY,
    o.STATE         as ORGANIZATION_STATE
from {{ ref('hub_provider') }} h
left join p on p.PROVIDER_HK = h.PROVIDER_HK
left join {{ ref('lnk_provider_organization') }} l on l.PROVIDER_HK = h.PROVIDER_HK
left join {{ ref('hub_organization') }} ho on ho.ORGANIZATION_HK = l.ORGANIZATION_HK
left join o on o.ORGANIZATION_HK = l.ORGANIZATION_HK
qualify row_number() over (partition by h.PROVIDER_HK order by l.LOAD_DATETIME desc nulls last) = 1
