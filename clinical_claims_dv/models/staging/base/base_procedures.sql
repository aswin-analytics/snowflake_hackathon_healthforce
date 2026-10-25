select *
from {{ source('silver', 'procedures') }}
{{ dev_sample() }}
