select 
    pokemon_id,
    name,
    type_1,
    type_2,
    total,
    hp,
    attack,
    defence,
    sp_atk,
    sp_def,
    speed,
    generation,
    legendary
from {{ ref('pokemon_base') }}