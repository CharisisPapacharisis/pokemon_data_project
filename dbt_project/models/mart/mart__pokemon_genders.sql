select 
    pokemon_id,
    name, 
    gender_type,
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
from {{ ref('base__pokemon_genders') }} a
