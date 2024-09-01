with mega_versions as ( 
select 
    name,
    pokemon_id,
    hp,
    rank() over(order BY hp desc) AS rank_number
from {{ ref('pokemon_base') }}
where contains(name, 'Mega')
)

select 
    name,
    pokemon_id,
    hp
from 
    mega_versions
where rank_number = 1