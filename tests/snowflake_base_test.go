package test

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSnowflakeModule(t *testing.T) {
	t.Parallel()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: ".",
		NoColor: false,
	})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	warehouseName := terraform.Output(t, terraformOptions, "warehouse_name")
	warehouseSize := terraform.Output(t, terraformOptions, "warehouse_size")
	databaseName := terraform.Output(t, terraformOptions, "database_name")
	databaseRoleName := terraform.Output(t, terraformOptions, "database_role_name")
	warehouseRoleName := terraform.Output(t, terraformOptions, "warehouse_role_name")
	teamRoleName := terraform.Output(t, terraformOptions, "team_role_name")
	schemaRoleName := terraform.Output(t, terraformOptions, "schema_name")

	assert.Equal(t, "WH_TEST", warehouseName)
	assert.Equal(t, "X-Small", warehouseSize)
	assert.Equal(t, "TEST_DATABASE", databaseName)
	assert.Equal(t, "TEST_DATABASE_ROLE", databaseRoleName)
	assert.Equal(t, "TEST_WH_ROLE", warehouseRoleName)
	assert.Equal(t, "TEST_TEAM_ROLE", teamRoleName)
	assert.Equal(t, "schema_test", schemaRoleName)

	fmt.Println("INFO: Snowflake Base module test has been successfully passed.")
}
