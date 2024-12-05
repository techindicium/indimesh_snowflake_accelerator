terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.38.0"
    }

    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 0.70.0"

      configuration_aliases = [
        snowflake.storage_integration_role,
      ]
    }
  }
}