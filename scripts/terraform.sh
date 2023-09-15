run_terraform_init() {
    echo "${SNOWFLAKE_KEY_BASE64}" | base64 -d > "${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    chmod 600 snowflake_tf_snow_key.p8

    export SNOWFLAKE_PRIVATE_KEY_PATH="${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    cd "${BITBUCKET_CLONE_DIR}/tests"
    
    terraform init -backend-config="key=${BACKEND_KEY}" -backend-config="bucket=${BACKEND_BUCKET}" -backend-config="region=${AWS_REGION}"
    terraform plan
    cd -
}

run_static_analysis_test() {
    cd "${BITBUCKET_CLONE_DIR}/tests"
    terraform validate
    tflint --init
    tflint
    terraform plan -out=tfplan && terraform show -json ./tfplan > tfplan.json
    conftest test ./tfplan.json -p policy/main.rego
    cd -
}

run_integration_test() {
    cd "${BITBUCKET_CLONE_DIR}/tests"
    go mod init snowflake-base
    go get github.com/gruntwork-io/terratest/modules/terraform
    go test snowflake_base_test.go
    cd -
}

METHODS=${1//,/ }

for TASK in $METHODS; do
    case "$TASK" in
        "setup_environment")
          run_terraform_init
          ;;
        "static_analysis_test")
          run_static_analysis_test
          ;;
        "integration_test")
          run_integration_test
          ;;
        *)
          echo "Invalid TASK: $TASK"
          exit 1
          ;;
    esac
done