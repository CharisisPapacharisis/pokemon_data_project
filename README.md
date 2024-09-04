# Pokemon Project

## ℹ️ Overview
This is a data engineering project that analyzes Pokemon data. The project focuses on combining and analyzing Pokemon-related datasets.

**Data sources** : CSV files, PokeAPI

**Tech stack** : AWS, Snowflake, dbt, Tableau, git

## 🔨 Architecture
The [Architecture](https://excalidraw.com/#json=RLJW9DhjpiHjg54x61qqK,_79OB5pMR_YvyZObugRzmw) consists of the following: 
- CSV files are uploaded via an SFTP Server (AWS Transfer family) to an S3 bucket. From there, a lambda function copies those files to another S3 bucket, our data lake.
- Another lambda function calls the PokeAPI ("gender" endpoint) and places the output in JSON format, in the S3 data lake.
- We have created a `Storage Integration` between the S3 data lake and Snowflake, which allows us to ingest all data into the RAW schema of Snowflake, via the *COPY INTO* command.
- We follow a 4-layer data architecture (RAW-STAGE-BASE-MART) in the data warehouse. Data modelling is achieved via dbt.
- The outputs of the data analysis are modelled in the MART layer, and [visualized in Tableau](https://public.tableau.com/views/PokemonVisualization_17253942786570/Dashboard?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

## 📝 Repo structure
The repo is organized in two folders: 
- **dbt_project**, which follows the standard structure of a dbt project

- **other_files**, which includes other parts of the solution, such as:
    - the code of the lambda functions
    - the IAM policies used for the lambda IAM Roles
    - SQL commands for setting up the Snowflake environment
    - the Architecture diagram

## 🚀 Getting Started
Start by cloning the repo. 

### AWS
**Create:** 
- Two S3 buckets. The first (e.g. `"my-sftp-bucket"`) functions as the backend of the SFTP server, and the second (e.g. `"my-data-lake"`) as the data lake.
- an AWS lambda function for calling the PokeAPI.
- an AWS lambda function which copies data from the SFTP S3 bucket to the S3 data lake. You can find the code in the `other_files` folder.
- *Optionally*: you can create an SFTP Server (AWS Transfer family), with its relevant user & IAM policies, and setup SSH authentication. *This is not required*. Instead,one can upload directly the source files into the SFTP bucket.

**Note:** 
- When creating lambda functions into the AWS UI, AWS will automatically generate IAM Roles, which that assigned to said lambdas. Make sure to assign/add the relevant IAM policies to those Roles, so that they can access S3 as per their requirements. You can find the IAM policies into the `other_files` folder.
- The lambda which calls the api `("call-pokemon-api.py")` makes use of the *requests* library, which is not included in the lambda libraries out-of-the-box. You can add "requests" as a Layer in the lambda function, for it to run succesfully.

### Snowflake
Log into your Snowflake instance, and create your own database, and RAW schema. This schema is where the data from S3 will land. As a prerequisite, you will need to create a `Storage integration` towards your S3 data lake, and a `Stage`. You can follow the official documentation for this, linked below. 

Then, create two raw tables, one for the CSV, and one for the JSON data sources. As soon as you have data in the data lake, you can **COPY INTO** the target tables. You can use the commands in the `snowflake_setup_and_exploration` SQL file.

### Dbt
It is recommended to create a Python virtual environment in your computer, to isolate dependencies. After you activate it, you can install dbt together with the Snowflake connector.
```bash
pip install dbt-snowflake
```
You also need to setup your `local profiles.yml` file accordingly, so that dbt can connect to your Snowflake instance.
Then, navigate to the root of the dbt project ("dbt_project" directory), and you can test/run all models. 

E.g. the command `"dbt run"`, will create all models from staging to mart, respecting the dependencies. You can generate the dependency graph of the models, via the commands `"dbt docs generate"` / `"dbt docs serve"`.

## 📚 Documentation
- [Installing dbt with pip](https://docs.getdbt.com/docs/core/pip-install)
- [Configuring dbt for Snowflake](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
- [Storage Integration in Snowflake](https://docs.snowflake.com/en/sql-reference/sql/create-storage-integration)
- [PokeAPI](https://pokeapi.co/)
- [AWS lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
