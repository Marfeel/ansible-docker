FROM ubuntu:20.04
ARG TF_VERSION="0.12.24"
ARG ANSIBLE_VERSION="5.4.0"

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && \
    apt install --no-install-recommends -y software-properties-common \
    ca-certificates \
    curl \
    apt-transport-https \
    gpg-agent && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository ppa:deadsnakes/ppa && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    apt update && \
    apt install -y \
        python3.7 \
        python3-pip \
        git \
        jq \
        python3-dnspython \
        python3-requests \
        python3-passlib \
        rsync \
        wget \
        unzip \
        pwgen \
        awscli \
        docker-ce \
        libxml2-utils \
        npm && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install ansible==${ANSIBLE_VERSION} jmespath ansible-lint==${ANSIBLE_VERSION} jsonschema boto3 openshift==0.11.0 kubernetes==11.0.0 && \
    pip3 install -U PyYAML && \
    npm install -g sql-lint

RUN curl -L https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz -o /tmp/hub-linux-amd64-2.14.2.tgz && \
    tar zxvf /tmp/hub-linux-amd64-2.14.2.tgz -C /tmp/ && \
    bash /tmp/hub-linux-amd64-2.14.2/install && \
    rm -rf /tmp/hub-linux-amd64-2.14.2.tgz

RUN mkdir /etc/ansible/ && \
    touch /etc/ansible/hosts

RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_ed25519" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_ecdsa" >> /etc/ssh/ssh_config && \
    echo "    IdentityFile ~/.ssh/id_dsa" >> /etc/ssh/ssh_config

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

RUN groupadd -g 1004 jenkins && \
    useradd -d /home/jenkins -m -r -u 1004 -g jenkins jenkins

RUN \
    mkdir -p /home/jenkins/.ssh/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

RUN \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin/

USER jenkins
