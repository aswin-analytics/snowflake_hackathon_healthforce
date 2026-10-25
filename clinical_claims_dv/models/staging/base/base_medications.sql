select *
from {{ source('silver', 'medications') }}
{{ dev_sample() }}
