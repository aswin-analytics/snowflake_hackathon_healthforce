select *
from {{ source('silver', 'organizations') }}
{{ dev_sample(has_patient=false) }}
