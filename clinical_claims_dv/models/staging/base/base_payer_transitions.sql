select *
from {{ source('silver', 'payer_transitions') }}
{{ dev_sample() }}
