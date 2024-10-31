------------------------------------------------------------------------------------
--SETUP

--create database
CREATE DATABASE mytestdb;

--create schema
CREATE SCHEMA raw;

--create storage location
CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::XXXXXXXXX:role/my-snowflake-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://my-data-lake/');

  --describe integration
DESCRIBE INTEGRATION my_s3_integration;

  
-- create s3 stage
CREATE OR REPLACE STAGE my_s3_stage
  STORAGE_INTEGRATION = my_s3_integration
  URL = 's3://my-data-lake';

-- list files included under the stage
LIST @my_s3_stage;

--create target table for data from manual files in s3
create or replace table raw_pokemon_data(
pokemon_id integer,
name string,
type_1 string,
type_2 string,
total integer,
hp integer,
attack integer, 
defence integer,
sp_atk integer,
sp_def integer,
speed integer,
generation string, 
legendary boolean
);

--create target table for data from PokeAPI
create or replace table raw.raw_gender_data(
v variant
);

--copy manual files
COPY INTO mytestdb.raw.raw_pokemon_data
FROM @my_s3_stage/manual_files
FILE_FORMAT = 
(TYPE = 'CSV' 
SKIP_HEADER=1  
FIELD_OPTIONALLY_ENCLOSED_BY='"'
null_if = '' 
);

--copy PokeAPI files
COPY INTO mytestdb.raw.raw_gender_data
FROM @my_s3_stage/api_data
FILE_FORMAT = 
(TYPE = 'JSON'
);


------------------------------------------------------------------------------------
--SOME EXPLORATION


--check if there are duplicate pokemon_ids
select pokemon_id, count(*) as c from raw.raw_pokemon_data
group by 1 
having c> 1
order by pokemon_id asc;


--show those rows that includes duplicate pokemon_ids, in full
with dups as (
select pokemon_id, count(*) as c from raw.raw_pokemon_data
group by 1 
having c> 1
)
select * from raw.raw_pokemon_data
where pokemon_id in (select pokemon_id from dups)
order by pokemon_id asc;


--total count
select count(*) from raw.raw_pokemon_data; --830


--check rows that contain Mega pokemon, and create "updated_name" column
select name ,substring(name, position('Mega' IN name)) AS updated_name
from raw.raw_pokemon_data
where contains(name,'Mega');


--query semi-structured data and nested fields
SELECT
v:id as gender_id,
initcap(replace(v:name, '"', '')) as gender_type, --remove double quotes
initcap(replace(value:pokemon_species:name, '"', '')) as pokemon_name,
reverse(split_part(reverse(replace(value:pokemon_species:url, '"', '')), '/', 2)) AS pokemon_id
FROM
raw.raw_gender_data, lateral flatten(input => v:pokemon_species_details);


--------tables/queries answering to the task questions------------------------------------

--q1. fastest ICE pokemon per generation
select * from mart.mart__fastest_per_generation;

--q2. top per type, and averages
select * from mart.mart__top_per_type;

--q3 strongest mega pokemon
select * from mart.mart__strongest_mega;

--q4 pokemon with genders
select gender_type, count(distinct pokemon_id) as count 
from base.base__pokemon_genders
group by 1
order by count desc
;
------------------------------------------------------------------------------------





