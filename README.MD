# Snowflake Base Project
This is the repository of the snowflake base project, which aims to facilitate the creation of a new structure within snowflake, creating Roles, Users, Databases, and warehouses. The project's goal is for a configuration to be done using lines of code and then, after running 2 commands, your entire desired structure is implemented in snowflake.

## Tables of contents

1. [Requirements](#requirements)
2. [Prerequisites](#prerequisites)
3. [Repository Structure](#repository-structure)
4. [Permissions and users](#permissions-and-users)
5. [Setting the bucket](#setting-the-bucket)
6. [Up Structure to Snowflake](#up-structure-to-snowflake)
7. [Example of how to use in other projects](#example-of-how-to-use-in-other-projects)
8. [How to contribute to the repository](#how-to-contribute-to-the-repository)

## Requirements

This project requires:

- terraform
- snowsql
- python 3.8 or later

### Install requirements

In this section, you will understand how to install the necessary requirements.

#### Install terraform

For the installation, you can follow the official [Terraform installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli), but we highly recommend you to install [tfenv](https://github.com/tfutils/tfenv) instead, to have more freedom in using and updating Terraform versions.

##### Automatic installation using Homebrew

```bash
$ brew install tfenv
```
##### Manual installation

1. Check out tfenv into any path (here is `${HOME}/.tfenv`)

```console
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
```

2. Add `~/.tfenv/bin` to your `$PATH` any way you like

```bash
# bash terminal
$ echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile

# zsh terminal
$ echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zprofile
```

3. Install an version and set it as active

You can check the available version running `tfenv list-remote`

```
$ tfenv install 1.7.4
$ tfenv use 1.7.4
```

4. Test if Terraform is actually running
```bash
$ terraform version
```

#### Install snowsql

SnowSQL is a CLI (Command Line Interface) for Snowflake that allows you to run SQL commands once connected to an account. It will be necessary in the next step.

[**CLICK HERE TO SEE HOW INSTALL SNOWSQL**](https://developers.snowflake.com/snowsql/)

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

- **AWS_ACCESS_KEY_ID**: Service account access key id.
- **AWS_SECRET_ACCESS_KEY**: Service account secret access key.
- **SNOWFLAKE_USER**: Your snowflake username.
- **SNOWFLAKE_ACCOUNT**: Your snowflake account.

**To get your correct Snowflake account, do the following:**

- *Log into your Snowflake account*
- *At the bottom left corner, click on your user*
- *Hover the mouse over the account field*
- *Hover the mouse over the selected account*
- *Click on the copy account identifier button (it's a copy symbol)*
- *Paste it into the .env and replace the '.' with a '-'* (**IMPORTANT**)

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
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SECURITYADMIN;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SYSADMIN;
```

```
Also, ensure that you have configured the warehouse name on "./examples/multiarea_setup/data/config.yaml".
```

There's the need to grant usage to the default warehouse created with the snowflake's account, which at this moment is named as "COMPUTE_WH".
Upon completing this step, your account will be authenticated to proceed with uploading your structure.

## Repository Structure

```
└── snowflake-base
    ├── examples            -> Contains example templates to up a snowflake structure
    ├── modules
    │ ├── business-database -> Configuration to up databases
    │ └── custom-role       -> Configuration to up custom-roles
    │ └── warehouse         -> Configuration to up warehouses
```

### Understanding module file
Every module contains at least the following files:

- **`main.tf`**: File responsible for declaring the main resources related to the given module
- **`output.tf`**: [Terraform output variables](https://developer.hashicorp.com/terraform/language/values/outputs) that may export important values to the user or for another module to access the given value.
- **`variables.tf`**: Declaration of [Terraform input variables](https://developer.hashicorp.com/terraform/language/values/variables)
- **`roles.tf`**: VALIDATE

## Permissions and users
By default, when your account is provisioned, the first user is assigned the ACCOUNTADMIN role. This user should then create one or more additional users who are assigned the USERADMIN role. All remaining users should be created by the user(s) with the USERADMIN role or another role that is granted the global CREATE USER privilege.

## Setting the bucket
By default, the config.yaml and the var.data_bucket_arns have the bucket mentioned as "mybucket", you are gonna need change it, based on your s3 bucket you created on your training aws env.

## Up Structure to Snowflake
- [Multi Area Setup](/examples/multiarea_setup/README.md)

## Example of how to use in other projects

Based on the repository structure, to call a specific module like snowpipe in a Terraform project, you can do so using the source parameter in the module block, as in the example below:

```terraform
locals {
  bitbucket_repo = "indiciumtech/done-snowflake-base"
  module_path    = "modules/snowpipe"
  module_version = "v0.0.0"
}

module "snowpipe" {
    source = "git::https://x-token-auth:${BITBUCKET_TOKEN}@bitbucket.org/${local.bitbucket_repo}.git//${local.module_path}?ref=${local.module_version}"
    for_each = local.config.snowpipe

    schema_name = each.value.schema_name
    database_name = each.value.database_name
    pipe_name = each.value.pipe_name
    table_name = each.value.table_name
    stage_name = each.value.stage_name
    sns_topic = module.storage_integration.sns_topic_arn


    providers = {
        snowflake.sys_admin = snowflake.sys_admin
        snowflake.security_admin = snowflake.security_admin
        snowsql.security_admin = snowsql.security_admin
        snowsql.sys_admin = snowsql.sys_admin
    }
}
```

Points to pay attention to when using the module:

1. It is necessary to pay attention to the structure of the ```source```, because it is necessary for the environment variable ```BITBUCKET_TOKEN``` to be configured in the ```.env``` file, this variable having read permissions for the repository.

2. In the configured ```locals.tf```, make sure that the variable ```bitbucket_repo``` has the value ```<workspace>/<repository_name>```.

3. In the configured ```locals.tf```, make sure that the variable ```module_path``` exists in the repository.

4. In the configured ```locals.tf```, make sure that the variable ```module_version``` has the value equal to some version existing in the repository.

With the above points verified and in accordance with the project, the next step is to configure the module to create the desired infrastructure, and for this it is possible to see usage examples in the ```examples/``` folder.

# How to contribute to the repository

To contribute to this repository, you must remember that it is configured to generate a new version whenever a merge is made to the ```master``` branch. Therefore, it is necessary to identify the current version of the repository and what the version will be after the contribution to the repository is made, in order to document the changes made so that repository users can follow the changes and apply them to their projects.

The documentation of the changes made should be done in the ```releases.md``` file following the example template below:

```markdown
# v0.0.0

### What's changed

- File ```modules/snowpipe/variables.tf```: Added ```table_name``` variable.

- File ```modules/snowpipe/main.tf```: Use of the new ``table_name``` variable.

### Features

- Implemented new Snowpipe module configuration method.
```

