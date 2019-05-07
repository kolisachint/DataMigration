select 
primary_key,concat(cast(mod(primary_key,100000000) as string),format("%08d",row_number() over(partition by mod(primary_key,100000000))))
from `projectid.dataset.table` 
