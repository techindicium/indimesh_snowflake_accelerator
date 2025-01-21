# v0.0.0 / v0.0.1

### What's changed

- File ```README.md```: Added topics on how to use this repository in other projects and also the topic that explains how to contribute to this repository.

- File ```releases.md```: Created to document contributions made to this repository.

- File ```bitbucket-pipelines.md```: Created to explain what is executed in the Bitbucket pipeline.

- File ```bitbucket-pipelines.yml```: Pipeline for creating tags whenever a merge is made to the ```master``` branch.

### Features

Documentation explained on the changes to the files in [what's changed](#whats-changed) and creation of a pipeline that creates tags whenever a merge is made to the ```master``` branch.

# v0.0.2

### What's changed

- File ```modules/business-databaes/locals.tf```: Creation of file with locals for better separation, and removal of *db_name*.

- File ```modules/business-databaes/versions.tf```: Creation of file with providers for better separation, and update of the Snowflake-Labs/snowflake provider from 0.70.0 -> 0.97.0.

- File ```modules/business-databaes/main.tf```: Resource *snowflake_schema* now dynamic, and removal of *locals* and *providers*.

- File ```modules/business-databaes/variables.tf```: Addition of variable *schemas*.

- File ```modules/business-databaes/roles.tf```: Code correction and dynamism for *schemas*.

- File ```modules/custom-role/versions.tf```: Creation of the *versions.tf* file containing the providers, for better separation, and update of the Snowflake-Labs/snowflake provider from 0.70.0 -> 0.97.0.

- File ```modules/custom-role/main.tf```: Removal of *providers* and update of the *snowflake_role* -> *snowflake_account_role* resource.

- File ```modules/warehouse/version.tf```: Creation of the *version.tf* file containing the providers, for better separation, and update of the Snowflake-Labs/snowflake provider from 0.70.0 -> 0.97.0.

- File ```modules/warehouse/main.tf```: Removed *providers* and updated resources *snowflake_warehouse_grant* -> *snowflake_grant_privileges_to_account_role* and *snowsql* -> *snowflake_grant_account_role*.

### Features

No features at the moment, just corrections and adjustments.