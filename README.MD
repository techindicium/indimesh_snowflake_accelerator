# Snowflake Base Project
This is the repository of the snowflake base project, which aims to facilitate the creation of a new structure within snowflake, creating Roles, Users, Databases, and warehouses. The project's goal is for a configuration to be done using lines of code and then, after running 2 commands, your entire desired structure is implemented in snowflake.

## Requirements

this project requires
- terraform
- python 3.8 or later

### Install dependencies
Explain how user can install terraform. Validate

### Configuration

### Run it
Instructions to execute the application/program.
Ex:
source .local.env
python -m main.app


### Verify things are working
Instructions to check if things are working properly.
Ex1:
  Open your browser at localhost:3000
Ex2:
curl localhost:5000


## Deploy
Instructions/Description of the regular deployment process. Be descriptive!
Ex: first dev deploy, then tests, check metrics, if everything ok prod deploy.

### Development Deploy
Instructions to deploy the project in a development environment.
Ex1:
  Push on develop branch + CI development pipeline
Ex2:
  Ask for required credentials and:
ENV=DEV make deploy


### Production Deploy
Instructions to deploy the project in a production environment. Be very descriptive and require carefullness.
Ex1:
  Push on master branch + CI productions pipeline
Ex2:
  Ask for required credentials and:
ENV=PROD make deploy

Ex3:
  Description of step-by-step process

## Troubleshooting
Describe common issues that you have faced or that a newby user may be facing while developing the project
Ex: (tap development)
  ### Skipping stream
  In discovery mode, catalogs metadata comes empty. However, to sync the catalog a stream
  needs to have a "selected" flag set to true in the metadata section.

## Contributing

1. Open issues
2. Write code
3. Eun linter and other code analysis tools
4. Open PR
```