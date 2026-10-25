select *
from {{ source('silver', 'allergies') }}
{{ dev_sample() }}
