# Multiarea Example

This example configures an multi business areas snowflake setup.

It creates 2 warehouses:

- dev_wrh
- prd_wrh

3 roles:

- hr_role
- ae_role
- dev_role

3 databases:

- hr_db
- dev_db
- prd_db

and 3 users:

- ae_user
- dev_user
- prd_user

Users with ae_role can read/write on dev_db, read on hr_db and read on prd_db
Users with prd_role can read/write on dev_db, read/write  on hr_db and read/write  on prd_db
Users with dev_user can only read on dev_db.

## Running the example

Configure your authentication using keys
You need securityadmin and sysadmin in the desired account.
Run:

```
terraform init
terraform apply
```
After running the tests on this module, you can run a terraform destroy command to tear down the created structure and set up one according to your needs.

```
terraform destroy
```