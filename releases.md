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

# v0.0.5

### What's changed

- File ```modules/business-database/versions.tf```: "Snowflake-Labs/snowflake" provider version changed from 0.97.0 to 0.98.0 to fix bug that did not convert NULL to String in snowflake_user resource.

- File ```modules/warehouse/versions.tf```: "Snowflake-Labs/snowflake" provider version changed from 0.97.0 to 0.98.0 to fix bug that did not convert NULL to String in snowflake_user resource.

- File ```modules/custom-role/versions.tf```: "Snowflake-Labs/snowflake" provider version changed from 0.97.0 to 0.98.0 to fix bug that did not convert NULL to String in snowflake_user resource.


### Features

No features at the moment, just corrections and adjustments.

# v0.0.11

### What's changed

- File ```modules/business-database/main.tf```: Variable `data_retention_time_in_days` in resource `snowflake_database` now has implicit value `7`, instead of being used by variable.

- File ```modules/business-database/main.tf```: Variable `with_managed_access` in resource `snowflake_schema` now has implicit value `true`.

- File ```modules/business-schemas/main.tf```: Variable `with_managed_access` in resource `snowflake_schema` now has implicit value `true`.

- File ```modules/business-schemas/main.tf```: Variable `skip_header` in resource `snowflake_file_format` will be equal to `1` if `var.file_format` is equal to `CSV`, and `0` otherwise.

- File ```modules/snowpipe/variables.tf```: Variable `auto_ingest` will have the default value `false`.

### Features

- Creation of file `.tfsec/snowflake_tfchecks.json` with code verification rules by the `tfsec` pipeline for resources of the `Snowflake-Labs/snowflake` provider.

- Creation of file `.tfsec/snowsql_tfchecks.json` with code verification rules by the `tfsec` pipeline for resources of the `aidanmelen/snowsql` provider.

# v0.0.12
- File ```modules/business-database/roles.tf```: Changed resources creation to use "Snowflake-Labs/snowflake" provider instead of "aidanmelen/snowsql".

- File ```modules/business-schemas/main.tf```: "Snowflake-Labs/snowflake" provider version changed from 0.70.0 to 0.98.0

- File ```modules/custom-role/main.tf```: Changed resources creation to use "Snowflake-Labs/snowflake" provider instead of "aidanmelen/snowsql".


### Features
No features at the moment, just slight enhancements

# v0.0.13
- File ```modules/business-table/main.tf```: "Snowflake-Labs/snowflake" provider version changed from 0.70.0 to 0.98.0.

- File ```modules/snowpipe/versions.tf```: "Snowflake-Labs/snowflake" provider version changed from 0.97.0 to 0.98.0

- File ```modules/storage-integration/version.tf```: "Snowflake-Labs/snowflake" provider version changed from 0.97.0 to 0.98.0


### Features
No features at the moment, just slight enhancements