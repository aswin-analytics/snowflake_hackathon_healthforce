select *
from {{ source('silver', 'claims') }}
{{ dev_sample() }}
