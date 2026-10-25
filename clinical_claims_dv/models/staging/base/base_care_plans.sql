select *
from {{ source('silver', 'care_plans') }}
{{ dev_sample() }}
