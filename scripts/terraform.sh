install_terraform() {
    apt-get update
    apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt update
    apt-get install terraform
}

install_tflint () {
    wget https://github.com/terraform-linters/tflint/releases/download/v0.48.0/tflint_linux_amd64.zip \
    && unzip tflint_linux_amd64.zip \
    && mv tflint /usr/local/bin/ \
    && rm tflint_linux_amd64.zip
}

install_conftest () {
    LATEST_VERSION=$(wget -O - "https://api.github.com/repos/open-policy-agent/conftest/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-)
    wget "https://github.com/open-policy-agent/conftest/releases/download/v${LATEST_VERSION}/conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz"
    tar xzf conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz
    mv conftest /usr/local/bin
}

run_terraform_init() {
    echo "${SNOWFLAKE_KEY_BASE64}" | base64 -d > "${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    chmod 600 snowflake_tf_snow_key.p8

    export SNOWFLAKE_PRIVATE_KEY_PATH="${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    cd "${BITBUCKET_CLONE_DIR}/tests"
    
    terraform init -backend-config="key=${BACKEND_KEY}" -backend-config="bucket=${BACKEND_BUCKET}" -backend-config="region=${AWS_REGION}" && terraform plan -out=tfplan && terraform show -json ./tfplan > tfplan.json
    cd -
}

run_static_analysis_test() {
    terraform validate
    tflint --init
    tflint
    conftest test ./tfplan.json -p policy/main.rego
}

run_integration_test() {
    go mod init snowflake-base
    go get github.com/gruntwork-io/terratest/modules/terraform
    go test snowflake_base_test.go
}

METHODS=${1//,/ }

for TASK in $METHODS; do
    case "$TASK" in
        "setup_environment")
          install_terraform
          install_tflint
          install_conftest
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