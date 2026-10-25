select *
from {{ source('silver', 'providers') }}
{{ dev_sample(has_patient=false) }}
