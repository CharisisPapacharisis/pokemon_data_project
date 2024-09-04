select 
    a.pokemon_id,
    a.name, 
    b.gender_type,
    a.type_1,
    a.type_2,
    a.total,
    a.hp,
    a.attack,
    a.defence,
    a.sp_atk,
    a.sp_def,
    a.speed,
    a.generation,
    a.legendary
    from {{ ref('stage__pokemon') }} a
    left join {{ ref('stage__gender') }} b
        on a.pokemon_id = b.pokemon_id