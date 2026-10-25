select *
from {{ source('silver', 'patients') }}
{{ dev_sample() }}
