select
v:id as gender_id,
initcap(replace(v:name, '"', '')) as gender_type, --remove double quotes
initcap(replace(value:pokemon_species:name, '"', '')) as pokemon_name,
reverse(split_part(reverse(replace(value:pokemon_species:url, '"', '')), '/', 2)) AS pokemon_id

FROM
{{ source('pokemon', 'raw_gender_data') }}, lateral flatten(input => v:pokemon_species_details)
