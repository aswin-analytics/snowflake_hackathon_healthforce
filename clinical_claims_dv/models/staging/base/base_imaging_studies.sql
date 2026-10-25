select *
from {{ source('silver', 'imaging_studies') }}
{{ dev_sample() }}
