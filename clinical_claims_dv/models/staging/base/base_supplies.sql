select *
from {{ source('silver', 'supplies') }}
{{ dev_sample() }}
