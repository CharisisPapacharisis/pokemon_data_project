with type_1_totals as ( 
select 
    type_1 as type,
    name,
    pokemon_id,
    total, 
    attack,
    defence
from {{ ref('stage__pokemon') }}
),

type_2_totals as ( 
select 
    type_2 as type,
    name,
    pokemon_id,
    total, 
    attack,
    defence
from {{ ref('stage__pokemon') }}
),

unioned as 
(
select * 
from type_1_totals
union all 
select * 
from type_2_totals
), 

ranked_totals_per_type as (
select 
    type,
    name,
    pokemon_id,
    total, 
    row_number() over (partition by type order by total desc) AS row_number,
    rank() over (partition by type order by total desc) AS rank_number,
    attack,
    defence
from unioned
),

top_totals_selection as (
select 
    *
from ranked_totals_per_type
where 
row_number <= 10
OR (rank_number <= 10 AND row_number > 10)
),

average_attack_per_type as (
select 
    type,
    avg(attack)::number(10,1) AS avg_attack
from 
    top_totals_selection
group by
    type
),

average_defence_per_type as (
select 
    type,
    avg(defence)::number(10,1) AS avg_defence
from 
    top_totals_selection
group by 
    type
)

select 
    a.type,
    a.name,
    a.pokemon_id,
    a.total, 
    a.row_number,
    a.rank_number,
    a.attack,
    a.defence,
    b.avg_attack,
    c.avg_defence
from top_totals_selection a
left join average_attack_per_type b
    on a.type = b.type
left join average_defence_per_type c
    on a.type = c.type
group by all
order by type, row_number asc

