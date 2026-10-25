select *
from {{ source('silver', 'immunizations') }}
{{ dev_sample() }}
