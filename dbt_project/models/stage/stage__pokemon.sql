

select distinct 
    pokemon_id,
    regexp_replace(trim(substring(name, position('Mega' in name))),'([a-z])([A-Z])', '\\1 \\2') as name, 
    initcap(trim(type_1)) as type_1,
    initcap(trim(type_2)) as type_2,
    total,
    hp,
    attack,
    defence,
    sp_atk,
    sp_def,
    speed,
    trim(generation) as generation,
    legendary
from {{ source('pokemon', 'raw_pokemon_data') }}