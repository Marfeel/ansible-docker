FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt install -y python3.7 git curl jq && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/* 

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

USER jenkins
