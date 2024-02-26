# Snowflake Base Project
This is the repository of the snowflake base project, which aims to facilitate the creation of a new structure within snowflake, creating Roles, Users, Databases, and warehouses. The project's goal is for a configuration to be done using lines of code and then, after running 2 commands, your entire desired structure is implemented in snowflake.

## Prerequisites

Before running Terraform in this  project, ensure you meet the following prerequisites:

### Snowflake Private Key

The snowflake private key is a key that we will create to authenticate our user, similar to an ssh key, to enable the use of terraform on our machine. Below, we have the step-by-step on how to create the key.

- **Go to .ssh folder**
```bash
$ cd ~/.ssh
```
- **Generate a private key**
```bash
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out snowflake_tf_snow_key.p8 -nocrypt
```
- **Generate a public key from private**
```bash
$ openssl rsa -in snowflake_tf_snow_key.p8 -pubout -out snowflake_tf_snow_key.pub
```

## Requirements

this project requires

- terraform
- python 3.8 or later

### Install dependencies
Explain how user can install terraform. Validate

### Configuration
Link to modules explain