FROM golang:latest

# terraform
RUN apt-get update && apt-get install -y unzip
RUN apt-get install -y gnupg software-properties-common
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update
RUN apt-get install terraform

# tflint
RUN wget https://github.com/terraform-linters/tflint/releases/download/v0.48.0/tflint_linux_amd64.zip \
    && unzip tflint_linux_amd64.zip \
    && mv tflint /usr/local/bin/ \
    && rm tflint_linux_amd64.zip

RUN curl -sL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# conftest
RUN LATEST_VERSION=$(wget -O - "https://api.github.com/repos/open-policy-agent/conftest/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-) && \
    wget "https://github.com/open-policy-agent/conftest/releases/download/v${LATEST_VERSION}/conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz" && \
    tar xzf "conftest_${LATEST_VERSION}_Linux_x86_64.tar.gz" && \
    mv conftest /usr/local/bin