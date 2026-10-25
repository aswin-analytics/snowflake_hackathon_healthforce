{{ config(materialized='table') }}

-- Daily snapshot dates used by the PIT tables
select dateadd(day, -seq4(), current_date())::timestamp_ntz as AS_OF_DATE
from table(generator(rowcount => {{ var('pit_days') }}))
