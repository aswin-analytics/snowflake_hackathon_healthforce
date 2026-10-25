select *
from {{ source('silver', 'conditions') }}
{{ dev_sample() }}
