FROM ubuntu:18.04

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
    pip3 install jmespath ansible-lint jsonschema && \
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

RUN   echo "127.0.0.10\tlive.mrf.io" >> /etc/hosts
RUN   echo "127.0.0.10\tliveint.mrf.io" >> /etc/hosts
RUN   echo "127.0.0.10\td1gmjfhqrg3vai.cloudfront.net"  >> /etc/hosts
RUN   echo "127.0.0.10\tamp.washingtontimes.com" >> /etc/hosts

USER jenkins
