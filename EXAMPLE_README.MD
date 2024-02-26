
## Installation

For the installation, you can follow the official [Terraform installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli), but we highly recommend you to install [tfenv](https://github.com/tfutils/tfenv) instead, to have more freedom in using and updating Terraform versions.

### Automatic installation using Homebrew

```bash
$ brew install tfenv
```

### Manual installation

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

## Repository Structure

Before delving into Terraform and how to run it in this project, let's first understand the repository components that we have.

```
└── stacks
    ├── computing            -> Contains resources regarding Airflow deployment in EC2
    ├── databricks
    │ ├── unity_catalog    -> Resources related to Unity Catalog setup
    │ └── workspace        -> Databricks initial workspace environment setup
    ├── datalake             -> S3 buckets for the medallion layer and permissions to it
    ├── ingestion
    │ ├── appflow         -> Resources related to Appflow extractions (Salesforce, Sharepoint and Google Sheets)
    │ └── dms             -> Database migration tasks (MongoDB and PostgreSQL)
    ├── network             -> VPC setup for the entire project
    ├── project_data         -> Important name patterns and variables used in the entire project
    ├── setup                -> Terraform bootstrap (S3 bucket where state is stored)
    └── vpn-pritunl         -> Pritunl VPN resources
```
This structure is designed to segregate different aspects of the infrastructure for clarity and ease of management. Each directory/module should be used according to the specific needs of the project.

Each director contains its own `README.md` providing detailed information about the configurations and usage within that module. Also, each directory contains its own `.tf` files, which declare resources, variables, modules and other Terraform features.


## Developing
This section outlines the basic steps for working with the Terraform configurations in this repository.

### Understanding module file
Every module contains at least the following files:

- **`data.tf`**: Where [Terraform data sources](https://developer.hashicorp.com/terraform/language/data-sources) are declared and where we import the `project_data` folder to get the repository's common variables.
- **`locals.tf`**: Where the [Terraform local values](https://developer.hashicorp.com/terraform/language/values/locals) are declared. These are module-specific variables
- **`main.tf`**: File responsible for declaring the main resources related to the given module
- **`output.tf`**: [Terraform output variables](https://developer.hashicorp.com/terraform/language/values/outputs) that may export important values to the user or for another module to access the given value.
- **`providers.tf`**: Where we declare the provider that we are interacting with. For this project, common providers are [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) and [Databricks](https://registry.terraform.io/providers/databricks/databricks/latest/docs).
- **`terraform.tf`**: Location that we declare where the [Terraform state](https://developer.hashicorp.com/terraform/language/state) will be stored and what providers versions are required by the module.
- **`variables.tf`**: Declaration of [Terraform input variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Running Terraform

1. **Initialization**: Before you begin making changes, initialize your Terraform environment. This will download necessary Terraform providers and modules. This command is only needed when initializing the module for the first time, updating provider versions or adding new modules

```bash
$ terraform init
```

2. **Planning**: After making your changes, run a Terraform plan to see what actions Terraform will perform.
```bash
$ terraform plan
```

3. **Applying Changes**: If the plan looks good, apply the changes.
```bash
$ terraform apply
```

Optionally, you can apply only desired resources using the `-target` flag
```bash
$ terraform apply -target=<provider-resource>.<the-name-you-gave>
```

For example
```bash
$ terraform apply -target=aws_appflow_connector_profile.salesforce

# OR

$ terraform apply -target=module.dms_instance -target='module.dms.aws_dms_endpoint.this["postgresql-source"]'
```

Ensure you are using the appropriate AWS and Databricks CLI profiles (in this case, "metaloop") when running these commands.


## Pre-Commit

To ensure code quality and consistency, this repository uses [Git pre-commit](https://pre-commit.com/) hooks. These hooks run checks on your commits before they are submitted. Follow these steps to set up pre-commit in your repository:

1. **Install pre-commit**
If you don't have pre-commit installed, you can install it using pip (for Python) or Homebrew (for macOS):

```bash
# Python
$ pip install pre-commit

# Homebrew
$ brew install pre-commit
```

2. **Install repository hooks**
```bash
$ pre-commit install
```

Now you are ready to make consistent and valuable Terraform commits. Every `git commit` that you run have a check on the repository hooks before being committed to Git

### Hooks

The current environment uses the following pre-commit hooks:
- **terraform_tflint**: This hook runs [tflint](https://github.com/terraform-linters/tflint), a Terraform linter, on your code. It helps in identifying potential issues and errors in your Terraform configurations, such as syntax errors, deprecated syntax, and unsuitable module configurations. tflint can catch errors that are not detected by `terraform validate` command.
- **terraform_fmt**: This hook executes the `terraform fmt` command, which automatically updates Terraform configuration files to conform to a consistent format. It's useful for maintaining code readability and standardizing formatting across your Terraform codebase. This ensures that all Terraform files adhere to the same styling and formatting guidelines.
- **terraform_validate**: Runs `terraform validate`, a command that checks whether a Terraform configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state. It's a crucial step in verifying that your code is free of basic errors before applying changes to your infrastructure.
- **terraform_providers_lock**: This hook is used to update or create a dependency lock file (`terraform.lock.hcl`) for Terraform providers. It ensures that the same versions of providers are used in every run, thereby enhancing consistency and reducing the chances of encountering unexpected changes due to provider updates.
- **terraform_docs**: This hook generates or updates documentation in your Terraform modules. It extracts information from Terraform configurations (like inputs, outputs, and module descriptions) and writes it to README.md. This is particularly helpful in keeping documentation up-to-date with the code.

> You can check another Terraform pre-commit hooks [here](https://github.com/antonbabenko/pre-commit-terraform)

## Adding a new Salesforce table

To add a new object extraction to Appflow, all we need to do is fulfill the [`terraform.tfvars.json`](./stacks/ingestion/appflow/terraform.tfvars.json) inside [`stacks/ingrestion/appflow`](./stacks/ingestion/appflow/) and then apply terraform changes to create the new resource.

The `appflow_sources` variable that we populate the JSON accepts the following fields:
- **`connector_type`** (string): This is the type of the connector. Currently, the code only supports "Salesforce"
- **`object`** (string): The table object that we will extract using the flow.
- **`description`** (string, optional): Description of the flow. Defaults to "Data Stack Project Appflow Flow".
- **`map_all`** (bool, optional) Whether we map all object fields. If provided as "false", we need to write all desired columns. Defaults to true
- **`incremental`** (bool, optional): If "true", the table will be treated as d-1 incremental, which will change the s3 path from `s3://<bucket>/<source>/<execution_id>` to `s3://<bucket>/<source>/<year>/<month>/<day>/<execution_id>`. Defaults to false
- **`enable_dynamic_field_update`** (bool, optional): Set to "true" to enable dynamic field update, which allows changes on table schema. Defaults to "false"

Here's an example of how you might configure terraform.tfvars.json:
```json
{
"appflow_sources": [
    {
     "connector_type": "Salesforce",
     "object": "Account",
     "description": "Salesforce Account Data",
     "incremental": false
    },
    {
     "connector_type": "Salesforce",
     "object": "Lead",
     "map_all": true,
     "incremental": false,
     "enable_dynamic_field_update": false
    }
]
}
```

After editing the JSON file, all you need to do is run
```sh
$ cd stacks/ingestion/appflow
$ terraform apply
```

### Expected Changes
For each source in the `appflow_sources` variable, a corresponding Appflow flow will be created 