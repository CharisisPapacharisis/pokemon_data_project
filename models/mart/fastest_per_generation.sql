with max_speed_per_generation as ( 
select 
    name,
    pokemon_id,
    generation, 
    speed,
    rank() over (partition by generation order by speed desc) AS rank
from {{ ref('pokemon_base') }}
)

select 
    generation,
    name, 
    pokemon_id,
    speed 
 from max_speed_per_generation
where rank = 1 
order by generation