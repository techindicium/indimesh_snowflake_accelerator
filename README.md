# Snowflake Base Module
This repository contains a Terraform module for provisioning Snowflake resources.

# Testing and Quality Assurance

**Static Analysis Test**

The test to ensure the Terraform code adheres to coding standards and guidelines. The following tools have been utilized for this test:

1. **terraform validate**: This command checks the syntax validity and structure of the Terraform code, ensuring that resources are correctly defined and referenced.

2. **tfLint**: tfLint is a code analysis tool that looks for common errors, best practices, and potential security issues in the Terraform code.

3. **Conftest in REGO**: The policies was written in REGO and applied Conftest to validate if the terraform code complies with internal standards and security regulations.


**Integration Test**

In addition to static analysis tests, interaction tests with the module using Terratest have been performed. Terratest is a testing framework that enables automation of infrastructure tests in a real environment. The interaction tests verify:

1. Successful Provisioning: The team has verified whether the module successfully provisions Snowflake resources as specified in the Terraform code.

2. Expected Behavior: Validation has been conducted to ensure that the provisioned resources behave as expected and that parameters are configured correctly.

These tests ensure that the Terraform code functions as intended and that future changes do not break the existing infrastructure.