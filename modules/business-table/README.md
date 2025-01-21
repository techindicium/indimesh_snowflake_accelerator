# Table infrastructure

This Terraform code automates the creation of tables in Snowflake based on configurations stored in JSON files. It uses two providers: `snowflake` to manage resources in Snowflake and `snowsql` for additional operations.

## Table of contents

1. [Providers used](#providers-used)
1. [Configuration structure](#configuration-structure)
1. [Local variables](#local-variables)
1. [Resource created](#resource-created)
1. [Dynamic iteration](#dynamic-iteration)
1. [Dependencies and flow](#dependencies-and-flow)
1. [Variables used](#variables-used)
1. [TL;DR](#tldr)

## Providers used

### 1. Snowflake
- **Source:** `Snowflake-Labs/snowflake`
- **Version:** `0.70.0`
- **Aliases:**
- `sys_admin`: For administrative operations, such as creating tables.
- `security_admin`: Defined for future use.

### 2. Snowsql
- **Source:** `aidanmelen/snowsql`
- **Version:** `1.3.3`
- **Aliases:**
- `sys_admin`: Not used in this code, but set for future command execution.
- `security_admin`: Set for future use.

## Configuration structure

### Configuration file (`tables/<table_name>.json`)
The JSON file specifies the tables and their columns, following the format:

```json
{
    "tables": [
        {
            "name": "table_name",
            "schema_name": "schema_name",
            "columns": [
                { "name": "column1", "type": "VARCHAR(255)" },
                { "name": "column2", "type": "INTEGER" }
            ]
        },
        {
            "name": "other_table",
            "schema_name": "schema_name",
            "columns": [
                { "name": "column1", "type": "BOOLEAN" }
            ]
        }
    ]
}
```

## Variables local

- **`local.tables_configure`:**
Decodes the JSON file corresponding to the table specified by the `var.table_name` variable. This file must contain all the definitions needed to create the tables.

- **`local.tables`:**
Generates a list of configured tables based on the contents of the JSON file, extracting the data for iterations on the `snowflake_table` resource.

## Resource created

### Tables in Snowflake
- **Resource:** `snowflake_table.tables_json`
- **Description:** Dynamically creates tables in Snowflake using the structure defined in the JSON file.
- **Parameters:**
- `name`: Table name, taken from the `name` property in the JSON.
- `database`: Database name, defined by the `var.database_name` variable.
- `schema`: Schema name, taken from the `name_schema` property in the JSON.
- **Dynamic Columns:**
- **Column Name:** Configured by the `columns[].name` property in the JSON.
- **Column Type:** Configured by the `columns[].type` property in the JSON.

### Dynamic block: columns
- The `dynamic "column"` block is used to create the columns of each table based on the list of columns defined in the JSON.
- For each column:
- The name and type are automatically extracted from the JSON, ensuring that each table is configured correctly.

## Dynamic iteration

- **`for_each` strategy:**
- Iterates over all tables configured in the JSON file.
- Each table is identified by its name, ensuring uniqueness in Snowflake.
- This allows you to create multiple tables efficiently, avoiding code redundancy.

- **Dynamic Column Block:**
Each table can have a variable number of columns, which are dynamically generated based on the list of columns configured in the JSON file.

## Dependencies and flow

1. **JSON file:**
The file located at `data/tables/<table_name>.json` defines the structure of each table, including name, schema, and columns.

2. **JSON decoding:**
The `local.tables` location converts the JSON configurations into a usable structure in Terraform.

3. **Table Creation:**
The tables are created iteratively, with their columns dynamically configured according to the JSON data.

## Variables used

- **`var.table_name`:**
Name of the JSON file that contains the table configurations (without the `.json` extension).

- **`var.database_name`:**
Name of the database where the tables will be created.

## TL;DR

This code uses the dynamic approach to manage table creation in Snowflake, leveraging external configurations stored in JSON files. It is especially useful for scenarios where multiple tables with different structures need to be created in an automated way, while maintaining flexibility and scalability.

### Benefits:
- Reduced manual work when configuring tables and columns.
- Ease of maintenance by centralizing configurations in JSON files.
- Scalability to add new tables or modify existing structures without changing the Terraform code.