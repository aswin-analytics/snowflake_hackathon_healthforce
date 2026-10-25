select *
from {{ source('silver', 'observations') }}
{{ dev_sample() }}
