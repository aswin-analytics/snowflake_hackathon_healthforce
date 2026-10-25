select *
from {{ source('silver', 'payers') }}
{{ dev_sample(has_patient=false) }}
