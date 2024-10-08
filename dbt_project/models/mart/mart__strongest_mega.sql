with mega_versions as ( 
select 
    name,
    pokemon_id,
    hp,
    rank() over(order by hp desc) as rank_number
from {{ ref('stage__pokemon') }}
where contains(name, 'Mega')
)

select 
    name,
    pokemon_id,
    hp
from 
    mega_versions
where rank_number = 1