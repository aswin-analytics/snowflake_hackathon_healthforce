select *
from {{ source('silver', 'claims_tx') }}
{{ dev_sample() }}
