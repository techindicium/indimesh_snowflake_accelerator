# Snowflake Base Project
This is the repository of the snowflake base project, which aims to facilitate the creation of a new structure within snowflake, creating Roles, Users, Databases, and warehouses. The project's goal is for a configuration to be done using lines of code and then, after running 2 commands, your entire desired structure is implemented in snowflake.

## Prerequisites

Before running Terraform in this  project, ensure you meet the following prerequisites:

### .env file

### Snowsql

### Snowflake Private Key

The snowflake private key is a key that we will create to authenticate our user, similar to an ssh key, to enable the use of terraform on our machine. Below, we have the step-by-step on how to create the key.

- **Go to .ssh folder**
```bash
$ cd ~/.ssh
```
Here, it is important that the key stays in this folder, because in the .env file, we have the path to the files that will be generated.
- **Generate a private key**
```bash
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out snowflake_tf_snow_key.p8 -nocrypt
```
- **Generate a public key from private**
```bash
$ openssl rsa -in snowflake_tf_snow_key.p8 -pubout -out snowflake_tf_snow_key.pub
```
- **Start a new connection in snowsql**
```bash
$ snowsql -a <your-account-snowflake> -u <your-snowflake-username>
```
At this stage, if you correctly input your Snowflake account details, SnowSQL will prompt you for the account password. Enter it to initiate the connection.
- **Add key to your user**
```snowsql
ALTER USER <YOUR_USERNAME> SET RSA_PUBLIC_KEY='YOUR_PUBLIC_(.PUB)_KEY_COPIED_HERE' DEFAULT_ROLE=PUBLIC;

GRANT ROLE SYSADMIN TO USER <YOUR_USERNAME>;
GRANT ROLE SECURITYADMIN TO USER <YOUR_USERNAME>;
```

## Requirements

this project requires

- terraform
- python 3.8 or later

### Install dependencies
Explain how user can install terraform. Validate

### Configuration
Link to modules explain