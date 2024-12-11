install_terraform() {
    apt-get update
    apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt update
    apt-get install terraform
}

run_terraform_init() {
    echo "${SNOWFLAKE_KEY_BASE64}" | base64 -d > "${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    chmod 600 snowflake_tf_snow_key.p8

    export SNOWFLAKE_PRIVATE_KEY_PATH="${BITBUCKET_CLONE_DIR}/snowflake_tf_snow_key.p8"
    cd "${BITBUCKET_CLONE_DIR}/tests"
    
    terraform init -backend-config="key=${BACKEND_KEY}" -backend-config="bucket=${BACKEND_BUCKET}" -backend-config="region=${AWS_REGION}"
}

run_go_test() {
    go mod init warehouse
    go get github.com/gruntwork-io/terratest/modules/terraform
    go test snowflake_base_test.go
}

install_terraform
run_terraform_init
run_go_test