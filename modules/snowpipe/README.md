# Snowflake Pipe infrastructure

This Terraform code automates the creation of a Snowflake Pipe, which is used for continuous data ingestion into a Snowflake table. It utilizes the `snowflake` provider to manage resources in Snowflake and the `snowsql` provider for future potential integrations.

## Table of contents

1. [Providers used](#providers-used)
2. [Resource created](#resource-created)
3. [Pipe configuration](#pipe-configuration)
4. [Dependencies and flow](#dependencies-and-flow)
5. [Variables used](#variables-used)
6. [TL;DR](#tldr)

## Providers used

### 1. Snowflake
- **Source:** `Snowflake-Labs/snowflake`
- **Version:** `0.70.0`
- **Aliases:**
  - `sys_admin`: Used to manage Snowflake resources, including pipes.
  - `security_admin`: Not used in this code, but set for future administrative tasks.

### 2. Snowsql
- **Source:** `aidanmelen/snowsql`
- **Version:** `1.3.3`
- **Aliases:**
  - `sys_admin`: Available for future command execution but not used in this specific code.
  - `security_admin`: Set for future use in Snowflake administrative commands.

## Resource created

### Snowflake Pipe
- **Resource:** `snowflake_pipe.pipe`
- **Description:** Creates a Snowflake pipe for continuous data ingestion.
- **Parameters:**
  - `database`: The database where the pipe will be created, defined by `var.database_name`.
  - `schema`: The schema in which the pipe will be created, defined by `var.schema_name`.
  - `name`: The name of the pipe, provided by `var.pipe_name`.
  - `copy_statement`: The SQL `COPY INTO` statement that defines the data ingestion process, including the target table and stage. It uses the `match_by_column_name` setting to ensure case-insensitive matching of column names.
  - `auto_ingest`: Enables automatic ingestion when new data arrives in the stage.
  - `aws_sns_topic_arn`: The ARN of the AWS SNS topic to notify for new data arrivals, provided by `var.sns_topic`.

## Pipe configuration

- **`copy_statement`:** 
  The `copy_statement` specifies the source and destination for the data ingestion, as well as additional parameters like `match_by_column_name = CASE_INSENSITIVE` to ensure column name matching does not depend on case sensitivity.
  
- **`auto_ingest`:**
  When set to `true`, Snowflake will automatically ingest data into the target table as soon as new data arrives in the specified stage.

- **`aws_sns_topic_arn`:**
  This parameter connects the pipe to an AWS SNS topic, which sends notifications about data ingestion events. It helps in automating notifications and monitoring.

## Dependencies and flow

1. **Pipe Creation:**
   - The `snowflake_pipe.pipe` resource is responsible for defining the Snowflake pipe that will automate data ingestion into the target table.
  
2. **Data Ingestion:**
   - The pipe continuously monitors the specified stage for new data and ingests it into the target table as per the `copy_statement`.
  
3. **SNS Notifications:**
   - Whenever data is ingested, the pipe triggers notifications via the specified AWS SNS topic, which can be used to alert systems or users about the ingestion status.

## Variables used

- **`var.database_name`:** The name of the Snowflake database in which the pipe is created.
- **`var.schema_name`:** The schema where the pipe is created.
- **`var.pipe_name`:** The name of the pipe.
- **`var.table_name`:** The target table where the data will be ingested.
- **`var.stage_name`:** The stage from which data will be copied into the table.
- **`var.sns_topic`:** The ARN of the AWS SNS topic to receive notifications about data ingestion.
- **`var.alert`:** Variable that defines whether or not the alert will be created for Snowpipes.
- **`var.warehouse`:** Warehouse name used by Snowflake alert.
- **`var.email`:** Email to which the snowpipe error alert will be sent.

## Costs

- **Alerts:** Considering that each alert is executed every hour, it is executed 720 times per month. Considering that an alert can consume 1 to 2 computational units that cost 2 and 4 credits respectively, we can estimate that each alert generates a monthly cost of **US$6 to US$12**, considering the cost of the credit at US$3.

- **Snowpipes:** The cost estimate for using Snowpipes depends on the serverless compute cost and the overhead rate per file.

  - **Compute:** Snowpipe uses a "serverless" compute model, where Snowflake automatically manages the resources needed to load data. The cost is calculated based on the time CPU cores are used (per second) while processing the files, following the serverless resource credit schedule. The price is 1.25× the standard cost of a virtual warehouse (example: if an X-Small warehouse costs 1 credit/hour, Snowpipe will cost 1.25 credits/hour for the same capacity).

  - **Overhead rate:** In addition to compute, there is a fixed cost of 0.06 credits for every 1,000 files processed, regardless of whether the data is loaded successfully or not. This cost covers the management of notifications and queues.

  So, using an example of a single Snowpipe that processes 10 GB of data per day in files of 10 MB each (1,000 files/day), the calculation would be something like:

  - **Compute:** 1000 * 30 * 0.0004 = 12 credits
  - **Overhead:** (1000 * 30 / 1000) * 0.06 = 1.8 credits

  Considering the credit value between US$3 and US$4, the cost for this example Snowpipe would be somewhere between **US$41.4** and **US$55.2**.

## TL;DR

This Terraform configuration automates the creation of a Snowflake pipe, which facilitates continuous data ingestion into Snowflake tables. It sets up automatic data processing with an SNS notification mechanism for real-time monitoring.

### Benefits:
- **Automated Data Ingestion:** Data is automatically loaded into Snowflake when new data arrives at the stage.
- **Seamless Integration:** Supports integration with AWS SNS for real-time notifications.
- **Flexibility:** Allows easy configuration of source and target parameters for different use cases.

This module also creates alerts in Snowflake in case the Snowpipe corresponding to the alert fails.