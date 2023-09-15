run_terraform_init() {
    echo "${SNOWFLAKE_KEY_BASE64}" | base64 -d > "${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    chmod 600 snowflake_tf_snow_key.p8

    export SNOWFLAKE_PRIVATE_KEY_PATH="${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    cd "${BITBUCKET_CLONE_DIR}/tests"
    
    terraform init -backend-config="key=${BACKEND_KEY}" -backend-config="bucket=${BACKEND_BUCKET}" -backend-config="region=${AWS_REGION}"
}

run_static_analysis_test() {
    run_terraform_init
    terraform plan -out=tfplan && terraform show -json ./tfplan > tfplan.json  || exit 1
    terraform validate || exit 1
    tflint --init  || exit 1
    tflint  || exit 1
    conftest test ./tfplan.json -p policy/main.rego || exit 1
}

run_integration_test() {
    run_terraform_init
    go mod init snowflake-base
    go get github.com/gruntwork-io/terratest/modules/terraform
    go test snowflake_base_test.go  || exit 1
}

METHODS=${1//,/ }

for TASK in $METHODS; do
    case "$TASK" in
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