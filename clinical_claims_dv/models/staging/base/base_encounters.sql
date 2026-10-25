select *
from {{ source('silver', 'encounters') }}
{{ dev_sample() }}
