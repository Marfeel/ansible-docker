FROM ubuntu:18.04
ARG TF_VERSION="0.12.24"

RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible-2.8 && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y \
        python3.7 \
        python3-pip \
        python-pip \
        git \
        curl \
        jq \
        python3-requests \
        rsync \
        wget \
        unzip \
        ansible && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install jmespath ansible-lint && \
    pip install jmespath

RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

RUN groupadd -g 1004 jenkins && \
    useradd -d /home/jenkins -m -r -u 1004 -g jenkins jenkins

RUN \
    mkdir -p /home/jenkins/.ssh/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

RUN \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_0.12.24_linux_amd64.zip -d /usr/local/bin/

USER jenkins
