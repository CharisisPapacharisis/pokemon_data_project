# Pokemon Project

## ℹ️ Overview
This is a data engineering project that analyzes Pokemon data. The project focuses on combining and analyzing the relevant datasets, with the purpose of answering certain questions.

**Data sources** : .csv files, as well the PokeAPI.
**Tech stack** : AWS, Snowflake, dbt, Tableau, git

## 🔨 Architecture
The [architecture](https://excalidraw.com/#json=RLJW9DhjpiHjg54x61qqK,_79OB5pMR_YvyZObugRzmw) comprises: 
- CSV files uploaded via SFTP Server (AWS Transfer family) to an S3 bucket. From there, a lambda function copies files to the S3 data lake.
- Another lambda function calls the PokeAPI (gender endpoint) and drops the output in JSON format, in the s3 data lake.
- We have created a Storage Integration between the S3 data lake and Snowflake, which allows us to ingest all data in the RAW schema of Snowflake with the COPY INTO command.
- We follow a three-layer data architecture (stage-base-mart)) in the data warehouse. Data modelling takes place with dbt.
- The outputs of the data analysis are modelled in the mart layer, and [visualized in Tableau](https://public.tableau.com/views/PokemonVisualization_17253942786570/Dashboard?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

## 📝 Repo structure
The repo is organized in two folders: 
- dbt_project, which follows the standard structure of a dbt project
- other_files, which includes other parts of the solution, such as the code of the lambda functions, the IAM policies used for the lambda IAM users, sql commands for setting up the Snowflake environment, as well as the architecture diagram.

## 🚀 Getting Started
Start by pulling the repo. 

# AWS
Create: 
- Two s3 buckets. The first (w.g. "my-sftp-bucket") functions as the backend of the SFTP server, and the second (e.g. "my-data-lake") as the data lake.
- an AWS lambda function for calling the PokeAPI.
- an AWS lambda function which copies data from the SFTP s3 bucket to the s3 data lake. You can find the code in the other_files folder.
- Optionally: you can create an SFTP Server (AWS Transfer family), with its relevant user & the relevant IAM policies, and setup SSH authentication. This is not required. One can upload directly the source files into the sftp bucket.

Note: 
- When creating lambda functions from the User Interface, AWS will generate automatically roles that assigns to lambdas. Make sure to assign the relevant policies to those users. You can find them into the other_files folder.
- The lambda which calls the api ("call-pokemon-api.py") makes use of the requests library, which is not included in the lambda libraries out of the box. You can add "requests" as a Layer in the lambda function, for it to run.

# Snowflake
Log in your Snowflake instance, and create your own database, and raw schema. Here is where data will land from S3. As a prerequisite, you will need to create a Storage integration towards your S3 data lake, and a stage. You can follow the official documentation for it, linked below. Then, create two raw tables, one for the csv, and one for the json data files. As soon as you have data in the data lake, you can COPY into the target tables. You can use the commands in the snowflake_setup_and_exploration.sql file.

# Dbt
It is recommended to create a Python virtual environment in your computer, to isolate dependencies. After you activate it, you can install dbt, along with the Snowflake connector.
```bash
pip install dbt-snowflake
```
You also need to setup your local profiles.yml file accordingly, so that dbt can connect to your Snowflake instance.
Then, navigate to the root of the dbt project ("dbt_project" directory), and you can test/run all models. E.g. the command "dbt run", will create all models from staging to mart, respecting the dependencies. You can generate the dependency graph of the models, via the commands "dbt docs generate" / "dbt docs serve".

## 📚 Documentation
