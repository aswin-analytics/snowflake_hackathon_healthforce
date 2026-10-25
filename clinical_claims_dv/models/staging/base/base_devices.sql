select *
from {{ source('silver', 'devices') }}
{{ dev_sample() }}
