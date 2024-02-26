# Snowflake Base Project
This is the repository of the snowflake base project, which aims to facilitate the creation of a new structure within snowflake, creating Roles, Users, Databases, and warehouses. The project's goal is for a configuration to be done using lines of code and then, after running 2 commands, your entire desired structure is implemented in snowflake.

## Prerequisites

Before running Terraform in this  project, ensure you meet the following prerequisites:

### .env file

Before we think about uploading some structures, we need to configure some variables.

First, copy the content inside the .env.example file and paste it into a new file called .env. Your empty .env file should look like this:

```bash
#AWS credentials
export AWS_REGION="us-east-1"
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

####VALIDATE
export BACKEND_KEY="prod/snowflake/terraform.tfstate"
export BACKEND_BUCKET="indicium-sf-terraform-state"

#Snowflake credentials
export SNOWFLAKE_USER=""
export SNOWFLAKE_ACCOUNT=""
export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/snowflake_tf_snow_key.p8"
```

Finish the configuration by adding the missing variables:
-**AWS_ACCESS_KEY_ID**: Service account access key id.
-**AWS_SECRET_ACCESS_KEY**: Service account secret access key.
-**SNOWFLAKE_USER**: Your snowflake username.
-**SNOWFLAKE_ACCOUNT**: Your snowflake account

**To get your correct Snowflake account, do the following:**

- *Log into your Snowflake account*
- *At the bottom left corner, click on your user*
- *Hover the mouse over the account field*
- *Hover the mouse over the selected account*
- *Click on the copy account identifier button (it's a copy symbol)*
- *Paste it into the .env and replace the '.' with a '-'* **IMPORTANT**

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

Upon completing this step, your account will be authenticated to proceed with uploading your structure.

## Requirements

this project requires

- terraform
- python 3.8 or later

### Install dependencies
Explain how user can install terraform. Validate

### Configuration
Link to modules explain