with max_speed_per_generation as ( 
select 
    name,
    pokemon_id,
    generation, 
    speed,
    rank() over (partition by generation order by speed desc) AS rank
from {{ ref('stage__pokemon') }}
where type_1 = 'Ice' or type_2 = 'Ice'
)

select 
    generation,
    name, 
    pokemon_id,
    speed 
 from max_speed_per_generation
where rank = 1 
order by generation